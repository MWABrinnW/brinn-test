select
json:_box_file_id::varchar(25) as _BOX_FILE_ID
, json:account_name::varchar(100) as account_name
, json:account_number::varchar(25) as account_number
, json:_CREATED_AT::TIMESTAMPNTZ as _CREATED_AT
from {{ source('aux', 'lifi_exclusions') }}