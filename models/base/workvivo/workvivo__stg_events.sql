select
    data                                      as data
    , data:action::text                       as action
    , split_part(data:action , '.' , 1)::text as content_type
    , split_part(data:action , '.' , 2)::text as content_action
    , data:meta:attempt::int                  as meta_attempt
    , data:meta:"id"::text                    as meta_id
    , data:meta:"timestamp"::timestamp        as meta_timestamp
    , data:event:all_day_event::boolean       as all_day_event
    , data:event:audience::variant            as audience
    , data:event:comments_count::int          as comments_count
    , data:event:creator::variant             as creator
    , data:event:ends_at::timestamp           as ends_at
    , data:event:external_id::text            as external_id
    , data:event:html_content::text           as html_content
    , data:event:id::text                     as id
    , data:event:"image"::variant             as image
    , data:event:"location"::text             as location
    , data:event:permalink::text              as permalink
    , data:event:reactions_count::int         as reactions_count
    , data:event:scheduled_at::timestamp      as scheduled_at
    , data:event:spaces::variant              as spaces
    , data:event:"text"::text                 as text
    , data:event:title::text                  as title
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
where data:action::text like 'event.%'
