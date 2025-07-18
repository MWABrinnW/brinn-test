select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:ID::string                as id
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:CONTENT_URL::string       as content_url
    , json:NAME::string              as name
    , json:WORKBOOK_ID::string       as workbook_id
    , json:OWNER_ID::string          as owner_id
    , {{ col_is_head(
    reference=source('tableau_mwa', 'view'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'view') }}
