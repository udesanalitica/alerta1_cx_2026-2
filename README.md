# Sistema de Alerta Temprana - Alerta1_Cx_2025-1

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Repo size](https://img.shields.io/github/repo-size/AnaliticaUDES/Alerta1_Cx_2025-1)
![Last commit](https://img.shields.io/github/last-commit/AnaliticaUDES/Alerta1_Cx_2025-1)
![FAIR Data](https://img.shields.io/badge/FAIR-Data-blue)


## Descripción

Este repsositorio contiene el sitio web generado con Quarto para la caracterización  de la cohorte 2025-1 de estudiantes de la Universidad de Santander (UDES). 
Su objetivo es brindar una herramienta visual e interactiva para el análisis territorial de origen de los estudiantes, 
apoyado en herramientas de ciencia de datos, georreferenciación y visualización avanzada.

## Estructura del proyecto

```
Alerta1_Cx_2025-1/
├── _quarto.yml              # Configuración general del sitio Quarto
├── index.qmd                # Página principal del sitio
├── Conclusiones.qmd         # Sección de conclusiones del análisis
├── /data                    # Archivos de datos utilizados (.xlsx, .csv)
├── /docs                    # Archivos HTML generados (salida del sitio)
├── Sesion0.R, Sesion1.R...  # Scripts por sesión (0 a 4)
├── /images                  # Recursos gráficos utilizados
├── /shapes                  # Capas geográficas (GeoJSON u otros)
├── README.md                # Este archivo
└── *.R                      # Scripts utilizados en el análisis
```

## Requisitos

Este proyecto fue desarrollado con R 4.3+ y Quarto. Las principales librerías utilizadas fueron:

```
**Manipulación y análisis**: dplyr, tidyverse, psych, skimr, summarytools, Hmisc
**Visualización**: ggplot2, plotly, corrplot, ggpubr, ggrepel, scales, lattice
**Tablas y estilos**: kableExtra, htmltools
**Datos espaciales**: sf, geojsonio, tmap, leaflet
**Lectura de datos**: readxl, jsonlite
```

```
install.packages(c(
  "dplyr", "ggplot2", "plotly", "readxl", "sf", "geojsonio",
  "leaflet", "tmap", "kableExtra", "htmltools", "psych",
  "skimr", "summarytools", "corrplot", "ggpubr", "Hmisc",
  "ggrepel", "tidyverse", "scales", "lattice", "jsonlite"
))
```

## Navegación del sitio

El sitio se encuentra publicado en: https://analiticaudes.github.io/Alerta1_Cx_2025-1/

Secciones principales:
```
Inicio – Presentación del sistema de alerta territorial
Sesion0.R, Sesion1.R...  # Scripts por sesión (0 a 6)
Conclusiones – Principales hallazgos y líneas de acción
Fuentes y marcos metodológicos
```

## Licencia

Este proyecto se publica bajo la Licencia MIT. Puedes usar, modificar y distribuir el contenido siempre que se dé el debido crédito.

## Palabras clave

datos-territoriales · quarto · alerta-temprana · visualización · rstats · georreferenciación · educación-superior · ciencia-de-datos

## Citación
Por favor cite el dataset y el reporte como se muestra

```bibtex
@techreport{PerezPulido2025,
  author       = {Pérez, M., León, F., Pinto, L., y Mejía, O.},
  title        = {Documento de Analítica Académica No 28. Caracterización de estudiantes presenciales de pregrado recién ingreso periodo 2025-1.},
  institution  = {Universidad de Santander (UDES)},
  year         = {2025},
  note         = {Vicerrectoria de Enseñanza},
  url          = {https://analiticaudes.github.io/Alerta1_Cx_2025-1/},
  type         = {Informe técnico}
}
```

## Cumplimiento FAIR

Este conjunto de datos cumple con los principios FAIR (Encontrable, Accesible, Interoperable y Reutilizable):

- **Encontrable**: Identificadores únicos y metadatos indexados.
- **Accesible**: Licencia abierta CC-BY 4.0.
- **Interoperable**: Formatos estándar legibles por máquina.
- **Reutilizable**: Documentación completa y condiciones claras de uso.

🔗 Consulta el detalle completo en [`fair/fair-compliance.md`](./fair/fair-compliance.md).


## Agradecimientos
Este proyecto ha sido posible gracias al trabajo colaborativo de múltiples actores institucionales y académicos. Agradecemos especialmente a
las y los estudiantes que participaron de manera voluntaria en las caracterizaciones y encuestas.

## Contribución y Contacto

Este proyecto es liderado por la dirección de Analítica Académica de la UDES.

## ¿Tienes aportes o sugerencias?

Puedes: Contactar a través del correo institucional: analitica.academica@udes.edu.co

Las contribuciones son siempre bienvenidas. Puedes clonar, bifurcar o enviar pull requests desde el repositorio principal: ## https://github.com/AnaliticaUDES/Alerta1_Cx_2025-1

## doi
https://doi.org/10.5281/zenodo.15832245

¡Gracias por su interés!
