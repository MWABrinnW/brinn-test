select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , proposal_id
    , customer_registration_id
    , product_id
    , product_name
    , allocation_percentage
    , product_type_id
    , limited_partnership
    , discretion
    , program
    , pricing_tier
    , {{ col_is_head(reference=source('envestnet_mps', 'proposal_investment')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'proposal_investment') }}


