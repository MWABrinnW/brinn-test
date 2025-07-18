select
    effective_at                     as effective_at
    , _created_at                    as _created_at
    , json:_FIVETRAN_SYNCED::string  as _fivetran_synced
    , json:ID::string                as id
    , json:NAME::string              as name
    , json:DOMAIN_NAME::string       as domain_name
    , json:_FIVETRAN_DELETED::string as _fivetran_deleted
    , json:USER_ID::string           as user_id
    , {{ col_is_head(
    reference=source('tableau_mwa', 'groups'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'groups') }}
