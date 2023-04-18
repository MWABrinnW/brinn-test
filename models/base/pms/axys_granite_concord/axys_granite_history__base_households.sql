select
    'axys' as pms
    , 'granite' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , asset_account_number
    , entity_id
    , entity_name
    , entity_owner
    , {{ col_is_head(reference=source('axys_granite', 'households_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('axys_granite', 'households_monthly') }}