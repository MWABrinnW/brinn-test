with cte_content_updates as (
    select
        data                as data
        , content_type      as content_type
        , content_action    as content_action
        , content_id        as content_id
        , version           as version
        , 'content_changes' as smarsh_event_type
        , meta_timestamp    as meta_timestamp
        , meta_id           as meta_id
        , created_at        as created_at
        , updated_at        as updated_at
        , effective_date    as effective_date
        , _fivetran_created as _fivetran_created
    from {{ ref('workvivo__int_content_versions') }}
)

-- Content for comments that aren't linked to any content updates that occured
--   on a given effective_date. Ex: a new comment on a 7-day-old piece of content
, cte_content_for_standalone_comments as (
    select
        data                             as data
        , content_type                   as content_type
        , content_action                 as content_action
        , content_id                     as content_id
        , version                        as version
        , 'content_with_comment_changes' as smarsh_event_type
        , meta_timestamp                 as meta_timestamp
        , meta_id                        as meta_id
        , created_at                     as created_at
        , updated_at                     as updated_at
        , effective_date                 as effective_date
        , _fivetran_created              as _fivetran_created
    from {{ ref('workvivo__int_content_comment_changes') }}
)

, cte_all_comments as (
    select
        data                     as data
        , content_type           as content_type
        , content_action         as content_action
        , content_id             as content_id
        , version                as version
        , parent_comment_id      as parent_comment_id
        , parent_comment_version as parent_comment_version
        , parent_content_id      as parent_content_id
        , parent_content_type    as parent_content_type
        , parent_content_version as parent_content_version
        , 'comment_changes'      as smarsh_event_type
        , meta_timestamp         as meta_timestamp
        , meta_id                as meta_id
        , created_at             as created_at
        , updated_at             as updated_at
        , effective_date         as effective_date
        , _fivetran_created      as _fivetran_created
    from {{ ref('workvivo__int_comment_versions') }}
)

select
    data                as data
    , content_type      as content_type
    , content_action    as content_action
    , content_id        as content_id
    , version           as version
    , null              as parent_comment_id
    , null              as parent_comment_version
    , null              as parent_content_id
    , null              as parent_content_type
    , null              as parent_content_version
    , smarsh_event_type as smarsh_event_type
    , meta_timestamp    as meta_timestamp
    , meta_id           as meta_id
    , created_at        as created_at
    , updated_at        as updated_at
    , effective_date    as effective_date
    , _fivetran_created as _fivetran_created
from cte_content_updates

union all

select
    data                as data
    , content_type      as content_type
    , content_action    as content_action
    , content_id        as content_id
    , version           as version
    , null              as parent_comment_id
    , null              as parent_comment_version
    , null              as parent_content_id
    , null              as parent_content_type
    , null              as parent_content_version
    , smarsh_event_type as smarsh_event_type
    , meta_timestamp    as meta_timestamp
    , meta_id           as meta_id
    , created_at        as created_at
    , updated_at        as updated_at
    , effective_date    as effective_date
    , _fivetran_created as _fivetran_created

from cte_content_for_standalone_comments

union all

select
    data                     as data
    , content_type           as content_type
    , content_action         as content_action
    , content_id             as content_id
    , version                as version
    , parent_comment_id      as parent_comment_id
    , parent_comment_version as parent_comment_version
    , parent_content_id      as parent_content_id
    , parent_content_type    as parent_content_type
    , parent_content_version as parent_content_version
    , smarsh_event_type      as smarsh_event_type
    , meta_timestamp         as meta_timestamp
    , meta_id                as meta_id
    , created_at             as created_at
    , updated_at             as updated_at
    , effective_date         as effective_date
    , _fivetran_created      as _fivetran_created
from cte_all_comments
