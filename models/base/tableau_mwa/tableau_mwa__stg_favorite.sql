select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:LABEL::string             as label
    , json:USERS_ID::string          as users_id
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:SITE_ID::string           as site_id
    , json:VIEW_CREATED_AT::string   as view_created_at
    , json:VIEW_ID::string           as view_id
    , json:WORKBOOK_ID::string       as workbook_id
    , json:VIEW_UPDATED_AT::string   as view_updated_at
    , json:VIEW_URL_NAME::string     as view_url_name
    , {{ col_is_head(
    reference=source('tableau_mwa', 'favorite'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'favorite') }}
