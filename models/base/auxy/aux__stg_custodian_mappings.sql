select
      json:CUSTODIAN::text(200)     as custodian
    , json:FIELD::text(200)         as field
    , json:SOURCE::text(200)        as source
    , json:DEFINITION::text(200)    as definition
    , json:NORMALIZED::text(200)    as normalized
    , _box_file_id::int             as _box_file_id
    , _created_at::timestamp        as _created_at
from {{ source('aux', 'custodian_mappings') }}
