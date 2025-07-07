## Alerta1_Cx_2025-1 – Sistema de Alerta Temprana Territorial

📌 Descripción

Este repsositorio contiene el sitio web generado con Quarto para la caracterización  de la cohorte 2025-1 de estudiantes de la Universidad de Santander (UDES). Su objetivo es brindar una herramienta visual e interactiva para el análisis territorial de origen de los estudiantes, apoyado en herramientas de ciencia de datos, georreferenciación y visualización avanzada.

📂 Estructura del proyecto

Alerta1_Cx_2025-1/
├── _quarto.yml               # Configuración general del sitio Quarto
├── index.qmd                # Página principal del sitio
├── Conclusiones.qmd         # Sección de conclusiones del análisis
├── /data                    # Archivos de datos utilizados (.xlsx, .csv)
├── /docs                    # Archivos HTML generados (salida del sitio)
├── Sesion0.R, Sesion1.R...  # Scripts por sesión (0 a 4)
├── /images                  # Recursos gráficos utilizados
├── /shapes                  # Capas geográficas (GeoJSON u otros)
├── README.md                # Este archivo
└── *.R                      # Scripts utilizados en el análisis

## ⚙️ Requisitos

Este proyecto fue desarrollado con R 4.3+ y Quarto. Las principales librerías utilizadas fueron:

Manipulación y análisis: dplyr, tidyverse, psych, skimr, summarytools, Hmisc
Visualización: ggplot2, plotly, corrplot, ggpubr, ggrepel, scales, lattice
Tablas y estilos: kableExtra, htmltools
Datos espaciales: sf, geojsonio, tmap, leaflet
Lectura de datos: readxl, jsonlite

install.packages(c(
  "dplyr", "ggplot2", "plotly", "readxl", "sf", "geojsonio",
  "leaflet", "tmap", "kableExtra", "htmltools", "psych",
  "skimr", "summarytools", "corrplot", "ggpubr", "Hmisc",
  "ggrepel", "tidyverse", "scales", "lattice", "jsonlite"
))

🧽 Navegación del sitio

El sitio se encuentra publicado en:🔗 https://analiticaudes.github.io/Alerta1_Cx_2025-1/

Secciones principales:

Inicio – Presentación del sistema de alerta territorial
Filtros – Exploración de variables por departamento y municipio
Conclusiones – Principales hallazgos y líneas de acción
Sesion0.R, Sesion1.R...  # Scripts por sesión (0 a 4)
Fuentes y marcos metodológicos

👩‍🏫 Contribución y Contacto

Este proyecto es liderado por la dirección de Analítica Académica de la UDES.

¿Tienes aportes o sugerencias? Puedes: Contactar a través del correo institucional: analitica.academica@udes.edu.co

📜 Licencia

Este proyecto se publica bajo la Licencia MIT. Puedes usar, modificar y distribuir el contenido siempre que se dé el debido crédito.

🍿 Temas clave

datos-territoriales · quarto · alerta-temprana · visualización · rstats · georreferenciación · educación-superior · ciencia-de-datos

📑 Citation
Please cite the dataset and report as follows:

@techreport{PerezPulido2025,
  author       = {Pérez Pulido, Miguel Oswaldo and León, Francisco Javier and Pinto Guarguatí, Leonardo Andrés and Mejía Ardila, Omar Camilo},
  title        = {Sistema de alerta temprana para la caracterización de la población estudiantil en riesgo académico en la Universidad de Santander - Alerta1\_Cx\_2025-1},
  institution  = {Universidad de Santander (UDES)},
  year         = {2025},
  note         = {Coordinación de Analítica Académica},
  url          = {https://analiticaudes.github.io/Alerta1_Cx_2025-1/},
  type         = {Informe técnico}
}




Hecho con ❤️ y R por Analítica Académica UDES.

