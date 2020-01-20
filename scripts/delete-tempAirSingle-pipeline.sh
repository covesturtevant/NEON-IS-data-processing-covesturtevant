#!/bin/bash

# Delete the tempAirSingle pipeline.

pachctl start transaction

pachctl delete pipeline tempAirSingle_level1_group
pachctl delete pipeline tempAirSingle_statistics
pachctl delete pipeline tempAirSingle_statistics_uncertainty_group
pachctl delete pipeline tempAirSingle_merge_qaqc_data
pachctl delete pipeline tempAirSingle_quality_metrics
pachctl delete pipeline tempAirSingle_qaqc_data_group
pachctl delete pipeline tempAirSingle_qaqc_flags_group
pachctl delete pipeline tempAirSingle_qaqc_plausibility_data
pachctl delete pipeline tempAirSingle_regularized_flags
pachctl delete pipeline tempAirSingle_qaqc_plausibility_flags
pachctl delete pipeline tempAirSingle_qaqc_specific_data
pachctl delete pipeline tempAirSingle_qaqc_specific_flags
pachctl delete pipeline tempAirSingle_qaqc_plausibility
pachctl delete pipeline tempAirSingle_regularized_uncertainty_fdas
pachctl delete pipeline tempAirSingle_qaqc_specific
pachctl delete pipeline tempAirSingle_padded_timeseries_analyzer
pachctl delete pipeline tempAirSingle_uncertainty_coefficients
pachctl delete pipeline tempAirSingle_qaqc_specific_group
pachctl delete pipeline tempAirSingle_timeseries_padder
pachctl delete pipeline tempAirSingle_heater
pachctl delete pipeline tempAirSingle_windobserverii
pachctl delete pipeline tempAirSingle_threshold_regularized_group
pachctl delete pipeline tempAirSingle_regularized_data
pachctl delete pipeline tempAirSingle_threshold_select
pachctl delete pipeline tempAirSingle_uncertainty_fdas
pachctl delete pipeline tempAirSingle_calibrated_flags
pachctl delete pipeline tempAirSingle_calibrated_data
pachctl delete pipeline tempAirSingle_locations
pachctl delete pipeline tempAirSingle_threshold_filter
pachctl delete pipeline tempAirSingle_prt
pachctl delete pipeline tempAirSingle_dualfan
pachctl delete pipeline tempAirSingle_related_location_group
pachctl delete pipeline tempAirSingle_dualfan_group_path
pachctl delete pipeline tempAirSingle_heater_group_path
pachctl delete pipeline tempAirSingle_windobserverii_group_path
pachctl delete pipeline dualfan_merge_data_by_location
pachctl delete pipeline windobserverii_merge_data_by_location
pachctl delete pipeline dualfan_structure_repo_by_location
pachctl delete pipeline windobserverii_structure_repo_by_location
pachctl delete pipeline dualfan_location_filter
pachctl delete pipeline windobserverii_location_filter
pachctl delete pipeline dualfan_data_location_group
pachctl delete pipeline heater_data_location_group
pachctl delete pipeline windobserverii_data_location_group

pachctl finish transaction
