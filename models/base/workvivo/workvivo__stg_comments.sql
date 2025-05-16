select
    data                                      as data
    , data:action::text                       as action
    , split_part(data:action , '.' , 1)::text as content_type
    , split_part(data:action , '.' , 2)::text as content_action
    , data:meta:attempt::int                  as meta_attempt
    , data:meta:id::text                      as meta_id
    , data:meta:timestamp::timestamp          as meta_timestamp
    , data:comment:comment_external_id::text  as comment_external_id
    , data:comment:comment_id::text           as content_id
    , data:comment:comment_parent_id::text    as parent_comment_id
    , data:comment:created_at::timestamp      as created_at
    , data:comment:creator::variant           as creator
    , data:comment:has_replies::boolean       as has_replies
    , data:comment:html::text                 as html
    , data:comment:"image"::variant           as image
    , data:comment:item_id::text              as parent_content_id
    , data:comment:item_type::text            as parent_content_type
    , data:comment:"text"::text               as text
    , data:comment:updated_at::timestamp      as updated_at
    , row_number() over (
        partition by content_id
        order by meta_timestamp
    )::text                                   as version
    , date(_created)                          as effective_date
    , _created                                as _fivetran_created
    , _id                                     as _fivetran_id
    , _index                                  as _fivetran_index
    , _ip                                     as _fivetran_ip
    , _fivetran_synced                        as _fivetran_synced
from {{ source('workvivo_fivetran', 'webhook_packed') }}
where data:action::text like 'comment.%'
