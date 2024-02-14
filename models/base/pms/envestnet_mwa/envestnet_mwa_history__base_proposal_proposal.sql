select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , record_type
    , proposal_group_id
    , rep_code
    , updated_date
    , proposal_type
    , title
    , advisor_id
    , advisor_name
    , client_currency
    , created_date
    , customer_id
    , city
    , state
    , zip
    , {{ col_is_head(reference=source('envestnet_mwa', 'proposal_proposal')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'proposal_proposal') }}


