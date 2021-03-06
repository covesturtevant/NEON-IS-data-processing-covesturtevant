#!/usr/bin/env python3
from contextlib import closing

import data_access.named_location_finder as named_location_finder


def get_prt_wq_named_locations(connection):
    """
    Find Water Quality named location IDs used by non-Water Quality sensors.

    :param connection: A database connection.
    :type connection: connection object
    :return: A list of named location IDs.
    """
    sql = '''
        select distinct nam_locn_id 
        from 
            pdr.meas_strm 
        where 
            (meas_strm_name like '%DP0%' 
                and meas_strm_name not like '%DP0.20033%' 
                and meas_strm_name not like '%DP0.20005%' 
                and nam_locn_id in
                    (select distinct nam_locn_id 
                        from pdr.meas_strm 
                        where (meas_strm_name like '%DP0.20033%' 
                            or meas_strm_name like '%DP0.20005%')))
        '''
    with closing(connection.cursor()) as cursor:
        rows = cursor.execute(sql)
        named_location_ids = []
        for row in rows:
            named_location_id = row[0]
            named_location_ids.append(named_location_id)
        return named_location_ids


def get_named_location(connection, named_location_id):
    """
    Get an existing named location from the database.

    :param connection: A database connection.
    :type connection: connection object
    :param named_location_id: The named location ID.
    :type named_location_id: int
    :return: The named location.
    """
    sql = '''
        select nam_locn_id, nam_locn_name, nam_locn_desc, type_id from nam_locn where nam_locn_id = :id
    '''
    named_location = None
    with closing(connection.cursor()) as cursor:
        cursor.prepare(sql)
        rows = cursor.execute(None, id=named_location_id)
        if rows is not None:
            for row in rows:
                print(f'named location: {row}')
                key = row[0]
                name = row[1]
                desc = row[2]
                type_id = row[3]
                site_name = named_location_finder.get_site(connection, key)
                named_location = {'key': key,
                                  'name': name,
                                  'description': desc,
                                  'type_id': type_id,
                                  'site': site_name}
    return named_location


def get_location(connection, named_location):
    """
    From the database get the geo-location ID assigned to a named location.

    :param connection: A database connection.
    :type connection: connection object
    :param named_location: The named location object
    :type named_location: dict
    :return: The location ID.
    """
    sql = '''select locn_id from locn_nam_locn where nam_locn_id = :id'''
    named_location_id = named_location.get('key')
    with closing(connection.cursor()) as cursor:
        cursor.prepare(sql)
        rows = cursor.execute(None, id=named_location_id)
        for row in rows:
            location_key = row[0]
    return location_key


def save_clone(connection, cloned_named_location):
    """
    Insert the new named location into the database.

    :param connection: A database connection.
    :type connection: connection object
    :param cloned_named_location: The cloned named location.
    :type cloned_named_location: dict
    :return: The ID of the new named location.
    """
    sql = '''
        insert into nam_locn 
            (nam_locn_id, nam_locn_name, nam_locn_desc, type_id) 
        values 
            (nam_locn_id_seq1.nextval, :location_name, :description, :type_id)
    '''
    name = cloned_named_location.get('name')
    description = cloned_named_location.get('description')
    type_id = cloned_named_location.get('type_id')
    with closing(connection.cursor()) as cursor:
        cursor.prepare(sql)
        cursor.execute(None, location_name=name, description=description, type_id=type_id)
        connection.commit()
    with closing(connection.cursor()) as id_cursor:
        id_cursor.execute('select nam_locn_id_seq1.currval from dual')
        row = id_cursor.fetchone()
        last_insert_id = row[0]
    return last_insert_id


def get_clone_name(index):
    """
    Create a name for the new named location using a consistent format of 'SENSOR' + an index.

    :param index: The unique index for the new named location.
    :type index: int
    :return: The name.
    """
    new_name = 'SENSOR'
    if index < 10:
        new_name = new_name + '00000' + str(index)
    elif 10 <= index < 100:
        new_name = new_name + '0000' + str(index)
    elif 100 <= index < 1000:
        new_name = new_name + '000' + str(index)
    elif 1000 <= index < 10000:
        new_name = new_name + '00' + str(index)
    return new_name


def create_clone(named_location, index):
    """
    Create a new named location based on the input location.

    :param named_location: The named location to clone.
    :type named_location: dict
    :param index: The unique index for the new named location.
    :type index: int
    :return: The new named location.
    """
    key = named_location.get('key')
    description = named_location.get('description')
    type_id = named_location.get('type_id')
    site = named_location.get('site')
    new_name = get_clone_name(index)
    named_location_clone = {'key': key,
                            'name': new_name,
                            'description': description,
                            'type_id': type_id,
                            'site': site}
    return named_location_clone
