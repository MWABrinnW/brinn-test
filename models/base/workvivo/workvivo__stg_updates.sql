select
    data                                      as data
    , data:action::text                       as action
    , split_part(data:action , '.' , 1)::text as content_type
    , split_part(data:action , '.' , 2)::text as content_action
    , data:meta:attempt::int                  as meta_attempt
    , data:meta:"id"::text                    as meta_id
    , data:meta:"timestamp"::timestamp        as meta_timestamp
    , data:update:comments_count::int         as comments_count
    , data:update:created_at::timestamp       as created_at
    , data:update:creator::variant            as creator
    , data:update:gallery::variant            as gallery
    , data:update:goal::text                  as goal
    , data:update:html::text                  as html
    , data:update:id::text                    as id
    , data:update:legacy_system_id::text      as legacy_system_id
    , data:update:link::text                  as link
    , data:update:permalink::text             as permalink
    , data:update:poll::text                  as poll
    , data:update:reactions_count::int        as reactions_count
    , data:update:shared_post::text           as shared_post
    , data:update:shared_spaces::text         as shared_spaces
    , data:update:"text"::text                as text
    , data:update:unshared_spaces::text       as unshared_spaces
    , data:update:video::text                 as video
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
where data:action::text like 'update.%'
