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

```r
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
```
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
```
---
## Uso del proyecto

##1. Limpieza de datos

Coloca el archivo de microdatos de Defunciones Registradas 2024 en la carpeta data/raw/.

Ejecuta el script de limpieza:

```r
source("R/01_read_clean.R")
```
Este script:
	•	Filtra los registros correspondientes a presuntos homicidios.
	•	Construye variables analíticas clave:
	  •	Sexo
	  •	Edad y grupos de edad
	  •	Tipo de espacio de ocurrencia
	  •	Nacionalidad
	  •	Racialización (condición indígena y afromexicana)
	  •	Tipo de entidad federativa (frontera norte, frontera sur y no fronteriza)
	•	Genera la base limpia homicidios_2024_clean.csv en la carpeta data/processed/.
---
##2. Análisis exploratorio

Una vez generada la base limpia, ejecuta:
```r
source("R/02_exploratory_analysis_homicidios_2024.R")
```
Este script produce:
	•	Visualizaciones asociadas a cada uno de los tres hallazgos principales.
	•	Tablas de apoyo para la interpretación de los resultados.

Las figuras se guardan automáticamente en la carpeta outputs/figures/.
---
Principales hallazgos

1. Tipo de espacio y sexo

Aunque la mayoría de los homicidios ocurre en espacios públicos, este patrón no es igual para hombres y mujeres. Mientras que los homicidios de hombres se concentran principalmente en el espacio público, una proporción considerable de los homicidios de mujeres ocurre dentro de viviendas. Este hallazgo subraya la importancia de considerar el ámbito doméstico como un espacio clave para la prevención de la violencia letal contra las mujeres.

---

2. Nacionalidad y territorio

Los homicidios de personas extranjeras se concentran proporcionalmente más en estados fronterizos, tanto del norte como del sur, en comparación con los homicidios de personas de nacionalidad mexicana. Este patrón es especialmente relevante en un contexto de alta movilidad migratoria y sugiere que las zonas fronterizas representan espacios de mayor exposición a la violencia letal para personas extranjeras, sin invisibilizar la violencia que también afecta a la población mexicana.

---

3. Edad, sexo y racialización

La distribución de los homicidios a lo largo del ciclo de vida varía según el sexo y la racialización. Entre las personas no racializadas, la distribución por edad es relativamente similar entre hombres y mujeres, concentrándose principalmente en edades jóvenes y adultas. En contraste, entre las personas racializadas se observan diferencias más marcadas entre hombres y mujeres, lo que apunta a desigualdades estructurales que requieren enfoques diferenciados de prevención y atención, particularmente para mujeres racializadas en etapas adultas y adultas mayores.

---

Notas metodológicas
	•	Los porcentajes presentados corresponden a proporciones dentro de cada grupo analizado.
	•	La racialización se construye a partir de la autoidentificación indígena y afromexicana reportada en los microdatos.
	•	Los resultados deben interpretarse como análisis descriptivos y exploratorios, no como evidencia causal.
