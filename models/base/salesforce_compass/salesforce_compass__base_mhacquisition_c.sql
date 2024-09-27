select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::varchar(240)                                 as name
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:ACQUIRED_DATE_C::date                              as acquired_date_c
    , json:COMMENTS_C::varchar(98304)                         as comments_c
    , json:FIRM_C::varchar(18)                                as firm_c
    , json:MHLOCATION_C::varchar(18)                          as mhlocation_c
    , json:TYPE_C::varchar(765)                               as type_c
    , json:GOAL_CLIENTS_C::double                             as goal_clients_c
    , json:GOAL_ASSETS_C::number(18)                          as goal_assets_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:CLIENT_MANAGER_C::varchar(18)                      as client_manager_c
    , json:GOAL_REVENUE_C::number(12)                         as goal_revenue_c
    , json:IGODEAL_ID_C::varchar(765)                         as igodeal_id_c
    , json:ADP_EMPLOYEE_SOURCE_C::varchar(765)                as adp_employee_source_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'mhacquisition_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'mhacquisition_c') }}
