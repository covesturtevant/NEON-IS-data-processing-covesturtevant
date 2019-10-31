

class DataFilename(object):
    """Parse data file names of the form prt_769_2018-01-03.avro"""

    def __init__(self, filename):
        self.filename = filename.split('.')[0]

    def source_type(self):
        return self.filename.split('_')[0]

    def source_id(self):
        return self.filename.split('_')[1]

    def date(self):
        return self.filename.split('_')[2]

    @staticmethod
    def build(source_type, source_id, year, month, day):
        filename_format = '{}_{}_{}-{}-{}.avro'
        return filename_format.format(source_type, source_id, year, month, day)
