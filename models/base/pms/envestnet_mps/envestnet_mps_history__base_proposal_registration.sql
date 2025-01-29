select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , proposal_id
    , customer_registration_id
    , investment_amount
    , registration_name
    , custodian_name
    , registration_type
    , master_account_needed
    , {{ col_is_head(reference=source('envestnet_mps', 'proposal_registration')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'proposal_registration') }}
