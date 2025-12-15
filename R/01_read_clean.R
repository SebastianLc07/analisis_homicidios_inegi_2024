# ============================================================
# 01_read_clean.R
# Lectura y limpieza de microdatos
# Defunciones Registradas INEGI 2024
# ============================================================

# ----------------------------
# 0. Paquetes
# ----------------------------
library(readr)
library(dplyr)
library(stringr)

# ----------------------------
# 1. Lectura de microdatos
# ----------------------------

edr_2024 <- read_csv(
  "~/Documents/DataCivica/conjunto_de_datos_edr2024_csv/conjunto_de_datos/conjunto_de_datos_defunciones_registradas24_csv.csv",
  show_col_types = FALSE
)

# ----------------------------
# 2. Limpieza de variables base
# ----------------------------

# ---- Edad ----
edr_2024 <- edr_2024 |>
  mutate(
    edad_anios = case_when(
      edad >= 4000 & edad <= 4500 ~ edad - 4000,
      TRUE ~ NA_real_
    )
  )

# ---- Sexo ----
edr_2024 <- edr_2024 |>
  mutate(
    sexo_cat = case_when(
      sexo == 1 ~ "Hombre",
      sexo == 2 ~ "Mujer",
      TRUE ~ "No especificado"
    )
  )

# ----------------------------
# 3. Identificación de presuntos homicidios
# ----------------------------

homicidios_2024 <- edr_2024 |>
  filter(
    anio_ocur == 2024,
    str_detect(causa_def, "^X8[5-9]|^X9[0-9]|^Y0[0-9]")
  )

# ----------------------------
# 4. Construcción de variables analíticas
# ----------------------------

# ---- Grupo de edad ----
homicidios_2024 <- homicidios_2024 |>
  mutate(
    grupo_edad = case_when(
      edad < 4000 ~ "Menores de 1 año",
      edad_anios < 10 ~ "Infancias (1–9)",
      edad_anios < 20 ~ "Adolescentes (10–19)",
      edad_anios < 36 ~ "Jóvenes (20–35)",
      edad_anios < 60 ~ "Adultos (36–59)",
      edad_anios >= 60 ~ "Adultos mayores (60+)",
      TRUE ~ "Edad no especificada"
    )
  )

# ---- Condición indígena ----
homicidios_2024 <- homicidios_2024 |>
  mutate(
    conindig_cat = case_when(
      conindig == 1 ~ "Indígena",
      conindig == 2 ~ "No indígena",
      TRUE ~ "No especificada"
    )
  )

# ---- Población afromexicana ----
homicidios_2024 <- homicidios_2024 |>
  mutate(
    afromex_cat = case_when(
      afromex == 1 ~ "Afromexicana",
      afromex == 2 ~ "No afromexicana",
      TRUE ~ "No especificada"
    )
  )

# ---- Nacionalidad ----
homicidios_2024 <- homicidios_2024 |>
  mutate(
    nacionalidad_cat = case_when(
      nacionalid == 1 ~ "Mexicana",
      nacionalid == 2 ~ "Extranjera",
      TRUE ~ "No especificada"
    )
  )

# ---- Lugar de ocurrencia (etiquetas originales) ----
# Etiquetas tomadas directamente del catálogo oficial INEGI
# ---- Lugar de ocurrencia (etiquetas originales) ----
# Etiquetas oficiales según catálogo INEGI

homicidios_2024 <- homicidios_2024 |>
  mutate(
    lugar_ocurrencia = case_when(
      lugar_ocur == 0  ~ "Vivienda particular",
      lugar_ocur == 1  ~ "Vivienda colectiva",
      lugar_ocur == 2  ~ "Escuela u oficina pública",
      lugar_ocur == 3  ~ "Área deportiva",
      lugar_ocur == 4  ~ "Calle o carretera (vía pública)",
      lugar_ocur == 5  ~ "Área comercial o de servicios",
      lugar_ocur == 6  ~ "Área industrial (fábrica u obra)",
      lugar_ocur == 7  ~ "Granja (rancho o parcela)",
      lugar_ocur == 8  ~ "Otro",
      lugar_ocur == 9  ~ "Se ignora",
      lugar_ocur == 88 ~ "No aplica para muerte natural",
      TRUE ~ "No especificado"
    )
  )

# ---- Entidad federativa de ocurrencia ----
homicidios_2024 <- homicidios_2024 |>
  mutate(
    entidad_ocurrencia = case_when(
      ent_ocurr == "01" ~ "Aguascalientes",
      ent_ocurr == "02" ~ "Baja California",
      ent_ocurr == "03" ~ "Baja California Sur",
      ent_ocurr == "04" ~ "Campeche",
      ent_ocurr == "05" ~ "Coahuila",
      ent_ocurr == "06" ~ "Colima",
      ent_ocurr == "07" ~ "Chiapas",
      ent_ocurr == "08" ~ "Chihuahua",
      ent_ocurr == "09" ~ "Ciudad de México",
      ent_ocurr == "10" ~ "Durango",
      ent_ocurr == "11" ~ "Guanajuato",
      ent_ocurr == "12" ~ "Guerrero",
      ent_ocurr == "13" ~ "Hidalgo",
      ent_ocurr == "14" ~ "Jalisco",
      ent_ocurr == "15" ~ "Estado de México",
      ent_ocurr == "16" ~ "Michoacán",
      ent_ocurr == "17" ~ "Morelos",
      ent_ocurr == "18" ~ "Nayarit",
      ent_ocurr == "19" ~ "Nuevo León",
      ent_ocurr == "20" ~ "Oaxaca",
      ent_ocurr == "21" ~ "Puebla",
      ent_ocurr == "22" ~ "Querétaro",
      ent_ocurr == "23" ~ "Quintana Roo",
      ent_ocurr == "24" ~ "San Luis Potosí",
      ent_ocurr == "25" ~ "Sinaloa",
      ent_ocurr == "26" ~ "Sonora",
      ent_ocurr == "27" ~ "Tabasco",
      ent_ocurr == "28" ~ "Tamaulipas",
      ent_ocurr == "29" ~ "Tlaxcala",
      ent_ocurr == "30" ~ "Veracruz",
      ent_ocurr == "31" ~ "Yucatán",
      ent_ocurr == "32" ~ "Zacatecas",
      TRUE ~ "No especificada"
    )
  )

# ---- Área urbana / rural ----
homicidios_2024 <- homicidios_2024 |>
  mutate(
    area_ur_cat = case_when(
      area_ur == 1 ~ "Urbana",
      area_ur == 2 ~ "Rural",
      TRUE ~ "No especificada"
    )
  )

# ----------------------------
# 5. Selección de variables finales
# ----------------------------

homicidios_2024_clean <- homicidios_2024 |>
  select(
    entidad_ocurrencia,
    sexo_cat,
    edad_anios,
    grupo_edad,
    conindig_cat,
    afromex_cat,
    nacionalidad_cat,
    lugar_ocurrencia,
    area_ur_cat
  )

# ----------------------------
# 6. Guardado de base limpia
# ----------------------------

write_csv(
  homicidios_2024_clean,
  "~/Documents/DataCivica/Ejercicio2/homicidios_2024_clean.csv"
)
