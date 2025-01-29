select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:MASTER_LABEL::varchar(765)                       as master_label
    , a.json:API_NAME::varchar(765)                           as api_name
    , a.json:IS_ACTIVE::boolean                               as is_active
    , a.json:SORT_ORDER::number                               as sort_order
    , a.json:IS_CLOSED::boolean                               as is_closed
    , a.json:IS_WON::boolean                                  as is_won
    , a.json:FORECAST_CATEGORY::varchar(120)                  as forecast_category
    , a.json:FORECAST_CATEGORY_NAME::varchar(765)             as forecast_category_name
    , a.json:DEFAULT_PROBABILITY::double                      as default_probability
    , a.json:DESCRIPTION::varchar(765)                        as description
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'opportunity_stage'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case when b.rn_latest = 1 then 1 else 0 end             as is_latest
    , case when b.rn_earliest = 1 then 1 else 0 end           as is_earliest
from {{ source('salesforce_compass', 'opportunity_stage') }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn_latest
        , row_number() over (partition by a.effective_at::date order by a._created_at asc)  as rn_earliest
    from {{ source('salesforce_compass', 'opportunity_stage') }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
