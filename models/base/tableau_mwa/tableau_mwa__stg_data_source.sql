select
    effective_at                          as effective_at
    , _created_at                         as _created_at
    , json:UPDATED_AT::string             as updated_at
    , json:CONTENT_URL::string            as content_url
    , json:NAME::string                   as name
    , json:_FIVETRAN_DELETED::string      as _fivetran_deleted
    , json:USE_REMOTE_QUERY_AGENT::string as use_remote_query_agent
    , json:_FIVETRAN_SYNCED::string       as _fivetran_synced
    , json:HAS_EXTRACT::string            as has_extract
    , json:PROJECT_ID::string             as project_id
    , json:OWNER_ID::string               as owner_id
    , json:ENCRYPT_EXTRACT::string        as encrypt_extract
    , json:IS_CERTIFIED::string           as is_certified
    , json:CREATED_AT::string             as created_at
    , json:ID::string                     as id
    , json:WEBPAGE_URL::string            as webpage_url
    , {{ col_is_head(
    reference=source('tableau_mwa', 'data_source'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}

from {{ source('tableau_mwa', 'data_source') }}
