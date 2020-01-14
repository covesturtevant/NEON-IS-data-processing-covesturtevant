#!/bin/bash

# Generate the tempSoil pipeline. The prt pipeline must exist before creating this pipeline.

pachctl begin transaction

pachctl create pipeline -f tempSoil_context_group/tempSoil_context_group.json
pachctl create pipeline -f tempSoil_threshold_filter/tempSoil_threshold_filter.json
pachctl create pipeline -f tempSoil_uncertainty_fdas/tempSoil_uncertainty_fdas.json
pachctl create pipeline -f tempSoil_locations/tempSoil_locations.json
pachctl create pipeline -f tempSoil_calibrated_data/tempSoil_calibrated_data.json
pachctl create pipeline -f tempSoil_calibrated_flags/tempSoil_calibrated_flags.json
pachctl create pipeline -f tempSoil_threshold_select/tempSoil_threshold_select.json
pachctl create pipeline -f tempSoil_regularized_data/tempSoil_regularized_data.json
pachctl create pipeline -f tempSoil_uncertainty_coefficients/tempSoil_uncertainty_coefficients.json
pachctl create pipeline -f tempSoil_threshold_regularized_group/tempSoil_threshold_regularized_group.json
pachctl create pipeline -f tempSoil_regularized_uncertainty_fdas/tempSoil_regularized_uncertainty_fdas.json
pachctl create pipeline -f tempSoil_timeseries_padder/tempSoil_timeseries_padder.json
pachctl create pipeline -f tempSoil_padded_timeseries_analyzer/tempSoil_padded_timeseries_analyzer.json
pachctl create pipeline -f tempSoil_regularized_flags/tempSoil_regularized_flags.json
pachctl create pipeline -f tempSoil_qaqc_plausibility/tempSoil_qaqc_plausibility.json
pachctl create pipeline -f tempSoil_qaqc_data/tempSoil_qaqc_data.json
pachctl create pipeline -f tempSoil_qaqc_flags/tempSoil_qaqc_flags.json
pachctl create pipeline -f tempSoil_statistics_uncertainty_group/tempSoil_statistics_uncertainty_group.json
pachctl create pipeline -f tempSoil_qaqc_regularized_flag_group/tempSoil_qaqc_regularized_flag_group.json
pachctl create pipeline -f tempSoil_statistics/tempSoil_statistics.json
pachctl create pipeline -f tempSoil_quality_metrics/tempSoil_quality_metrics.json
pachctl create pipeline -f tempSoil_level1_group/tempSoil_level1_group.json

pachctl finish transaction