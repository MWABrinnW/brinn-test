select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , proposal_id
    , total_investment
    , funding_method
    , {{ col_is_head(reference=source('envestnet_mwa', 'proposal_solution')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'proposal_solution') }}


