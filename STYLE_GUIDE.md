# 📐 Sokal & Rohlf: Biostatistics Workflow

Este documento define los estándares para la reproducción de ejercicios estadísticos del libro "Biometry" (Sokal & Rohlf, 4th Ed).

## 1. Estructura de Proyectos
El orden sigue los capítulos del libro para facilitar la consulta:
- `00_Data`: Datasets originales (.csv, .txt).
- `Ch09_ANOVA_OneWay`: Ejercicios del Capítulo 9.
- `Ch13_Assumptions`: Pruebas de supuestos.

## 2. Encabezado de Scripts (Academic Header)
Todo script debe comenzar obligatoriamente con este bloque:

```r
# ==============================================================================
# 📐 PROYECTO: BioStats Review | Sokal & Rohlf (4th Ed.)
# ------------------------------------------------------------------------------
# SCRIPT:     [Capitulo]_[Tema].R (Ej. Ch09_ANOVA.R)
# AUTOR:      M. en C. Dylan Díaz
# FECHA:      [Mes Año]
#
# DESCRIPCIÓN:
# Reproducción del [Box/Ejemplo X.Y] sobre [Tema biológico].
# Se pone énfasis en la verificación de supuestos antes del p-value.
#
# REFERENCIA:
# Sokal, R. R., & Rohlf, F. J. (2012). Biometry. W. H. Freeman.
# ==============================================================================
```
# 3. Convenciones de Código
Estilo: Tidyverse para limpieza, pero R Base permitido para tests clásicos.

Notación: Usar alpha = 0.05 como estándar por defecto.

# 4. Resultados: Siempre interpretar el resultado biológico, no solo el estadístico.

Filosofía Estadística (El "Sello Dylan")
Supuestos Primero: "Sin normalidad no hay paraíso". Siempre graficar residuos.

Rigor: Preferir modelos lineales (lm) sobre tests de caja negra (t.test) cuando sea posible para entender la mecánica.

Claridad: El código debe ser legible para un estudiante de licenciatura.

