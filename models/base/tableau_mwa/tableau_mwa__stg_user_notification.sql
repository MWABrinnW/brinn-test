select
    effective_at                        as effective_at
    , _created_at                       as _created_at
    , json:_FIVETRAN_SYNCED::string     as _fivetran_synced
    , json:DISABLED_BY_OVERRIDE::string as disabled_by_override
    , json:_FIVETRAN_ID::string         as _fivetran_id
    , json:CHANNEL::string              as channel
    , json:ENABLED::string              as enabled
    , json:_FIVETRAN_DELETED::string    as _fivetran_deleted
    , json:NOTIFICATION_TYPE::string    as notification_type
    , {{ col_is_head(
    reference=source('tableau_mwa', 'user_notification'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'user_notification') }}
