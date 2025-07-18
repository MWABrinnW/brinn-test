select
    effective_at                      as effective_at
    , _created_at                     as _created_at
    , json:_FIVETRAN_DELETED::string  as _fivetran_deleted
    , json:ID::string                 as id
    , json:UPDATED_AT::string         as updated_at
    , json:SUSPENDED::string          as suspended
    , json:_FIVETRAN_SYNCED::string   as _fivetran_synced
    , json:WEBPAGE_URL::string        as webpage_url
    , json:NAME::string               as name
    , json:CREATED_AT::string         as created_at
    , json:PROJECT_ID::string         as project_id
    , json:UNDERLYING_VIEW_ID::string as underlying_view_id
    , json:OWNER_ID::string           as owner_id
    , {{ col_is_head(
    reference=source('tableau_mwa', 'metric'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'metric') }}
