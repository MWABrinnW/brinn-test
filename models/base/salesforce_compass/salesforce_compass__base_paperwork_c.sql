select
    json:ID::text(200)                          as id
    , json:OWNER_ID::text(200)                  as owner_id
    , json:IS_DELETED::boolean                  as is_deleted
    , json:NAME::text(200)                      as name
    , json:RECORD_TYPE_ID::text(200)            as record_type_id
    , json:CREATED_DATE::timestamptz(9)         as created_date
    , json:CREATED_BY_ID::text(200)             as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz(9)   as last_modified_date
    , json:LAST_MODIFIED_BY_ID::text(200)       as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz(9)      as system_modstamp
    , json:LAST_ACTIVITY_DATE::date             as last_activity_date
    , json:LAST_VIEWED_DATE::timestamptz(9)     as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz(9) as last_referenced_date
    , json:PAPERWORK_ID_18_C::text(200)         as paperwork_id_18_c
    , json:_FIVETRAN_DELETED::boolean           as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamptz(9)     as _fivetran_synced

    , effective_at::timestamp                   as effective_at
    , _created_at::timestamp                    as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'paperwork_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                         as is_latest
from {{ source('salesforce_compass', 'paperwork_c') }}
