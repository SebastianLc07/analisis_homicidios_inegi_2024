# ============================================================
# 02_exploratory_analysis.R
# Análisis exploratorio de homicidios
# Defunciones Registradas INEGI 2024
# ============================================================

# ----------------------------
# 0. Paquetes
# ----------------------------
library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# ----------------------------
# 1. Cargar la base de datos previamente procesada
# ----------------------------

homicidios <- read_csv(
  "~/Documents/DataCivica/Ejercicio2/homicidios_2024_clean.csv",
  show_col_types = FALSE
)

# ============================================================
# 2. Preparación de variables
# ============================================================

# ---- Lugar de ocurrencia (agrupado) ----
homicidios <- homicidios |>
  mutate(
    lugar_ocurrencia_grp = case_when(
      lugar_ocurrencia %in% c("Vivienda particular", "Vivienda colectiva") ~ "Vivienda",
      lugar_ocurrencia %in% c("Calle o carretera (vía pública)", "Área deportiva") ~ "Espacio público",
      lugar_ocurrencia %in% c(
        "Escuela u oficina pública",
        "Área industrial (fábrica u obra)",
        "Área comercial o de servicios"
      ) ~ "Espacio institucional / laboral",
      lugar_ocurrencia == "Granja (rancho o parcela)" ~ "Espacio rural",
      lugar_ocurrencia %in% c("Otro", "Se ignora", "No aplica para muerte natural") ~ "Otro / no especificado",
      TRUE ~ "Otro / no especificado"
    )
  )

homicidios$lugar_ocurrencia_grp <- factor(
  homicidios$lugar_ocurrencia_grp,
  levels = c(
    "Vivienda",
    "Espacio público",
    "Espacio institucional / laboral",
    "Espacio rural",
    "Otro / no especificado"
  )
)

# ---- Tipo de frontera ----
homicidios <- homicidios |>
  mutate(
    tipo_frontera = case_when(
      entidad_ocurrencia %in% c(
        "Baja California", "Sonora", "Chihuahua",
        "Coahuila", "Nuevo León", "Tamaulipas"
      ) ~ "Frontera norte",
      entidad_ocurrencia %in% c(
        "Chiapas", "Tabasco", "Campeche", "Quintana Roo"
      ) ~ "Frontera sur",
      TRUE ~ "No fronteriza"
    )
  )

homicidios$tipo_frontera <- factor(
  homicidios$tipo_frontera,
  levels = c("Frontera norte", "Frontera sur", "No fronteriza")
)

# ---- Racialización ----
homicidios <- homicidios |>
  mutate(
    racializada = case_when(
      conindig_cat == "Indígena" | afromex_cat == "Afromexicana" ~ "Racializada",
      conindig_cat == "No indígena" & afromex_cat == "No afromexicana" ~ "No racializada",
      TRUE ~ NA_character_
    )
  )

# ---- Grupo de edad recodificado ----
homicidios <- homicidios |>
  mutate(
    grupo_edad_rec = case_when(
      grupo_edad %in% c("Menores de 1 año", "Infancias (1–9)") ~ "Infancias (0–9)",
      grupo_edad == "Adolescentes (10–19)" ~ "Adolescentes (10–19)",
      grupo_edad == "Jóvenes (20–35)" ~ "Jóvenes (20–35)",
      grupo_edad == "Adultos (36–59)" ~ "Adultos (36–59)",
      grupo_edad == "Adultos mayores (60+)" ~ "Adultos mayores (60+)",
      TRUE ~ NA_character_
    )
  )

homicidios$grupo_edad_rec <- factor(
  homicidios$grupo_edad_rec,
  levels = c(
    "Infancias (0–9)",
    "Adolescentes (10–19)",
    "Jóvenes (20–35)",
    "Adultos (36–59)",
    "Adultos mayores (60+)"
  )
)

# ============================================================
# 3. Hallazgo 1: Género y tipo de espacio
# ============================================================

hlg1 <- homicidios |>
  filter(
    sexo_cat %in% c("Hombre", "Mujer"),
    lugar_ocurrencia_grp %in% c(
      "Vivienda",
      "Espacio público",
      "Espacio institucional / laboral"
    )
  ) |>
  count(sexo_cat, lugar_ocurrencia_grp) |>
  group_by(sexo_cat) |>
  mutate(prop = n / sum(n)) |>
  ungroup()


espacio_colors <- c(
  "Vivienda"                         = "#4E79A7",  
  "Espacio público"                  = "#E15759",  
  "Espacio institucional / laboral"  = "#59A14F"   
)

##grafica hlg1

plot_hlg1 <-
  ggplot(hlg1, aes(sexo_cat, prop, fill = lugar_ocurrencia_grp)) +
    geom_col(width = 0.7) +
    scale_y_continuous(labels = percent) +
    scale_fill_manual(values = espacio_colors) +
    labs(
      title = "Distribución de homicidios por tipo de espacio y sexo (2024)",
      subtitle = "Distribución calculada solo con vivienda, espacio público y espacio institucional/laboral",
      x = "Sexo",
      y = "Proporción",
      fill = "Tipo de espacio"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "right"
    )



# ============================================================
# 4. Hallazgo 2: Frontera y nacionalidad
# ============================================================

dist_frontera_nac <- homicidios |>
  filter(nacionalidad_cat %in% c("Mexicana", "Extranjera")) |>
  count(nacionalidad_cat, tipo_frontera) |>
  group_by(nacionalidad_cat) |>
  mutate(prop = n / sum(n)) |>
  ungroup()

# Crear versión espejo
dist_plot <- dist_frontera_nac |>
  mutate(
    prop_signed = if_else(
      nacionalidad_cat == "Extranjera",
      -prop,
      prop
    )
  )



# Gráfica hlg2

plot_hlg2 <- 
  ggplot(
    dist_plot,
    aes(
      x = tipo_frontera,
      y = prop_signed,
      fill = nacionalidad_cat
    )
  ) +
    geom_col(width = 0.6) +
    coord_flip() +
    scale_y_continuous(
      limits = c(-0.75, 0.75),
      breaks = seq(-0.75, 0.75, 0.25),
      labels = function(x) paste0(abs(x * 100), "%")
    ) +
    scale_fill_manual(
      values = c(
        "Extranjera" = "#2C7FB8",  
        "Mexicana"   = "#F28E2B"   
      )
    ) +
    labs(
      title = "Distribución territorial de homicidios por nacionalidad (2024)",
      subtitle = "Cada lado representa el 100% de homicidios dentro de cada nacionalidad",
      x = "Tipo de entidad federativa",
      y = "Proporción de homicidios",
      fill = "Nacionalidad"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold"),
      legend.position = "top"
    )
# ============================================================
# 5. Hallazgo 3: Edad × sexo × racialización
# ============================================================

edad_racial_sexo <- homicidios |>
  filter(
    !is.na(grupo_edad_rec),
    !is.na(racializada),
    sexo_cat %in% c("Hombre", "Mujer")
  ) |>
  count(racializada, sexo_cat, grupo_edad_rec) |>
  group_by(racializada, sexo_cat) |>
  mutate(prop = n / sum(n)) |>
  ungroup()

sexo_colors <- c(
  "Hombre" = "#1B9E77",  
  "Mujer"  = "#7570B3"   
)

##grafica hlg3

plot_hlg3 <-
  ggplot(
    edad_racial_sexo,
    aes(
      x = grupo_edad_rec,
      y = prop,
      color = sexo_cat,
      linetype = racializada,
      shape = racializada,
      group = interaction(sexo_cat, racializada)
    )
  ) +
    geom_line(size = 1) +
    geom_point(size = 3) +
    scale_y_continuous(labels = percent) +
    scale_color_manual(values = sexo_colors) +
    scale_linetype_manual(
      values = c(
        "No racializada" = "solid",
        "Racializada"    = "dashed"
      )
    ) +
    scale_shape_manual(
      values = c(
        "No racializada" = 16,  # círculo
        "Racializada"    = 17   # triángulo
      )
    ) +
    labs(
      title = "Distribución de homicidios por edad, sexo y racialización (2024)",
      subtitle = "Líneas discontinuas y triángulos representan a personas racializadas",
      x = "Grupo de edad",
      y = "Proporción de homicidios",
      color = "Sexo",
      linetype = "Racialización",
      shape = "Racialización"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      axis.text.x = element_text(angle = 35, hjust = 1),
      plot.title = element_text(face = "bold"),
      legend.position = "top"
    )

# ============================================================
# 6. Guardado de gráficas
# ============================================================

output_dir <- "~/Documents/DataCivica/Ejercicio2/figuras"

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

ggsave(
  filename = file.path(output_dir, "fig1_espacio_sexo.png"),
  plot = plot_hlg1,
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  filename = file.path(output_dir, "fig2_frontera_nacionalidad.png"),
  plot = plot_hlg2,
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  filename = file.path(output_dir, "fig3_edad_sexo_racializacion.png"),
  plot = plot_hlg3,
  width = 9,
  height = 6,
  dpi = 300
)

