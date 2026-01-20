# -------------------------------------------------------------------------
# PROYECTO: BioStats Review con Sokal & Rohlf (4th Ed.)
# SCRIPT: 01_ANOVA_OneWay_Supuestos.R
# AUTOR: M. en C. Dylan Díaz
# FECHA: Enero 2026
#
# DESCRIPCIÓN:
# Implementación del Análisis de Varianza de una vía (Capítulo 9) 
# con verificación rigurosa de supuestos (Capítulo 13).
#
# REFERENCIA:
# Sokal, R. R., & Rohlf, F. J. (2012). Biometry: The Principles and Practice 
# of Statistics in Biological Research. W. H. Freeman and Company.
# -------------------------------------------------------------------------

# 1. CARGA DE LIBRERÍAS
# ---------------------
library(tidyverse)  # Manejo de datos y gráficos (ggplot2)
library(car)        # Para Test de Levene
library(rstatix)    # Para shapiro_test
library(ggpubr)     # Para gráficos Q-Q y publicación


# 2. GENERACIÓN DE DATOS SIMULADOS (Reproducibilidad)
# ---------------------------------------------------
# Simulamos longitudes de peces (cm) en 3 sitios (Dzilam, Telchac, Sisal)
set.seed(123) 

datos <- data.frame(
  Sitio = factor(rep(c("Dzilam", "Telchac", "Sisal"), each = 30)),
  Longitud = c(rnorm(30, mean = 25, sd = 2.5),  # Dzilam 
               rnorm(30, mean = 28, sd = 3.0),  # Telchac (Más grandes)
               rnorm(30, mean = 25.5, sd = 2.5)) # Sisal 
)

print("Vista previa de los datos:")
head(datos)

# 3. EXPLORACIÓN VISUAL (EDA)
# ---------------------------
# Boxplot + Jitter (El "Ojímetro")
p1 <- ggplot(datos, aes(x = Sitio, y = Longitud, fill = Sitio)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.5, color = "black") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Distribución de Tallas por Sitio", 
       subtitle = "Exploración visual antes del ANOVA",
       y = "Longitud (cm)") +
  theme(legend.position = "none")

print(p1)
# GUARDAMOS IMAGEN 1 (Para el README)
ggsave("EDA_Boxplot.png", plot = p1, width = 8, height = 6)


# 4. VERIFICACIÓN DE SUPUESTOS (Capítulo 13 Sokal & Rohlf)
# --------------------------------------------------------

# A) Inspección Visual (Q-Q Plot) - ¡ESTILO MODERNO!
# Si los puntos siguen la línea gris, asumimos normalidad.
p_qq <- ggqqplot(datos, x = "Longitud", facet.by = "Sitio") +
  labs(title = "Gráfico Q-Q: Verificación Visual de Normalidad",
       subtitle = "Puntos sobre la banda gris = Distribución Normal",
       caption = "Best Practice: Validación visual + Test Estadístico")

print(p_qq)
# GUARDAMOS IMAGEN 2 (Para el README)
ggsave("Normality_QQPlot.png", plot = p_qq, width = 8, height = 6)


# B) Normalidad Matemática (Shapiro-Wilk)
normality_check <- datos %>%
  group_by(Sitio) %>%
  shapiro_test(Longitud)

print("--- Prueba de Normalidad (Shapiro-Wilk) ---")
print(normality_check)

# C) Homocedasticidad (Levene)
levene_res <- leveneTest(Longitud ~ Sitio, data = datos)

print("--- Prueba de Homocedasticidad (Levene) ---")
print(levene_res)


# 5. EJECUCIÓN DEL MODELO (Capítulo 9 Sokal & Rohlf)
# --------------------------------------------------

# Condicional: Si P > 0.05 en Levene -> ANOVA Clásico
if(levene_res$`Pr(>F)`[1] > 0.05) {
  message(">> Supuestos cumplidos (Homocedasticidad OK): Ejecutando ANOVA Clásico...")
  
  modelo <- aov(Longitud ~ Sitio, data = datos)
  print(summary(modelo))
  
  # 6. PRUEBAS POST-HOC (Tukey HSD)
  tukey_res <- TukeyHSD(modelo)
  print("--- Comparaciones Múltiples (Tukey HSD) ---")
  print(tukey_res)
  
} else {
  message(">> ALERTA: Varianzas no homogéneas. Se sugiere ANOVA de Welch.")
}


# 7. VISUALIZACIÓN DE RESULTADOS
# ------------------------------
# Gráfico de Barras (Media) + Error (SD)
resumen <- datos %>%
  group_by(Sitio) %>%
  summarise(
    Media = mean(Longitud),
    SD = sd(Longitud)
  )

p2 <- ggplot(resumen, aes(x = Sitio, y = Media, fill = Sitio)) +
  geom_col(alpha = 0.7, width = 0.6) +
  geom_errorbar(aes(ymin = Media - SD, ymax = Media + SD), width = 0.2) +
  theme_classic() +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Comparación de Medias: Longitud de Peces",
       subtitle = "Barras representan Desviación Estándar (SD)",
       caption = "Basado en metodología Sokal & Rohlf (2012)",
       y = "Longitud Media (cm)") +
  theme(legend.position = "none")

print(p2)
# GUARDAMOS IMAGEN 3 (Para el README)
ggsave("ANOVA_Resultados.png", plot = p2, width = 8, height = 6)
