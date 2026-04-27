# =========================================================
# PIPELINE DE LIMPIEZA BASE CARACTERIZACIÓN 2026-1
# =========================================================

library(readxl)
library(dplyr)
library(stringr)
library(janitor)
library(stringi)
library(forcats)
library(writexl)

# 1. Cargar base
datos_raw <- read_excel("data/data20261.xlsx")

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
datos <- datos %>%
  mutate(
    campus = case_when(
      str_detect(str_to_lower(campus), "bucaramanga") ~ "Bucaramanga",
      str_detect(str_to_lower(campus), "cucuta|cúcuta") ~ "Cucuta",
      str_detect(str_to_lower(campus), "valledupar") ~ "Valledupar",
      TRUE ~ campus
    )
  )

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
write_xlsx(datos, "data/data20261_limpia.xlsx")

# 15. Guardar diagnóstico de categorías
write_xlsx(
  list(
    resumen_categorias = resumen_categorias,
    alta_cardinalidad = variables_alta_cardinalidad
  ),
  "data/diagnostico_categorias.xlsx"
)