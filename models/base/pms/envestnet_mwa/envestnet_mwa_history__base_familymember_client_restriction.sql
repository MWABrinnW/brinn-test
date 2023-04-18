select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , restriction_id
    , customer_id
    , restriction_type
    , entity_id
    , issued_on
    , expired_on
    , memo
    , updated_by
    , {{ col_is_head(reference=source('envestnet_mwa', 'familymember_client_restriction')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'familymember_client_restriction') }}


