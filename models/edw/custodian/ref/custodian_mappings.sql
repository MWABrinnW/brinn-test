select
      custodian
    , field
    , source
    , definition
    , normalized
    , _box_file_id
    , _created_at
from {{ ref('aux__stg_custodian_mappings') }}
