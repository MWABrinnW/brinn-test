select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:LOCATION_TYPE::string     as location_type
    , json:CREATED_AT::string        as created_at
    , json:DEFAULT_VIEW_ID::string   as default_view_id
    , json:WEBPAGE_URL::string       as webpage_url
    , json:NAME::string              as name
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:LOCATION_ID::string       as location_id
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:UPDATED_AT::string        as updated_at
    , json:SIZE::string              as size
    , json:CONTENT_URL::string       as content_url
    , json:LOCATION_NAME::string     as location_name
    , json:OWNER_ID::string          as owner_id
    , json:ID::string                as id
    , json:ENCRYPT_EXTRACT::string   as encrypt_extract
    , {{ col_is_head(
    reference=source('tableau_mwa', 'workbook'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'workbook') }}
