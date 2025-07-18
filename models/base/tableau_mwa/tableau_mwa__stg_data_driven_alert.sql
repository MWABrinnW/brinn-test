select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:WORKBOOK_ID::string       as workbook_id
    , json:FREQUENCY::string         as frequency
    , json:SUBJECT::string           as subject
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:UPDATED_AT::string        as updated_at
    , json:ID::string                as id
    , json:CREATED_AT::string        as created_at
    , json:PROJECT_ID::string        as project_id
    , json:PUBLIC::string            as public
    , json:OWNER_ID::string          as owner_id
    , {{ col_is_head(
    reference=source('tableau_mwa', 'data_driven_alert'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'data_driven_alert') }}
