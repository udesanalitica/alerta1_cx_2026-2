# Alerta1_Cx_2025-1

Este repositorio contiene el sitio web generado en [Quarto](https://quarto.org) para la línea de análisis académico de la **Alerta 1 Temprana UDES** correspondiente al periodo 2025-1.

📍 Sitio web en línea:  
👉 [https://analiticaudes.github.io/Alerta1_Cx_2025-1](https://analiticaudes.github.io/Alerta1_Cx_2025-1)

---

## 📘 Descripción

El propósito de este sitio es la caracterización de los estudiantes de reciente ingreso para el periodo 2025-1, en todos los campus de la Universidad de Santander mediante visualizaciones interactivas.

El contenido incluye:
- Informe descriptivo por todos los campues e indivualmente Bucaramanga, Cúcuta y Valledupar.
- Visualizaciones con `ggplot2` y `plotly`.
- Tableros integrados desde Tableau Public.
- Tablas dinámicas y resumenes por municipio y departamento.
- Entre otras visualizaciones

---

## 📁 Estructura del proyecto
Alerta1_Cx_2025-1/
├── .quarto/                  # Configuración adicional de Quarto
├── data/                     # Archivos de datos fuente
├── Divipola/                 # Archivos geográficos (GeoJSON, Excel DIVIPOLA)
├── docs/                     # Salida HTML publicada en GitHub Pages
├── images/                   # Imágenes utilizadas en el sitio
├── renv/                     # Entorno de paquetes R (renv)
├── Sesion1_files/            # Recursos generados por Quarto para Sesión 1
├── Shapes/                   # Archivos shapefile (mapas vectoriales)
├── .gitignore                # Exclusiones de Git
├── _quarto.yml               # Configuración global del sitio Quarto
├── apa.csl                   # Estilo de citación APA para referencias
├── colombia-municipios.json # GeoJSON de municipios colombianos
├── DIVIPOLA_Municipios.R    # Script para carga y manejo DIVIPOLA
├── index.qmd                # Página principal del informe
├── index.tex                # Plantilla LaTeX base (opcional)
├── Conclusiones.qmd         # Documento de conclusiones
├── references.qmd           # Bibliografía y enlaces
├── README.md                # Este archivo README
├── intro.qmd                # Introducción general
├── header.qmd               # Encabezado reutilizable (inclusión)
├── filtro.qmd               # Filtros para tablas/quizzes (interactivo)
├── style.scss               # Estilos personalizados del sitio
├── Libro1.R                 # Análisis u objetos auxiliares
├── Sesion0.R, Sesion1.R...  # Scripts por sesión (0 a 4)
├── Rplots.pdf               # Gráficos exportados desde R
├── renv.lock                # Registro de versiones de paquetes


---

## ⚙️ Requisitos

Este proyecto fue desarrollado en R 4.3+ con los siguientes paquetes:

- `dplyr`, `ggplot2`, `tmap`, `leaflet`, `plotly`, `readxl`
- `kableExtra`, `sf`, `geojsonio`, `htmltools`, `quarto`

Instalación recomendada:

```r
install.packages(c(
  "dplyr", "ggplot2", "tmap", "leaflet", "plotly",
  "readxl", "kableExtra", "sf", "geojsonio", "htmltools"
))

▶️ Ejecución local: quarto preview

▶️ Para publicar en GitHub Pages: quarto publish gh-pages

🌐 Fuentes de datos
Los datos utilizados provienen de:

Master: Sistema de Gestión Administrativa y Académica, 2025-1.
Tableros de Tableau Public asociados al proceso de caracterización.

Universidad de Santander – Campus Cúcuta. (2025). Alerta Temprana Académica UDES 2025-1. https://analiticaudes.github.io/Alerta1_Cx_2025-1

