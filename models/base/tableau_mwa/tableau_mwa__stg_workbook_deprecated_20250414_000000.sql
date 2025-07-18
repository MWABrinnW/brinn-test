select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:LOCATION_NAME::string     as location_name
    , json:CREATED_AT::string        as created_at
    , json:ID::string                as id
    , json:OWNER_ID::string          as owner_id
    , json:LOCATION_TYPE::string     as location_type
    , json:WEBPAGE_URL::string       as webpage_url
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:SIZE::string              as size
    , json:PROJECT_ID::string        as project_id
    , json:LOCATION_ID::string       as location_id
    , json:CONTENT_URL::string       as content_url
    , json:DEFAULT_VIEW_ID::string   as default_view_id
    , json:NAME::string              as name
    , json:ENCRYPT_EXTRACT::string   as encrypt_extract
    , json:DESCRIPTION::string       as description
    , {{ col_is_head(
    reference=source('tableau_mwa', 'workbook_deprecated_20250414_000000'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'workbook_deprecated_20250414_000000') }}
