select
    json:"OBJECT_KEY_ROOT"::varchar     as object_key_root
    , json:"SMARSH_EVENT_TYPE"::varchar as smarsh_event_type
    , json:"HTML"::varchar              as html
    , json:"ATTACHMENTS"::array         as attachments
    , json:"EFFECTIVE_DATE"::date       as effective_date
    , json:"_CREATED_AT"::timestamp_ntz as _created_at
from {{ source('workvivo_raw', 'smarsh_html') }}
-- we want the max record for each object_key_root & effective_date combination
qualify _created_at = max(_created_at) over (partition by object_key_root , effective_date)
