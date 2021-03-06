#!/usr/bin/env python3
import datetime

from contextlib import closing

import water_quality_cloning.measurement_stream_assigner as measurement_stream_assigner


def get_assets_at_location(connection, named_location_id):
    """
    Get all the assets currently assigned to a PRT location.

    :param connection: A database connection.
    :type connection: connection object
    :param named_location_id: A named location ID.
    :type named_location_id: int
    :return: A list of assets currently assigned to the named location at the given ID.
    """
    sql = '''
    select
        is_asset_location.asset_location_id,
        is_asset_location.asset_uid,
        is_asset_location.install_date,
        is_asset_location.remove_date,
        is_asset_definition.sensor_type_name
    from
        is_asset_location, is_asset_definition, is_asset_assignment
    where
        is_asset_assignment.asset_uid = is_asset_location.asset_uid
    and
        is_asset_definition.asset_definition_uuid = is_asset_assignment.asset_definition_uuid
    and 
        is_asset_definition.sensor_type_name not like 'prt'
    and 
        is_asset_definition.sensor_type_name not like 'TO DO'
    and
        is_asset_location.nam_locn_id = :id
    '''
    assets = []
    with closing(connection.cursor()) as cursor:
        rows = cursor.execute(sql, id=named_location_id)
        for row in rows:
            asset_location_id = row[0]
            asset_uid = row[1]
            install_date = row[2]
            remove_date = row[3]
            sensor_type = row[4]
            assets.append({
                'asset_location_id': asset_location_id,
                'asset_uid': asset_uid,
                'install_date': install_date,
                'remove_date': remove_date,
                'sensor_type': sensor_type})
    return assets


# def _insert_assets(connection, named_location_id, cloned_locations):
#     """
#     Reassign assets from the PRT location to a cloned location and use the same location for each asset type.
#     :param connection:
#     :param named_location_id:
#     :param cloned_locations:
#     :return:
#     """
#     sql = '''
#         insert into is_asset_location
#             (
#             asset_location_id,
#             nam_locn_id,
#             asset_uid,
#             install_date,
#             remove_date,
#             change_by,
#             tran_date
#             )
#         values (
#             asset_location_id_seq1.nextval,
#             :named_location_id,
#             :asset_uid,
#             :install_date,
#             :remove_date,
#             :change_by,
#             :tran_date
#             )
#     '''
#     assets = get_assets_at_location(connection, named_location_id)
#     for asset in assets:
#         asset_uid = asset.get('asset_uid')
#         install_date = asset.get('install_date')
#         remove_date = asset.get('remove_date')
#         sensor_type = asset.get('sensor_type')
#         sensor_type_index = get_clone_location_index(sensor_type)
#
#         cloned_location = cloned_locations[sensor_type_index]
#         cloned_location_id = cloned_location.get('key')
#
#         with closing(connection.cursor()) as cursor:
#             cursor.execute(sql,
#                            named_location_id=cloned_location_id,
#                            asset_uid=asset_uid,
#                            install_date=install_date,
#                            remove_date=remove_date,
#                            change_by='water quality prototype',
#                            tran_date=datetime.datetime.now())
#             connection.commit()


def assign_assets(connection, named_location_id, cloned_locations):
    """
    Reassign assets from the PRT named location to the cloned named location based on the asset (sensor) type.

    :param connection: A database connection.
    :type connection: connection object
    :param named_location_id: A named location ID.
    :type named_location_id: int
    :param cloned_locations: The new named locations for assigning assets.
    :type cloned_locations: list
    :return:
    """
    print(f'assigning assets.')
    sql = '''
        update 
            is_asset_location
        set 
            nam_locn_id = :named_location_id, 
            change_by = :change_by, 
            tran_date = :tran_date
        where asset_location_id = :asset_location_id
    '''
    assets = get_assets_at_location(connection, named_location_id)
    print(f'Found {len(assets)} assets.')
    for asset in assets:
        asset_location_id = asset.get('asset_location_id')
        sensor_type = asset.get('sensor_type')
        if sensor_type != 'prt':
            sensor_type_index = get_clone_location_index(sensor_type)
            print(f'sensor type: {sensor_type}, sensor type index: {sensor_type_index}, '
                  f'cloned locations: {len(cloned_locations)}')
            cloned_location = cloned_locations[sensor_type_index]
            cloned_location_id = cloned_location.get('key')
            with closing(connection.cursor()) as cursor:
                cursor.execute(sql,
                               named_location_id=cloned_location_id,
                               change_by='water quality prototype',
                               tran_date=datetime.datetime.now(),
                               asset_location_id=asset_location_id)
                connection.commit()
            # The location is now assigned to a sensor type, assign any measurement streams of the same
            # type currently assigned to the old location to the new cloned location.
            assign_measurement_streams(connection, named_location_id, cloned_location_id, sensor_type)


def get_clone_location_index(sensor_type):
    """
    Ensure all sensors of the same type are assigned to the same cloned named location.

    :param sensor_type: A type of sensor.
    :type sensor_type: str
    :return: The index number for the sensor type.
    """
    switcher = {
        'exo2': 0,
        'exoconductivity': 1,
        'exodissolvedoxygen': 2,
        'exoturbidity': 3,
        'exophorp': 4,
        'exototalalgae': 5,
        'exofdom': 6
    }
    index = switcher.get(sensor_type, "Invalid sensor type.")
    return index


def get_field_names(sensor_type):
    """
    Get all the schema field names for a sensor type.

    :param sensor_type: A type of sensor.
    :type sensor_type: str
    :return: The field names for the sensor type.
    """
    switcher = {
        'exo2': ['sensorDepth', 'sondeSurfaceWaterPressure', 'wiperPosition', 'batteryVoltage', 'sensorVoltage'],
        'exoconductivity': ['conductance', 'specificConductance', 'surfaceWaterTemperature'],
        'exodissolvedoxygen': ['dissolvedOxygenSaturation', 'dissolvedOxygen'],
        'exoturbidity': ['turbidityRaw', 'turbidity'],
        'exophorp': ['pH', 'pHvoltage'],
        'exototalalgae': ['blueGreenAlgaeRaw', 'blueGreenAlgaePhycocyanin', 'chlorophyllRaw', 'chlorophyll'],
        'exofdom': ['fDOMRaw', 'fDOM']
    }
    index = switcher.get(sensor_type, "Invalid sensor type.")
    return index


def assign_measurement_streams(connection, named_location_id, cloned_location_id, sensor_type):
    """
    Reassign a measurement stream from the named_location_id to the cloned_location_id if the
    measurement stream schema field name (associated by the term name) matches the cloned
    named location sensor type.

    :param connection: A database connection.
    :type connection: connection object
    :param named_location_id: The named location ID.
    :type named_location_id: int
    :param cloned_location_id: The cloned location ID.
    :type cloned_location_id: int
    :param sensor_type: The sensor type.
    :type sensor_type: str
    :return:
    """
    print(f'assigning measurement streams')
    streams = measurement_stream_assigner.get_streams(connection, named_location_id)
    for stream in streams:
        if sensor_type != 'prt':
            sensor_field_names = get_field_names(sensor_type)
            stream_field_name = stream.get('field')
            print(f'stream field name: {stream_field_name} sensor type {sensor_type}')
            if stream_field_name in sensor_field_names:
                measurement_stream_id = stream.get('stream_id')
                measurement_stream_assigner.reassign_stream(connection, measurement_stream_id, cloned_location_id)
