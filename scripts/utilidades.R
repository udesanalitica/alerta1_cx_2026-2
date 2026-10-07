# Utilidades compartidas por el pipeline y los capitulos del libro

# --- Pais de origen ---------------------------------------------------------
# Variantes de escritura de Colombia y ciudades/departamentos colombianos digitados
# como pais se agrupan en "Colombia"; el resto queda con la primera letra en mayuscula.
normalizar_pais <- function(x) {
  x <- stringr::str_squish(as.character(x))
  x[x == ""] <- NA_character_
  patron_colombia <- paste(
    c("colombia", "coombia", "colombian", "valledupar", "barrancabermeja", "bogot",
      "bosconia", "bucaramanga", "cesar", "c[u\u00fa]cuta", "guajira", "maicao"),
    collapse = "|"
  )
  res <- ifelse(
    is.na(x), NA_character_,
    ifelse(stringr::str_detect(stringr::str_to_lower(x), patron_colombia),
           "Colombia", stringr::str_to_sentence(x))
  )
  res[res %in% "Estados unidos"] <- "Estados Unidos"
  res
}

# --- Campus ---------------------------------------------------------------
# Canoniza los valores usados en filtros y agrupaciones. Las etiquetas pueden
# conservar la tilde mediante etiqueta_campus(), sin afectar las comparaciones.
normalizar_campus <- function(x) {
  original <- stringr::str_squish(as.character(x))
  original[original == ""] <- NA_character_
  clave <- stringr::str_to_lower(stringi::stri_trans_general(original, "Latin-ASCII"))
  dplyr::case_when(
    stringr::str_detect(clave, "bucaramanga") ~ "Bucaramanga",
    stringr::str_detect(clave, "cucuta") ~ "Cucuta",
    stringr::str_detect(clave, "valledupar") ~ "Valledupar",
    stringr::str_detect(clave, "bogota") ~ "Bogotá",
    TRUE ~ original
  )
}

etiqueta_campus <- function(x) {
  dplyr::recode(as.character(x), "Cucuta" = "Cúcuta")
}

# Divide etiquetas extensas en un máximo de dos líneas para gráficos HTML.
etiqueta_dos_lineas <- function(x, ancho = 34) {
  vapply(as.character(x), function(texto) {
    if (is.na(texto) || nchar(texto) <= ancho) return(texto)

    palabras <- stringr::str_split(stringr::str_squish(texto), "\\s+")[[1]]
    if (length(palabras) < 2) return(texto)

    cortes <- seq_len(length(palabras) - 1)
    largos_primera <- vapply(
      cortes,
      function(i) nchar(paste(palabras[seq_len(i)], collapse = " ")),
      integer(1)
    )
    corte <- cortes[which.min(abs(largos_primera - nchar(texto) / 2))]

    paste0(
      paste(palabras[seq_len(corte)], collapse = " "),
      "<br>",
      paste(palabras[(corte + 1):length(palabras)], collapse = " ")
    )
  }, character(1), USE.NAMES = FALSE)
}

# --- Paleta por campus ------------------------------------------------------
# Un solo color por campus (y "Todos") para todos los graficos que cambian de campus.
# Basada en la paleta Okabe-Ito (distinguible con daltonismo) y con buen contraste sobre blanco.
colores_campus <- c(
  "Todos"       = "#374151",
  "Bucaramanga" = "#0072B2",
  "C\u00facuta" = "#D55E00",
  "Cucuta"      = "#D55E00",
  "Valledupar"  = "#009E73",
  "Bogot\u00e1" = "#CC79A7"
)

color_campus <- function(campus) unname(colores_campus[as.character(campus)])
