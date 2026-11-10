# Lipid-lowering medication discontinuation in HRS and SHARE

R analysis code accompanying the first revision of the landmark cohort study.

## Data access and inputs

Obtain authorized source files from the [HRS Data Portal](https://hrsdata.isr.umich.edu/) and the [SHARE Research Data Center](https://share-eric.eu/data/data-access).
The exact local paths and versions are in [DATA_INPUT_MANIFEST.csv](DATA_INPUT_MANIFEST.csv).
The repository contains code and configuration. Keep licensed files and generated participant records local.
The harmonization stage also requires prepared long-format CSVs. These are analysis inputs, not direct portal downloads.
Use the fields in `config_r/preferred_clean_mapping.csv` and `R/04e_rebuild_frailty_validate_exposure.R` to check the prepared files against the required schema.
The input health scales use 5 for excellent and 1 for poor. Raw portal files alone do not reproduce the prepared long files with this package.

## Running the analysis

Run commands from the repository root. The study used R 4.6.1. For the publication figures, use an R build with Cairo support and Arial available.

```sh
Rscript install_packages.R
Rscript run_tests.R
Rscript run_pipeline.R --list
Rscript run_revision.R --list
```

The package checker prints an installation command when required packages are missing.
With authorized inputs in place, run the original-submission stages in order:

```sh
Rscript run_pipeline.R --from=00 --to=03c --execute
# Review the sampled longitudinal records locally before continuing.
Rscript run_pipeline.R --from=04c --to=25 --execute
Rscript run_revision.R --execute
```

Each analysis uses its recorded feasibility, balance, overlap and event-count criteria. The files written under `outputs_r/` include private intermediates.
Original-submission outputs support comparisons with the revision. The original self-rated health display and deterioration indicator are retained in the original stages for this purpose.
Use the corresponding outputs in `outputs_r/revision_r1/` for the revised baseline table, health-deterioration analyses, Figures S1 and S3, and the main sensitivity figure.

## Analysis records

The dated original weighting and primary outcome model settings are in `config_r/primary_weight_model.yml` and `config_r/primary_outcome_model.yml`.
The revision runner includes follow-up and outcome-observation audits, assessment-time sensitivity analyses, component-specific and functional reassessment models, mortality date intervals, frailty diagnostics, joint variance estimation, and the corrected health-deterioration analysis.
