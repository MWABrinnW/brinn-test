select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:FILE_TYPE::string         as file_type
    , json:CREATED_AT::string        as created_at
    , json:PROJECT_ID::string        as project_id
    , json:OWNER_ID::string          as owner_id
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:NAME::string              as name
    , json:WEBPAGE_URL::string       as webpage_url
    , json:ID::string                as id
    , json:UPDATED_AT::string        as updated_at
    , json:DESCRIPTION::string       as description
    , {{ col_is_head(
    reference=source('tableau_mwa', 'flow'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'flow') }}
