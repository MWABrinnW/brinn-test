select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:CLIENT_C::varchar(200)                             as client_c
    , json:CREATED_BY_ID::varchar(200)                        as created_by_id
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:FEE_ACTUAL_C::number(18 , 2)                       as fee_actual_c
    , json:ID::varchar(200)                                   as id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:LAST_MODIFIED_BY_ID::varchar(200)                  as last_modified_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:NAME::varchar(200)                                 as name
    , json:RECORD_TYPE_ID::varchar(200)                       as record_type_id
    , json:SERVICE_CLIENT_ID_C::varchar(200)                  as service_client_id_c
    , json:SERVICE_TYPE_C::varchar(200)                       as service_type_c
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , {{ col_is_head(
    reference=source('salesforce_compass', 'mhservice_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'mhservice_c') }}
