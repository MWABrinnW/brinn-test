select
    data                                      as data
    , data:action::text                       as action
    , split_part(data:action , '.' , 1)::text as content_type
    , split_part(data:action , '.' , 2)::text as content_action
    , data:meta:attempt::int                  as meta_attempt
    , data:meta:"id"::text                    as meta_id
    , data:meta:"timestamp"::timestamp        as meta_timestamp
    , data:article:audience::variant          as audience
    , data:article:comments_count::int        as comments_count
    , data:article:created_at::timestamp      as created_at
    , data:article:creator::variant           as creator
    , data:article:external_id::text          as external_id
    , data:article:global_audience::boolean   as global_audience
    , data:article:html_content::text         as html_content
    , data:article:id::text                   as id
    , data:article:"image"::variant           as image
    , data:article:is_featured::boolean       as is_featured
    , data:article:language_variants::variant as language_variants
    , data:article:permalink::text            as permalink
    , data:article:published_at::timestamp    as published_at
    , data:article:reactions_count::int       as reactions_count
    , data:article:secondary_image::text      as secondary_image
    , data:article:slug::text                 as slug
    , data:article:subtitle::text             as subtitle
    , data:article:title::text                as title
    , data:article:updated_at::timestamp      as updated_at
    , data:article:user_alias::text           as user_alias
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
where data:action::text like 'article.%'
