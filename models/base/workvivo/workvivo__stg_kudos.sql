select
    data                                      as data
    , data:action::text                       as action
    , split_part(data:action , '.' , 1)::text as content_type
    , split_part(data:action , '.' , 2)::text as content_action
    , data:meta:attempt::int                  as meta_attempt
    , data:meta:"id"::text                    as meta_id
    , data:meta:"timestamp"::timestamp        as meta_timestamp
    , data:kudos:comments_count::int          as comments_count
    , data:kudos:created_at::timestamp        as created_at
    , data:kudos:creator::variant             as creator
    , data:kudos:gallery::variant             as gallery
    , data:kudos:goal::text                   as goal
    , data:kudos:html::text                   as html
    , data:kudos:id::text                     as id
    , data:kudos:language_code::text          as language_code
    , data:kudos:legacy_system_id::text       as legacy_system_id
    , data:kudos:link::text                   as link
    , data:kudos:permalink::text              as permalink
    , data:kudos:poll::text                   as poll
    , data:kudos:reactions_count::int         as reactions_count
    , data:kudos:shared_post::text            as shared_post
    , data:kudos:shared_spaces::text          as shared_spaces
    , data:kudos:"text"::text                 as text
    , data:kudos:unshared_spaces::text        as unshared_spaces
    , data:kudos:video::text                  as video
    , row_number() over (
        partition by id
        order by meta_timestamp
    )::text                                   as version
    , date(_created)                          as effective_date
    , _created                                as _fivetran_created
    , _id                                     as _fivetran_id
    , _index                                  as _fivetran_index
    , _ip                                     as _fivetran_ip
    , _fivetran_synced                        as _fivetran_synced
from {{ source('workvivo_fivetran', 'webhook_packed') }}
where data:action::text like 'kudos.%'
