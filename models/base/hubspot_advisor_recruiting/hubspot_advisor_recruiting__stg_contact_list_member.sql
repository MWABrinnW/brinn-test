select
    json:CONTACT_ID::text          as contact_id
    , json:CONTACT_LIST_ID::text   as contact_list_id
    , json:ADDED_AT::text          as added_at
    , json:_FIVETRAN_DELETED::text as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::text  as _fivetran_synced

    , effective_at::timestamp      as effective_at
    , _created_at::timestamp       as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'contact_list_member')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                            as is_latest
from {{ source('hubspot_advisor_recruiting', 'contact_list_member') }}
where effective_at is not null
