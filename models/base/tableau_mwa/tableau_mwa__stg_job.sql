select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:ENDED_AT::string          as ended_at
    , json:SITE_ID::string           as site_id
    , json:STARTED_AT::string        as started_at
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:ID::string                as id
    , json:CREATED_AT::string        as created_at
    , json:STATUS::string            as status
    , json:PRIORITY::string          as priority
    , json:JOB_TYPE::string          as job_type
    , {{ col_is_head(
    reference=source('tableau_mwa', 'job'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'job') }}
