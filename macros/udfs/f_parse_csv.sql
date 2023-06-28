{% macro create_f_parse_csv() %}
CREATE OR REPLACE FUNCTION {{target.schema}}.PARSE_CSV(CSV STRING, DELIMITER STRING, QUOTECHAR STRING)
RETURNS TABLE (V VARIANT)
LANGUAGE PYTHON
RUNTIME_VERSION=3.8
HANDLER='CsvParser'
AS $$
import csv
# https://medium.com/snowflake/loading-csv-as-semi-structured-files-in-snowflake-d7d76dfc37bf

class CsvParser:
    def __init__(self):
        # Allow fields up to the VARCHAR size limit
        csv.field_size_limit(16777216)
        self._isFirstRow = True
        self._headers = []

    def process(self, CSV, DELIMITER, QUOTECHAR):
        # If the first row in a partition, store the headers
        if self._isFirstRow:
            self._isFirstRow = False
            # csv.reader to split up the headers
            reader = csv.reader([CSV], delimiter=DELIMITER, quotechar=QUOTECHAR)
            # Convert field names to lower case for consistency
            self._headers = list(map(lambda h: h.lower(), list(reader)[0]))
        else:
            # A DictReader allows us to provide the headers as a parameter
            reader = csv.DictReader(
                [CSV],
                fieldnames=self._headers,
                delimiter=DELIMITER,
                quotechar=QUOTECHAR,
            )
            for row in reader:
                # CSV are often sparse because each record has every field
                # Remove empty values to improve performance
                res = { k:v for (k,v) in row.items() if v }
                yield (res,)
$$
;

GRANT USAGE ON ALL FUNCTIONS IN SCHEMA {{target.schema}} TO ROLE ENGINEERING;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA {{target.schema}} TO ROLE INTEGRATION_DM;
{% endmacro %}