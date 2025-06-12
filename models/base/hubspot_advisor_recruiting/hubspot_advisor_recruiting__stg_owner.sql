select
    json:OWNER_ID::text                    as owner_id
    , json:FIRST_NAME::text                as first_name
    , json:LAST_NAME::text                 as last_name
    , json:EMAIL::text                     as email
    , json:CREATED_AT::text                as created_at
    , json:UPDATED_AT::text                as updated_at
    , json:ACTIVE_USER_ID::text            as active_user_id
    , json:IS_ACTIVE::text                 as is_active
    , json:USER_ID_INCLUDING_INACTIVE::int as user_id_including_inactive
    , json:_FIVETRAN_SYNCED::text          as _fivetran_synced

    , effective_at::timestamp              as effective_at
    , _created_at::timestamp               as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'owner')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                                    as is_latest
from {{ source('hubspot_advisor_recruiting', 'owner') }}
where effective_at is not null
