{% set src = source('salesforce_baystate', 'advisor_split_code_c') %}

select
    'salesforce'::text(900)                                  as system_name
    , 'baystate'::text(900)                                  as system_instance
    , 'salesforce__baystate'::text(900)                      as system_key
    , 'baystate'::text(900)                                  as firm_source
    , a.json:_FIVETRAN_SYNCED::timestampntz                  as _fivetran_synced
    , a.json:CREATED_DATE::timestampntz                      as created_date
    , a.json:CREATED_BY_ID::text(900)                        as created_by_id
    , a.json:ID::text(900)                                   as id
    , a.json:IS_DELETED::boolean                             as is_deleted
    , a.json:TOTAL_MARKET_VALUE_ROLLUP_C::dec(20 , 2)        as total_market_value_rollup_c
    , a.json:LAST_MODIFIED_BY_ID::text(900)                  as last_modified_by_id
    , a.json:LAST_MODIFIED_DATE::timestampntz                as last_modified_date
    , a.json:OWNER_ID::text(900)                             as owner_id
    , nullif(a.json:LAST_VIEWED_DATE , '')::timestampntz     as last_viewed_date
    , a.json:SYSTEM_MODSTAMP::timestampntz                   as system_modstamp
    , nullif(a.json:LAST_REFERENCED_DATE , '')::timestampntz as last_referenced_date
    , a.json:NAME::text(900)                                 as name--noqa: RF04
    , a.json:_FIVETRAN_DELETED::boolean                      as _fivetran_deleted
    , a.effective_at::timestampntz                           as effective_at
    , a._created_at::timestampntz                            as _created_at
    , {{ col_is_head(
        reference=src,
        source_date_col='effective_at',
        reference_date_col='effective_at'
        ) }}
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end::int                                                 as is_head_for_day

from {{ src }} as a
