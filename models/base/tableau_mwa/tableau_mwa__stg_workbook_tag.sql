select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:LABEL::string             as label
    , json:WORKBOOK_ID::string       as workbook_id
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , {{ col_is_head(
    reference=source('tableau_mwa', 'workbook_tag'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'workbook_tag') }}
