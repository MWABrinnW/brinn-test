{% set src = source('salesforce_baystate', 'advisor_split_detail_c') %}

select
    'salesforce'::text(200)                                  as system_name
    , 'baystate'::text(200)                                  as system_instance
    , 'salesforce__baystate'::text(200)                      as system_key
    , 'baystate'::text(200)                                  as firm_source
    , a.json:_FIVETRAN_SYNCED::timestampntz                  as _fivetran_synced
    , a.json:CREATED_DATE::timestampntz                      as created_date
    , a.json:CREATED_BY_ID::text(200)                        as created_by_id
    , a.json:ID::text(200)                                   as id
    , a.json:IS_DELETED::boolean                             as is_deleted
    , a.json:ADVISOR_NAME_C::text(200)                       as advisor_name_c
    , a.json:ADVISOR_SPLIT_CODE_C::text(200)                 as advisor_split_code_c
    , a.json:LAST_MODIFIED_BY_ID::text(200)                  as last_modified_by_id
    , a.json:LAST_MODIFIED_DATE::timestampntz                as last_modified_date
    , nullif(a.json:LAST_VIEWED_DATE , '')::timestampntz     as last_viewed_date
    , a.json:PERCENTAGE_C::dec(20 , 2)                       as percentage_c
    , a.json:SYSTEM_MODSTAMP::timestampntz                   as system_modstamp
    , nullif(a.json:LAST_REFERENCED_DATE , '')::timestampntz as last_referenced_date
    , a.json:NAME::text(200)                                 as name--noqa: RF04
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
