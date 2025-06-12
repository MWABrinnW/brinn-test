select
    json:LABEL::text              as label
    , json:PROPERTY_ID::text      as property_id
    , json:VALUE::text            as value
    , json:DISPLAY_ORDER::text    as display_order
    , json:HIDDEN::text           as hidden
    , json:_FIVETRAN_SYNCED::text as _fivetran_synced

    , effective_at::timestamp     as effective_at
    , _created_at::timestamp      as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'property_option')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                           as is_latest
from {{ source('hubspot_advisor_recruiting', 'property_option') }}
where effective_at is not null
