select
    'envestnet' as pms
    , 'mwa' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , proposed_investment_group_id
    , risk_tolerance
    , investment_objective
    , {{ col_is_head(reference=source('envestnet_mwa', 'proposal_proposed_investment_group')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'proposal_proposed_investment_group') }}


