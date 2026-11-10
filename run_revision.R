# Run from the repository root. A new R process handles each analysis.
stopifnot(file.exists("TTE_HRS_SHARE.Rproj"))
scripts <- c("r1_summarize_visit_intervals", "r1_summarize_outcome_ascertainment",
             "r1_assessment_time_sensitivity", "r1_component_missingness_sensitivity",
             "r1_mortality_time_intervals", "r1_frailty_support", "r1_primary_joint_inference",
             "r1_summarize_share_exclusions", "r1_verify_harmonized_item_mapping",
             "r1_audit_frailty_scoring", "r1_correct_table1_self_rated_health",
             "r1_plot_table1_balance", "r1_run_corrected_deterioration",
             "r1_publish_corrected_deterioration", "r1_reconcile_balance_diagnostics")
paths <- file.path("R", paste0(scripts, ".R"))
stopifnot(all(file.exists(paths)))
args <- commandArgs(trailingOnly = TRUE)
if (!identical(args, "--execute")) {
  cat(paste(paths, collapse = "
"), "
")
  cat("Dry run. Add --execute after generating the original-submission outputs.
")
  quit(save = "no")
}
dir.create("outputs_r/revision_r1", recursive = TRUE, showWarnings = FALSE)
rscript <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")
for (path in paths) {
  modes <- if (basename(path) == "r1_component_missingness_sensitivity.R")
    c("primary", "functional", "cardiovascular") else ""
  for (mode in modes) {
    message("Running ", path, if (nzchar(mode)) paste0(" (", mode, ")"))
    mode_args <- if (nzchar(mode)) c(shQuote(getwd()), mode) else character()
    status <- system2(rscript, c("--vanilla", shQuote(path), mode_args))
    if (status != 0L) stop("Revision script failed: ", path, call. = FALSE)
  }
}
