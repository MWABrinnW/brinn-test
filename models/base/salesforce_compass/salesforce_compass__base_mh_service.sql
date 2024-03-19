select
    a.json:CLIENT_C::varchar(200)              as client_c
    , a.json:CREATED_BY_ID::varchar(200)       as created_by_id
    , a.json:CREATED_DATE::timestamptz         as created_date
    , a.json:FEE_ACTUAL_C::number(18 , 2)      as fee_actual_c
    , a.json:ID::varchar(200)                  as id
    , a.json:IS_DELETED::boolean               as is_deleted
    , a.json:LAST_MODIFIED_BY_ID::varchar(200) as last_modified_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz   as last_modified_date
    , a.json:NAME::varchar(200)                as name
    , a.json:RECORD_TYPE_ID::varchar(200)      as record_type_id
    , a.json:SERVICE_CLIENT_ID_C::varchar(200) as service_client_id_c
    , a.json:SERVICE_TYPE_C::varchar(200)      as service_type_c
    , a.json:SYSTEM_MODSTAMP::timestamptz      as system_modstamp
    , a.json:_FIVETRAN_DELETED::boolean        as _fivetran_deleted
    , a.json:_FIVETRAN_SYNCED::timestamptz     as _fivetran_synced
    , {{ col_is_head(reference=source('salesforce_compass', 'mhservice_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case when b.rn = 1 then 1 else 0 end::int     as is_latest
from {{ source('salesforce_compass', 'mhservice_c') }} as a
left join (
    select
        effective_at::date                                                              as effective_at
        , _created_at
        , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'mhservice_c') }}
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at
    and a._created_at = b._created_at