select
    'axys'::text(200)                                         as system_name
    , 'granite'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , effective_date::date                                    as effective_date
    , json:"ASSET_ACCOUNT_NUMBER"::text(200)                  as asset_account_number
    , json:"ENTITY_ID"::text(200)                             as entity_id
    , json:"ENTITY_NAME"::text(200)                           as entity_name
    , json:"ENTITY_OWNER"::text(200)                          as entity_owner
    , {{ col_is_head(reference=source('axys_granite', 'households')) }}
    , _source_file::text(200)                                 as _source_file
    , _created_at::datetime                                   as _created_at
    , _id::int                                                as _id
from {{ source('axys_granite', 'households') }}
