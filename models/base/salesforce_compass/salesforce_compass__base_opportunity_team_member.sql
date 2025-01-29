select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:OPPORTUNITY_ID::varchar(18)                      as opportunity_id
    , a.json:USER_ID::varchar(18)                             as user_id
    , a.json:NAME::varchar(1083)                              as name
    , a.json:PHOTO_URL::varchar(765)                          as photo_url
    , a.json:TITLE::varchar(240)                              as title
    , a.json:TEAM_MEMBER_ROLE::varchar(765)                   as team_member_role
    , a.json:OPPORTUNITY_ACCESS_LEVEL::varchar(120)           as opportunity_access_level
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'opportunity_team_member'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case when b.rn_latest = 1 then 1 else 0 end             as is_latest
    , case when b.rn_earliest = 1 then 1 else 0 end           as is_earliest
from {{ source('salesforce_compass', 'opportunity_team_member') }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn_latest
        , row_number() over (partition by a.effective_at::date order by a._created_at asc)  as rn_earliest
    from {{ source('salesforce_compass', 'opportunity_team_member') }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
