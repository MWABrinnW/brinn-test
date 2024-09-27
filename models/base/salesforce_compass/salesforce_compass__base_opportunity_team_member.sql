select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OPPORTUNITY_ID::varchar(18)                        as opportunity_id
    , json:USER_ID::varchar(18)                               as user_id
    , json:NAME::varchar(1083)                                as name
    , json:PHOTO_URL::varchar(765)                            as photo_url
    , json:TITLE::varchar(240)                                as title
    , json:TEAM_MEMBER_ROLE::varchar(765)                     as team_member_role
    , json:OPPORTUNITY_ACCESS_LEVEL::varchar(120)             as opportunity_access_level
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:IS_DELETED::boolean                                as is_deleted
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'opportunity_team_member')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'opportunity_team_member') }}
