with parent_content_versions as (
    select
        c.data                  as c_data
        , c.action              as c_action
        , c.content_type        as c_content_type
        , c.version             as c_version
        , c.content_action      as c_content_action
        , c.meta_timestamp      as c_meta_timestamp
        , c.meta_id             as c_meta_id
        , c.content_id          as c_content_id
        , c.parent_comment_id   as c_parent_comment_id
        , c.created_at          as c_created_at
        , c.parent_content_id   as c_parent_content_id
        , c.parent_content_type as c_parent_content_type
        , c.text                as c_text
        , c.updated_at          as c_updated_at
        , c.effective_date      as c_effective_date
        , c._fivetran_created   as c__fivetran_created
        , v.content_type        as v_content_type
        , v.content_id          as v_content_id
        , v.meta_timestamp      as v_meta_timestamp
        , v.updated_at          as v_updated_at
        , v.version             as v_version
    from {{ ref('workvivo__stg_comments') }} as c
    left join {{ ref('workvivo__int_content_versions') }} as v
        on c.parent_content_id = v.content_id
        and c.parent_content_type = v.content_type
)

, content_rn as (
    select
        c_data                  as c_data
        , c_action              as c_action
        , c_content_type        as c_content_type
        , c_version             as c_version
        , c_content_action      as c_content_action
        , c_meta_id             as c_meta_id
        , c_meta_timestamp      as c_meta_timestamp
        , c_content_id          as c_content_id
        , c_parent_comment_id   as c_parent_comment_id
        , c_created_at          as c_created_at
        , c_parent_content_id   as c_parent_content_id
        , c_parent_content_type as c_parent_content_type
        , c_text                as c_text
        , c_updated_at          as c_updated_at
        , c_effective_date      as c_effective_date
        , c__fivetran_created   as c__fivetran_created
        , v_updated_at          as v_updated_at
        , v_version             as v_version
        , row_number() over (
            partition by c_content_id , c_content_action , c_parent_content_id , c_updated_at , c_meta_timestamp
            order by v_updated_at desc
        )                       as rn
    from parent_content_versions
    -- Filter to only content with a timestamp that occurs prior to the comment
    -- Null v_updated_at means we don't have a record of that piece of content,
    --  so we will process it as a standalone comment
    where c_updated_at >= v_updated_at
        or v_updated_at is null
)

, content_rn_final as (
    select
        c_data                  as data
        , c_action              as action
        , c_content_type        as content_type
        , c_version             as version
        , c_content_action      as content_action
        , c_meta_id             as meta_id
        , c_meta_timestamp      as meta_timestamp
        , c_content_id          as content_id
        , c_parent_comment_id   as parent_comment_id
        , c_created_at          as created_at
        , c_parent_content_id   as parent_content_id
        , c_parent_content_type as parent_content_type
        , c_text                as text
        , c_updated_at          as updated_at
        , c_effective_date      as effective_date
        , c__fivetran_created   as _fivetran_created
        , v_version             as parent_content_version
    from content_rn
    -- Grab the most recent content timestamp based on the previous filter
    where rn = 1
)

, parent_comment_versions as (
    select
        c.data                     as c_data
        , c.action                 as c_action
        , c.content_type           as c_content_type
        , c.version                as c_version
        , c.content_action         as c_content_action
        , c.meta_id                as c_meta_id
        , c.meta_timestamp         as c_meta_timestamp
        , c.content_id             as c_content_id
        , c.parent_comment_id      as c_parent_comment_id
        , c.created_at             as c_created_at
        , c.parent_content_id      as c_parent_content_id
        , c.parent_content_type    as c_parent_content_type
        , c.parent_content_version as c_parent_content_version
        , c.text                   as c_text
        , c.updated_at             as c_updated_at
        , c.effective_date         as c_effective_date
        , c._fivetran_created      as c__fivetran_created
        , pc.action                as pc_action
        , pc.content_type          as pc_content_type
        , pc.version               as pc_version
        , pc.content_action        as pc_content_action
        , pc.meta_id               as pc_meta_id
        , pc.meta_timestamp        as pc_meta_timestamp
        , pc.content_id            as pc_content_id
        , pc.parent_comment_id     as pc_parent_comment_id
        , pc.created_at            as pc_created_at
        , pc.parent_content_id     as pc_parent_content_id
        , pc.parent_content_type   as pc_parent_content_type
        , pc.text                  as pc_text
        , pc.updated_at            as pc_updated_at
        , pc.effective_date        as pc_effective_date
        , pc._fivetran_created     as pc__fivetran_created
    from content_rn_final as c
    left join {{ ref('workvivo__stg_comments') }} as pc
        on c_parent_comment_id = pc_content_id
)

, comment_rn as (
    select
        c_data                     as c_data
        , c_action                 as c_action
        , c_content_type           as c_content_type
        , c_version                as c_version
        , c_content_action         as c_content_action
        , c_meta_id                as c_meta_id
        , c_meta_timestamp         as c_meta_timestamp
        , c_content_id             as c_content_id
        , c_parent_comment_id      as c_parent_comment_id
        , c_created_at             as c_created_at
        , c_parent_content_id      as c_parent_content_id
        , c_parent_content_type    as c_parent_content_type
        , c_parent_content_version as c_parent_content_version
        , c_text                   as c_text
        , c_updated_at             as c_updated_at
        , c_effective_date         as c_effective_date
        , c__fivetran_created      as c__fivetran_created
        , pc_content_id            as pc_content_id
        , pc_updated_at            as pc_updated_at
        , pc_version               as pc_version
        , row_number() over (
            partition by c_content_id , c_content_action , c_parent_comment_id , c_updated_at , c_meta_timestamp
            order by pc_updated_at desc
        )                          as rn
    from parent_comment_versions
    -- Null c_parent_comment_id just means the comment is not a reply, so we still
    --   want to pull those through
    where c_updated_at >= pc_updated_at
        or c_parent_comment_id is null
)

select
    c_data                     as data
    , c_content_type           as content_type
    , c_content_action         as content_action
    , c_content_id             as content_id
    , c_version                as version
    , c_parent_comment_id      as parent_comment_id
    , pc_version               as parent_comment_version
    , c_parent_content_id      as parent_content_id
    , c_parent_content_type    as parent_content_type
    , c_parent_content_version as parent_content_version
    , c_meta_timestamp         as meta_timestamp
    , c_meta_id                as meta_id
    , c_created_at             as created_at
    , c_updated_at             as updated_at
    , c_effective_date         as effective_date
    , c__fivetran_created      as _fivetran_created
from comment_rn
where rn = 1
