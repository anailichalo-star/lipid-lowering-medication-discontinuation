args <- commandArgs(trailingOnly = TRUE)

get_arg <- function(prefix, default = NULL) {
  hit <- args[startsWith(args, paste0("--", prefix, "="))]
  if (!length(hit)) return(default)
  sub(paste0("^--", prefix, "="), "", hit[[1L]])
}

project_root <- normalizePath(".", winslash = "/", mustWork = TRUE)
if (!file.exists(file.path(project_root, "TTE_HRS_SHARE.Rproj"))) {
  stop("Run this script from the code-package root.", call. = FALSE)
}
options(tte.project_root = project_root)
Sys.setenv(TTE_PROJECT_ROOT = project_root)

pipeline <- c(`00` = "00_environment_check.R", `01` = "01_source_inventory.R", 
`01b` = "01b_refine_variable_audit.R", `02` = "02_harmonize_cohorts.R", 
`03c` = "03c_build_current_primary_trials.R", `04c` = "04c_preweighting_audit.R", 
`04d` = "04d_prepare_model_covariates.R", `04e` = "04e_rebuild_frailty_validate_exposure.R", 
`04f` = "04f_filter_structural_followup.R", `05` = "05_impute_and_weight.R", 
`06` = "06_estimate_effects.R", `07a` = "07a_audit_outcome_components.R", 
`07b` = "07b_build_outcome_specific_weights.R", `07c` = "07c_estimate_component_effects.R", 
`07d` = "07d_audit_pre_landmark_deterioration.R", `07e` = "07e_build_restricted_sensitivity_weights.R", 
`07f` = "07f_estimate_restricted_sensitivity_effects.R", `07g` = "07g_build_functional_outcome_weights.R", 
`07h` = "07h_estimate_functional_outcome_effects.R", `07i` = "07i_audit_frailty_heterogeneity.R", 
`07j` = "07j_estimate_continuous_frailty_interaction.R", `07k` = "07k_build_hrs_fall_free_survival_weights.R", 
`07l` = "07l_estimate_hrs_fall_free_survival_effect.R", `08a` = "08a_alternative_weight_sensitivity.R", 
`08b` = "08b_age_threshold_sensitivity.R", `08c` = "08c_prior_visit_only_sensitivity.R", 
`08d` = "08d_evalue_unmeasured_confounding.R", `09a` = "09a_two_cohort_meta_analysis.R", 
`09b` = "09b_generate_publication_outputs.R", `12` = "12_generate_jaha_tables_figures_results.R", 
`13` = "13_prepare_jaha_submission_files.R", `23` = "23_refine_figure1_arrows.R", 
`25` = "25_refine_figure2_3_panel_labels.R")

if ("--list" %in% args || !"--execute" %in% args) {
  cat("Original-submission pipeline stages:\n")
  for (i in seq_along(pipeline)) {
    cat(sprintf("%2d. %-3s %s\n", i, names(pipeline)[[i]], pipeline[[i]]))
  }
  if (!"--execute" %in% args) {
    cat("\nDry run only. Add --execute and optionally --from=STAGE --to=STAGE.\n")
    quit(save = "no", status = 0L)
  }
}

from_stage <- get_arg("from", names(pipeline)[[1L]])
to_stage <- get_arg("to", names(pipeline)[[length(pipeline)]])
if (!from_stage %in% names(pipeline)) stop("Unknown --from stage: ", from_stage, call. = FALSE)
if (!to_stage %in% names(pipeline)) stop("Unknown --to stage: ", to_stage, call. = FALSE)
from_index <- match(from_stage, names(pipeline))
to_index <- match(to_stage, names(pipeline))
if (from_index > to_index) stop("--from must precede --to in the frozen pipeline.", call. = FALSE)

selected <- pipeline[from_index:to_index]
cat("Executing stages: ", paste(names(selected), collapse = ", "), "\n", sep = "")
for (stage in names(selected)) {
  script <- file.path(project_root, "R", selected[[stage]])
  if (!file.exists(script)) stop("Missing stage script: ", script, call. = FALSE)
  cat("\n===== Stage ", stage, ": ", basename(script), " =====\n", sep = "")
  source(script, encoding = "UTF-8", local = new.env(parent = globalenv()))
}

cat("\nSelected pipeline range completed.\n")

