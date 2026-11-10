packages <- c("yaml", "haven", "data.table", "tidyselect", "mice", "ggplot2", "scales", "survival", "testthat")
missing <- packages[!vapply(packages, requireNamespace, logical(1L), quietly = TRUE)]
if (length(missing)) {
  message("Run install.packages(c(", paste(shQuote(missing, type = "cmd"), collapse = ", "), "))")
} else message("All required packages are installed.")
