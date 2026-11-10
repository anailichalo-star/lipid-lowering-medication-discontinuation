project_root <- normalizePath(".", winslash = "/", mustWork = TRUE)
if (!file.exists(file.path(project_root, "TTE_HRS_SHARE.Rproj"))) {
  stop("Run this script from the code-package root.", call. = FALSE)
}
options(tte.project_root = project_root)
Sys.setenv(TTE_PROJECT_ROOT = project_root)

if (!requireNamespace("testthat", quietly = TRUE)) {
  stop("Missing package 'testthat'. Run source('install_packages.R').", call. = FALSE)
}

testthat::test_dir(file.path(project_root, "tests", "testthat"), reporter = "summary")

