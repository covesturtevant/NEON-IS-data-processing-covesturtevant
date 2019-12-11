import pathlib
import os

import environs
import structlog

import lib.log_config as log_config
import lib.file_linker as file_linker
import lib.file_crawler as file_crawler
from lib.data_filename import DataFilename

log = structlog.get_logger()


def group(data_path, out_path):
    """Write data and location files into output path."""
    for file_path in file_crawler.crawl(data_path):
        parts = file_path.parts
        source_type = parts[3]
        year = parts[4]
        month = parts[5]
        day = parts[6]
        filename = parts[7]
        log.debug(f'data filename: {filename}')
        name = DataFilename(filename)
        source_id = name.source_id()
        log.debug(f'source type: {source_type} source_id: {source_id}')
        log.debug(f'year: {year}  month: {month}  day: {day}')
        log.debug(f'filename: {filename}')
        target_root = os.path.join(out_path, source_type, year, month, day, source_id)
        data_target_path = os.path.join(target_root, 'data', filename)
        print(f'data_target_path: {data_target_path}')
        file_linker.link(file_path, data_target_path)


def main():
    env = environs.Env()
    source_path = env('SOURCE_PATH')
    out_path = env('OUT_PATH')
    log_level = env('LOG_LEVEL')
    log_config.configure(log_level)
    log.debug(f'data_dir: {source_path} out_dir: {out_path}')
    group(source_path, out_path)


if __name__ == '__main__':
    main()
