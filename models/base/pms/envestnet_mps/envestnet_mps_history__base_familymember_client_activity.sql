select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , activity_id
    , customer_id
    , activity_type
    , activity_details
    , date_posted
    , {{ col_is_head(reference=source('envestnet_mps', 'familymember_client_activity')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'familymember_client_activity') }}


