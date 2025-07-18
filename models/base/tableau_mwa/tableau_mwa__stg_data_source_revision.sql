select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:DATA_SOURCE_ID::string    as data_source_id
    , json:REVISION_NUMBER::string   as revision_number
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , {{ col_is_head(
    reference=source('tableau_mwa', 'data_source_revision'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'data_source_revision') }}
