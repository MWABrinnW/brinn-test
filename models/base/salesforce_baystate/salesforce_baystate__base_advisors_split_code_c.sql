select
    'salesforce'::text(200)                                   as system_name
    , 'baystate'::text(200)                                   as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'baystate'::text(200)                                   as firm_source
    , json:_FIVETRAN_SYNCED::timestampntz                     as _fivetran_synced
    , json:CREATED_DATE::timestampntz                         as created_date
    , json:CREATED_BY_ID::text(200)                           as created_by_id
    , json:ID::text(200)                                      as id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:TOTAL_MARKET_VALUE_ROLLUP_C::dec(20 , 2)           as total_market_value_rollup_c
    , json:LAST_MODIFIED_BY_ID::text(200)                     as last_modified_by_id
    , json:LAST_MODIFIED_DATE::timestampntz                   as last_modified_date
    , json:OWNER_ID::text(200)                                as owner_id
    , nullif(json:LAST_VIEWED_DATE , '')::timestampntz        as last_viewed_date
    , json:SYSTEM_MODSTAMP::timestampntz                      as system_modstamp
    , nullif(json:LAST_REFERENCED_DATE , '')::timestampntz    as last_referenced_date
    , json:NAME::text(200)                                    as name--noqa: RF04
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted
    , effective_at::timestampntz                              as effective_at
    , _created_at::timestampntz                               as _created_at
    , {{ col_is_head(
    reference=source('salesforce_baystate', 'advisor_split_code_c'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}

from {{ source('salesforce_baystate', 'advisor_split_code_c') }}
