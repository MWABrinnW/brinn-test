select
    'envestnet' as pms
    , 'mwa' as pms_location
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
    , product_overlay_feature
    , {{ col_is_head(reference=source('envestnet_mwa', 'proposal_investment')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'proposal_investment') }}


