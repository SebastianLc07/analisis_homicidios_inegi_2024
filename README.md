# analisis_homicidios_inegi_2024

Análisis exploratorio de homicidios en México con microdatos del INEGI (2024).

---

## Descripción del proyecto

Este proyecto realiza un análisis exploratorio de los homicidios registrados en México durante 2024, utilizando los microdatos de **Defunciones Registradas** publicados por el INEGI. El objetivo es identificar patrones relevantes de la violencia letal desde una perspectiva de **género**, **territorio**, **nacionalidad** y **racialización**, con un enfoque accesible para audiencias interesadas en la problemática de la violencia en el país, pero con poca experiencia en el análisis de datos.

El análisis se centra en tres hallazgos principales:

1. Diferencias por sexo en el tipo de espacio donde ocurren los homicidios.
2. Distribución territorial de los homicidios según la nacionalidad de las personas fallecidas.
3. Cambios en la distribución de los homicidios a lo largo del ciclo de vida, considerando sexo y racialización.

---

## Fuente de datos

- **INEGI – Defunciones Registradas 2024**
- Microdatos a nivel individual
- Periodo de análisis: enero–diciembre de 2024
- Identificación de homicidios basada en la Clasificación Internacional de Enfermedades (CIE-10)

Los datos originales no se incluyen en este repositorio y deben obtenerse directamente desde la fuente oficial del INEGI.

---

## Estructura del repositorio

.
├── data/
│   ├── raw/                          # Datos originales (no incluidos)
│   └── processed/
│       └── homicidios_2024_clean.csv # Base limpia para análisis
├── outputs/
│   └── figures/                      # Gráficas generadas
├── R/
│   ├── 01_read_clean.R               # Lectura y limpieza de microdatos
│   └── 02_exploratory_analysis_homicidios_2024.R
├── README.md
└── .gitignore

---

## Requisitos

Este proyecto utiliza **R (≥ 4.0)** y los siguientes paquetes:

- `readr`
- `dplyr`
- `ggplot2`
- `scales`

Para instalar los paquetes necesarios:

```r
install.packages(c("readr", "dplyr", "ggplot2", "scales"))
Uso del proyecto

1. Limpieza de datos

Coloca el archivo original de microdatos de defunciones registradas en la carpeta data/raw/.

Ejecuta el script de limpieza:
