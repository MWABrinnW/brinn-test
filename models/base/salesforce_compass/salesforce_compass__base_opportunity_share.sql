select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OPPORTUNITY_ID::varchar(18)                        as opportunity_id
    , json:USER_OR_GROUP_ID::varchar(18)                      as user_or_group_id
    , json:OPPORTUNITY_ACCESS_LEVEL::varchar(120)             as opportunity_access_level
    , json:ROW_CAUSE::varchar(120)                            as row_cause
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'opportunity_share')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'opportunity_share') }}
