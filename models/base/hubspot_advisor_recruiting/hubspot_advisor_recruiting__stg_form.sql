select
    json:GUID::text                         as guid
    , json:PORTAL_ID::text                  as portal_id
    , json:NAME::text                       as name
    , json:ACTION::text                     as action
    , json:METHOD::text                     as method
    , json:CSS_CLASS::text                  as css_class
    , json:REDIRECT::text                   as redirect
    , json:SUBMIT_TEXT::text                as submit_text
    , json:FOLLOW_UP_ID::text               as follow_up_id
    , json:NOTIFY_RECIPIENTS::text          as notify_recipients
    , json:LEAD_NURTURING_CAMPAIGN_ID::text as lead_nurturing_campaign_id
    , json:FORM_TYPE::text                  as form_type
    , json:CREATED_AT::text                 as created_at
    , json:UPDATED_AT::text                 as updated_at
    , json:_FIVETRAN_DELETED::text          as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::text           as _fivetran_synced

    , effective_at::timestamp               as effective_at
    , _created_at::timestamp                as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'form')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                                     as is_latest
from {{ source('hubspot_advisor_recruiting', 'form') }}
where effective_at is not null
