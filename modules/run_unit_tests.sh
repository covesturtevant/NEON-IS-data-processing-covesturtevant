#!/bin/bash
python3 -B -m unittest \
avro_parquet_converter.tests.test_app \
calibrated_location_group.tests.test_app \
context_filter.tests.test_app \
data_access.tests.test_data_access \
data_calibration_group.tests.test_grouper_calibration \
data_calibration_group.tests.test_grouper_no_calibration \
data_gap_filler.tests.test_app \
data_location_group.tests.test_app \
directory_filter.tests.test_app \
egress.tests.test_app \
event_asset_loader.tests.test_app \
event_location_group.tests.test_app \
event_location_group_path.tests.test_app \
event_related_location_group.tests.test_app \
grouper.tests.test_app \
joiner.tests.test_app \
lib.tests.test_log_config \
lib.tests.test_data_filename \
lib.tests.test_date_formatter \
lib.tests.test_file_linker \
lib.tests.test_merged_data_filename \
lib.tests.test_target_path \
location_active_dates.tests.test_app \
location_asset.tests.test_app \
location_group_path.tests.test_app \
location.tests.test_app \
padded_timeseries_analyzer.tests.test_app \
parquet_linkmerge.tests.test_app \
qaqc_regularized_flag_group.tests.test_app \
related_location_group.tests.test_app \
timeseries_padder.tests.test_padder_util \
timeseries_padder.tests.test_app \
threshold_loader.tests.test_app
