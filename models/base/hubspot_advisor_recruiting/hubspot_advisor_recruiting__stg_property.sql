select
    json:_FIVETRAN_ID::text                                as _fivetran_id
    , json:HUBSPOT_OBJECT::text                            as hubspot_object
    , json:NAME::text                                      as name
    , json:LABEL::text                                     as label
    , json:DESCRIPTION::text                               as description
    , json:GROUP_NAME::text                                as group_name
    , json:TYPE::text                                      as type
    , json:FIELD_TYPE::text                                as field_type
    , json:CALCULATED::text                                as calculated
    , json:CREATED_AT::text                                as created_at
    , json:REFERENCED_OBJECT_TYPE::text                    as referenced_object_type
    , try_to_boolean(json:SHOW_CURRENCY_SYMBOL::text)::int as show_currency_symbol
    , json:UPDATED_AT::text                                as updated_at
    , json:HUBSPOT_DEFINED::text                           as hubspot_defined
    , json:_FIVETRAN_SYNCED::text                          as _fivetran_synced

    , effective_at::timestamp                              as effective_at
    , _created_at::timestamp                               as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'property')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                                                    as is_latest
from {{ source('hubspot_advisor_recruiting', 'property') }}
where effective_at is not null
