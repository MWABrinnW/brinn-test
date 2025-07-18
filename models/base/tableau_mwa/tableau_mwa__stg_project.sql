select
    effective_at                      as effective_at
    , _created_at                     as _created_at
    , json:_FIVETRAN_DELETED::string  as _fivetran_deleted
    , json:ID::string                 as id
    , json:CONTENT_PERMISSION::string as content_permission
    , json:UPDATED_AT::string         as updated_at
    , json:_FIVETRAN_SYNCED::string   as _fivetran_synced
    , json:DESCRIPTION::string        as description
    , json:OWNER_ID::string           as owner_id
    , json:NAME::string               as name
    , json:CREATED_AT::string         as created_at
    , json:PARENT_PROJECT_ID::string  as parent_project_id
    , {{ col_is_head(
    reference=source('tableau_mwa', 'project'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'project') }}
