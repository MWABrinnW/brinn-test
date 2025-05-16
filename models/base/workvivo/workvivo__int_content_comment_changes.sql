with cte_comment_changes as (
    select distinct
        parent_content_id
        , parent_content_type
        , parent_content_version
        , effective_date
    from {{ ref('workvivo__int_comment_versions') }}
)

, cte_content_changes as (
    select distinct
        content_id
        , content_type
        , version
        , effective_date
    from {{ ref('workvivo__int_content_versions') }}
)

, cte_comment_changes_filtered as (
    select
        cmt.parent_content_id
        , cmt.parent_content_type
        , cmt.parent_content_version
        , cmt.effective_date
    from cte_comment_changes as cmt
    left outer join cte_content_changes as cnt
        on cmt.parent_content_id = cnt.content_id
        and cmt.parent_content_type = cnt.content_type
        and cmt.parent_content_version = cnt.version
        and cmt.effective_date = cnt.effective_date
    where cnt.content_id is null
)

select
    cv.data                as data
    , cv.content_type      as content_type
    , cv.content_action    as content_action
    , cv.content_id        as content_id
    , cv.meta_timestamp    as meta_timestamp
    , cv.meta_id           as meta_id
    , cv.created_at        as created_at
    , cv.updated_at        as updated_at
    , cv.version           as version
    , cc.effective_date    as effective_date
    , cv._fivetran_created as _fivetran_created
from {{ ref('workvivo__int_content_versions') }} as cv
inner join cte_comment_changes_filtered as cc
    on cv.content_id = cc.parent_content_id
    and cv.content_type = cc.parent_content_type
    and cv.version = cc.parent_content_version
