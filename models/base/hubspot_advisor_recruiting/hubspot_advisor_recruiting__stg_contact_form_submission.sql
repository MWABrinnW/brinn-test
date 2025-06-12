select
    json:CONTACT_ID::text         as contact_id
    , json:FORM_ID::text          as form_id
    , json:CONVERSION_ID::text    as conversion_id
    , json:TIMESTAMP::text        as timestamp
    , json:TITLE::text            as title
    , json:PORTAL_ID::text        as portal_id
    , json:PAGE_ID::text          as page_id
    , json:PAGE_URL::text         as page_url
    , json:_FIVETRAN_SYNCED::text as _fivetran_synced

    , effective_at::timestamp     as effective_at
    , _created_at::timestamp      as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'contact_form_submission')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                           as is_latest
from {{ source('hubspot_advisor_recruiting', 'contact_form_submission') }}
where effective_at is not null
