{{ config(
  grants = {'+select': ['ops_mwa']}
) }}

select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:NAME::varchar(240)                                 as name
    , json:DEVELOPER_NAME::varchar(240)                       as developer_name
    , json:NAMESPACE_PREFIX::varchar(45)                      as namespace_prefix
    , json:DESCRIPTION::varchar(765)                          as description
    , json:BUSINESS_PROCESS_ID::varchar(18)                   as business_process_id
    , json:SOBJECT_TYPE::varchar(120)                         as sobject_type
    , json:IS_ACTIVE::boolean                                 as is_active
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'record_type')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'record_type') }}
