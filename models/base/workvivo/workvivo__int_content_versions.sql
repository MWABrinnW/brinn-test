select
    data                as data
    , content_type      as content_type
    , content_action    as content_action
    , id                as content_id
    , meta_timestamp    as meta_timestamp
    , meta_id           as meta_id
    , created_at        as created_at
    , updated_at        as updated_at
    , version           as version
    , effective_date    as effective_date
    , _fivetran_created as _fivetran_created
from {{ ref('workvivo__stg_articles') }}

union all

select
    data                as data
    , content_type      as content_type
    , content_action    as content_action
    , id                as content_id
    , meta_timestamp    as meta_timestamp
    , meta_id           as meta_id
    , meta_timestamp    as created_at
    , meta_timestamp    as updated_at
    , version           as version
    , effective_date    as effective_date
    , _fivetran_created as _fivetran_created
from {{ ref('workvivo__stg_events') }}

union all

select
    data                as data
    , content_type      as content_type
    , content_action    as content_action
    , id                as content_id
    , meta_timestamp    as meta_timestamp
    , meta_id           as meta_id
    , created_at        as created_at
    , meta_timestamp    as updated_at
    , version           as version
    , effective_date    as effective_date
    , _fivetran_created as _fivetran_created
from {{ ref('workvivo__stg_updates') }}

union all

select
    data                as data
    , content_type      as content_type
    , content_action    as content_action
    , id                as content_id
    , meta_timestamp    as meta_timestamp
    , meta_id           as meta_id
    , created_at        as created_at
    , meta_timestamp    as updated_at
    , version           as version
    , effective_date    as effective_date
    , _fivetran_created as _fivetran_created
from {{ ref('workvivo__stg_kudos') }}
