select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:OWNER_ID::varchar(18)                            as owner_id
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:NAME::varchar(240)                               as name
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:LAST_VIEWED_DATE::timestamptz                    as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                as last_referenced_date
    , a.json:ACQUIRED_DATE_C::date                            as acquired_date_c
    , a.json:COMMENTS_C::varchar(98304)                       as comments_c
    , a.json:FIRM_C::varchar(18)                              as firm_c
    , a.json:MHLOCATION_C::varchar(18)                        as mhlocation_c
    , a.json:TYPE_C::varchar(765)                             as type_c
    , a.json:GOAL_CLIENTS_C::double                           as goal_clients_c
    , a.json:GOAL_ASSETS_C::number(18)                        as goal_assets_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:CLIENT_MANAGER_C::varchar(18)                    as client_manager_c
    , a.json:GOAL_REVENUE_C::number(12)                       as goal_revenue_c
    , a.json:IGODEAL_ID_C::varchar(765)                       as igodeal_id_c
    , a.json:ADP_EMPLOYEE_SOURCE_C::varchar(765)              as adp_employee_source_c
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'mhacquisition_c'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case when b.rn_latest = 1 then 1 else 0 end             as is_latest
    , case when b.rn_earliest = 1 then 1 else 0 end           as is_earliest
from {{ source('salesforce_compass', 'mhacquisition_c') }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn_latest
        , row_number() over (partition by a.effective_at::date order by a._created_at asc)  as rn_earliest
    from {{ source('salesforce_compass', 'mhacquisition_c') }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
