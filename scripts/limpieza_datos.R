# =========================================================
# PIPELINE DE LIMPIEZA BASE CARACTERIZACIÓN 2026-2
# =========================================================

library(readxl)
library(dplyr)
library(stringr)
library(janitor)
library(stringi)
library(forcats)
library(tidyr)
library(writexl)

# 1. Cargar base
datos_raw <- read_excel("data/data20262.xlsx")

# 2. Limpiar nombres de variables
datos <- datos_raw %>%
  clean_names()

# ===============================
# Proteger variables categóricas que NO deben volverse numéricas
# ===============================

datos <- datos %>%
  mutate(
    libros_ano = as.character(libros_ano)
  )

# ===============================
# Limpiar num_hijos sin perder valores
# ===============================

datos <- datos %>%
  mutate(
    num_hijos = as.character(num_hijos),
    num_hijos = str_trim(num_hijos),
    num_hijos = case_when(
      num_hijos %in% c("No", "No tiene", "Ninguno", "Ninguna", "Sin hijos", "0") ~ "0",
      TRUE ~ num_hijos
    ),
    num_hijos = suppressWarnings(as.numeric(num_hijos))
  )

# 3. Función para limpiar texto categórico
limpiar_texto <- function(x) {
  x %>%
    as.character() %>%
    str_trim() %>%
    str_squish() %>%
    str_replace_all("\n|\r|\t", " ") %>%
    na_if("") %>%
    na_if("NA") %>%
    na_if("N/A")
}

# 4. Aplicar limpieza textual a variables tipo texto
datos <- datos %>%
  mutate(across(where(is.character), limpiar_texto))

# 5. Convertir códigos "0" en NA para variables categóricas
datos <- datos %>%
  mutate(across(
    where(is.character),
    ~ case_when(
      .x %in% c("0", "00", "000") ~ NA_character_,
      str_to_lower(.x) %in% c("no aplica", "n/a", "na", "ninguno", "ninguna") ~ NA_character_,
      TRUE ~ .x
    )
  ))

# 6. Normalizar respuestas Sí / No
datos <- datos %>%
  mutate(across(
    where(is.character),
    ~ case_when(
      str_to_lower(.x) %in% c("si", "sí", "s") ~ "Sí",
      str_to_lower(.x) %in% c("no", "n") ~ "No",
      TRUE ~ .x
    )
  ))

# 7. Normalizar campus
source("scripts/utilidades.R", encoding = "UTF-8")
datos <- datos %>%
  mutate(campus = normalizar_campus(campus))

# 7a. Normalizar país de origen (ver scripts/utilidades.R)
datos <- datos %>%
  mutate(pais = normalizar_pais(pais))

# 7b. Definir quién respondió según la conciliación auditada de la encuesta.
# participa_encuesta identifica las respuestas vinculadas al estudiante correcto.
datos <- datos %>%
  mutate(
    respondio = if_else(
      str_to_lower(str_squish(as.character(participa_encuesta))) %in% c("si", "sí"),
      "Sí", "No"
    )
  )

# Base completa (para tasas de respuesta) y base de trabajo (solo quienes respondieron)
datos_total <- datos
datos <- datos %>% filter(respondio == "Sí")

# 8. Recodificar certificación de lengua
datos <- datos %>%
  mutate(
    cert_leng = case_when(
      cert_leng %in% c("Sí", "Si") ~ "Sí",
      cert_leng %in% c("No", "0") ~ "No",
      is.na(cert_leng) ~ "No",
      TRUE ~ cert_leng
    )
  )

# 9. Limpiar variables de edad: convertir 0 en NA
vars_edad <- c(
  "edad", "edad_psic", "edad_fuma", "edad_alc", "edad_sex"
)

vars_edad <- intersect(vars_edad, names(datos))

datos <- datos %>%
  mutate(across(
    all_of(vars_edad),
    ~ suppressWarnings(as.numeric(.x))
  )) %>%
  mutate(across(
    all_of(vars_edad),
    ~ ifelse(.x == 0, NA, .x)
  ))

# 10. Limpiar variables numéricas de conteo
vars_num <- c(
  "num_hijos", "cig_dia", "alc_semana",
  "libros_ano", "cuartos", "horas_sem"
)

vars_num <- intersect(vars_num, names(datos))

datos <- datos %>%
  mutate(across(
    all_of(vars_num),
    ~ suppressWarnings(as.numeric(.x))
  ))

# 11. Agrupar categorías pequeñas: función general
agrupar_top_n <- function(data, variable, n_top = 10) {
  var <- rlang::ensym(variable)
  
  top <- data %>%
    count(!!var, sort = TRUE) %>%
    filter(!is.na(!!var)) %>%
    slice_head(n = n_top) %>%
    pull(!!var)
  
  data %>%
    mutate(
      "{rlang::as_string(var)}_agrupada" := if_else(
        !!var %in% top,
        as.character(!!var),
        "Otros"
      )
    )
}

# Ejemplo de uso:
# datos <- agrupar_top_n(datos, pais, 10)
# datos <- agrupar_top_n(datos, trab_padre, 10)
# datos <- agrupar_top_n(datos, trab_madre, 10)

# 12. Validación de categorías por variable
resumen_categorias <- datos %>%
  summarise(across(
    where(is.character),
    ~ n_distinct(.x, na.rm = TRUE)
  )) %>%
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "n_categorias"
  ) %>%
  arrange(desc(n_categorias))

# 13. Detectar variables con posible exceso de categorías
variables_alta_cardinalidad <- resumen_categorias %>%
  filter(n_categorias > 20)

# 14. Guardar base limpia
write_xlsx(datos, "data/data20262_limpia.xlsx")

# 15. Guardar diagnóstico de categorías
write_xlsx(
  list(
    resumen_categorias = resumen_categorias,
    alta_cardinalidad = variables_alta_cardinalidad
  ),
  "data/diagnostico_categorias.xlsx"
)

# 16. Gráfico normalizado para respuestas múltiples y términos abiertos
grafico_ranking_respuestas <- function(
    data,
    variable,
    modo = c("categorias", "terminos"),
    top_n = 10,
    min_freq = 2,
    separador = "[,;/|]",
    equivalencias = NULL) {

  modo <- match.arg(modo)
  stopifnot(variable %in% names(data), "campus" %in% names(data))

  base <- tibble::tibble(
    id = seq_len(nrow(data)),
    campus = normalizar_campus(data$campus),
    respuesta = as.character(data[[variable]])
  ) %>%
    filter(!is.na(respuesta), str_squish(respuesta) != "")

  if (nrow(base) == 0) return(invisible(NULL))

  denominadores <- bind_rows(
    base %>% distinct(id) %>% mutate(grupo = "Todos"),
    base %>%
      filter(!is.na(campus)) %>%
      distinct(id, campus) %>%
      transmute(id, grupo = etiqueta_campus(campus))
  ) %>%
    count(grupo, name = "denominador")

  if (modo == "terminos") {
    exclusiones <- c(
      tm::stopwords("spanish"), "udes", "universidad", "santander",
      "porque", "para", "como", "pero", "más", "menos", "solo",
      "ninguno", "ninguna", "otros", "otras", "otro", "otra", "etc"
    )

    detalle <- base %>%
      mutate(
        respuesta = str_to_lower(respuesta),
        respuesta = str_replace_all(respuesta, separador, " "),
        categoria = str_extract_all(respuesta, "[[:alpha:]áéíóúüñ]+")
      ) %>%
      tidyr::unnest_longer(categoria) %>%
      mutate(categoria = str_squish(categoria)) %>%
      filter(
        str_length(categoria) > 2,
        !categoria %in% exclusiones
      )
  } else {
    detalle <- base %>%
      mutate(categoria = str_split(str_to_lower(respuesta), separador)) %>%
      tidyr::unnest_longer(categoria) %>%
      mutate(
        categoria = str_squish(categoria),
        categoria = str_replace_all(categoria, "^[[:punct:]\\s]+|[[:punct:]\\s]+$", "")
      ) %>%
      filter(
        categoria != "",
        !categoria %in% c(
          "0", "n/a", "na", "no aplica", "ninguno", "ninguna",
          "otros", "otras", "otro", "otra", "etc"
        )
      )
  }

  if (!is.null(equivalencias) && length(equivalencias) > 0) {
    reemplazar <- detalle$categoria %in% names(equivalencias)
    detalle$categoria[reemplazar] <- unname(equivalencias[detalle$categoria[reemplazar]])
  }

  detalle <- detalle %>%
    mutate(
      clave = stringi::stri_trans_general(categoria, "Latin-ASCII") %>% str_to_lower(),
      categoria = if (modo == "categorias") str_to_sentence(categoria) else categoria
    ) %>%
    group_by(clave) %>%
    mutate(categoria = categoria[which.max(nchar(categoria))]) %>%
    ungroup() %>%
    distinct(id, campus, clave, categoria)

  top <- detalle %>%
    count(clave, categoria, name = "n", sort = TRUE) %>%
    filter(n >= min_freq) %>%
    slice_head(n = top_n)

  if (nrow(top) == 0) return(invisible(NULL))

  orden <- top$categoria
  detalle <- detalle %>% filter(clave %in% top$clave)

  conteos <- bind_rows(
    detalle %>% mutate(grupo = "Todos"),
    detalle %>%
      filter(!is.na(campus)) %>%
      mutate(grupo = etiqueta_campus(campus))
  ) %>%
    count(grupo, categoria, name = "n")

  grupos <- c("Todos", "Bucaramanga", "Cúcuta", "Valledupar", "Bogotá")
  grafico <- tidyr::expand_grid(grupo = grupos, categoria = orden) %>%
    left_join(conteos, by = c("grupo", "categoria")) %>%
    mutate(n = coalesce(n, 0L)) %>%
    left_join(denominadores, by = "grupo") %>%
    mutate(
      porcentaje = if_else(denominador > 0, 100 * n / denominador, 0),
      etiqueta_categoria = etiqueta_dos_lineas(categoria, ancho = 34),
      etiqueta_valor = sprintf("%.1f%% (%s)", porcentaje, format(n, big.mark = "."))
    )

  colores <- c(
    "Todos" = "#123B66",
    "Bucaramanga" = color_campus("Bucaramanga"),
    "Cúcuta" = color_campus("Cucuta"),
    "Valledupar" = color_campus("Valledupar"),
    "Bogotá" = color_campus("Bogotá")
  )

  botones <- lapply(grupos, function(grupo_actual) {
    list(
      method = "restyle",
      args = list(list(
        "transforms[0].value" = grupo_actual,
        "marker.color" = unname(colores[grupo_actual])
      )),
      label = grupo_actual
    )
  })

  max_x <- max(grafico$porcentaje, na.rm = TRUE)

  plotly::plot_ly(
    grafico,
    x = ~porcentaje,
    y = ~etiqueta_categoria,
    type = "bar",
    orientation = "h",
    text = ~etiqueta_valor,
    textposition = "outside",
    cliponaxis = FALSE,
    customdata = ~cbind(n, denominador),
    hovertemplate = paste0(
      "<b>%{y}</b><br>",
      "Estudiantes: %{customdata[0]}<br>",
      "Base válida: %{customdata[1]}<br>",
      "Porcentaje: %{x:.1f}%<extra></extra>"
    ),
    marker = list(color = unname(colores["Todos"])),
    transforms = list(list(
      type = "filter",
      target = ~grupo,
      operation = "=",
      value = "Todos"
    ))
  ) %>%
    plotly::layout(
      height = max(380, 42 * length(orden) + 100),
      margin = list(l = 220, r = 100, t = 35, b = 60),
      xaxis = list(
        title = "Porcentaje de estudiantes con respuesta válida",
        range = c(0, max(5, max_x * 1.22)),
        ticksuffix = "%",
        rangemode = "tozero"
      ),
      yaxis = list(
        title = "",
        categoryorder = "array",
        categoryarray = rev(etiqueta_dos_lineas(orden, ancho = 34))
      ),
      updatemenus = list(list(
        type = "dropdown",
        active = 0,
        x = 1,
        y = 1.12,
        xanchor = "right",
        buttons = botones
      )),
      showlegend = FALSE,
      hovermode = "closest"
    )
}
