#!/bin/bash
pachctl create pipeline -f pipe/location_loader/location_loader.json
pachctl create pipeline -f pipe/threshold_loader/threshold_loader.json
pachctl create pipeline -f pipe/prt_data_calibration_group/prt_data_calibration_group.json
pachctl create pipeline -f pipe/prt_calibration_filter/prt_calibration_filter.json
pachctl create pipeline -f pipe/prt_calibration_conversion/prt_calibration_conversion.json 
pachctl create pipeline -f pipe/prt_calibrated_location_group/prt_calibrated_location_group.json
pachctl create pipeline -f pipe/prt_location_filter/prt_location_filter.json 
pachctl create pipeline -f pipe/tempSoil_fill_date_gaps_by_location/tempSoil_fill_date_gaps_by_location.json
pachctl create pipeline -f pipe/tempSoil_context_group/tempSoil_context_group.json
pachctl create pipeline -f pipe/tempSoil_structure_repo_by_location/tempSoil_structure_repo_by_location.json
pachctl create pipeline -f pipe/tempSoil_merge_data_by_location/tempSoil_merge_data_by_location.json
pachctl create pipeline -f pipe/prt_soil_threshold_filter/prt_soil_threshold_filter.json
pachctl create pipeline -f pipe/tempSoil_directory_filter/tempSoil_calibrated_data.json
pachctl create pipeline -f pipe/tempSoil_directory_filter/tempSoil_calibrated_flags.json
pachctl create pipeline -f pipe/tempSoil_directory_filter/tempSoil_locations.json
pachctl create pipeline -f pipe/tempSoil_directory_filter/tempSoil_uncertainty_coefficients.json
pachctl create pipeline -f pipe/tempSoil_threshold_select/tempSoil_threshold_select.json
pachctl create pipeline -f pipe/tempSoil_regularized_data/tempSoil_regularized_data.json
pachctl create pipeline -f pipe/tempSoil_threshold_regularized_group/tempSoil_threshold_regularized_group.json
pachctl create pipeline -f pipe/tempSoil_timeseries_padder/tempSoil_timeseries_padder.json
pachctl create pipeline -f pipe/tempSoil_padded_timeseries_analyzer/tempSoil_padded_timeseries_analyzer.json
pachctl create pipeline -f pipe/tempSoil_fill_date_gaps_by_location/tempSoil_fill_date_gaps_by_location.json

pachctl create pipeline -f pipe/tempSoil_qaqc_plausibility/tempSoil_qaqc_plausibility.json
pachctl create pipeline -f pipe/tempSoil_directory_filter/tempSoil_qaqc_data.json
pachctl create pipeline -f pipe/tempSoil_directory_filter/tempSoil_qaqc_flags.json
pachctl create pipeline -f pipe/tempSoil_qaqc_regularized_flag_group/tempSoil_qaqc_regularized_flag_group.json
pachctl create pipeline -f pipe/tempSoil_statistics_uncertainty_group/tempSoil_statistics_uncertainty_group.json
