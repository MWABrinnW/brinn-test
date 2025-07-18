select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:TYPE::string              as type
    , json:FREQUENCY::string         as frequency
    , json:PRIORITY::string          as priority
    , json:UPDATED_AT::string        as updated_at
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:STATE::string             as state
    , json:ID::string                as id
    , json:CREATED_AT::string        as created_at
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:NEXT_RUN_AT::string       as next_run_at
    , json:NAME::string              as name
    , {{ col_is_head(
    reference=source('tableau_mwa', 'server_schedule'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'server_schedule') }}
