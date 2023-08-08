select
      tda_account_number
    , schwab_account_number
    , firm_source
    , _box_file_id
    , _created_at
from {{ ref('aux__stg_tda_account_mappings') }}
