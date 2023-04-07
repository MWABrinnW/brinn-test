select
    '0' || fa_master_account_number as fa_master_account_number
  , fa_master_account_description   as fa_master_account_description
  , fa_rep_name                     as fa_rep_name
  , sub_account_number              as sub_account_number
  , sub_account_name                as sub_account_name
  , sub_account_tax_id_number       as sub_account_tax_id_number
  , effective_date                  as effective_date
  ,{{ col_is_head(reference=source('schwab_mwa', 'master_account_relationships')) }}
  ,{{ col_is_current(date_col='effective_date') }}
  , _record_datetime::timestamp     as _source_loaded_at
from {{ source('schwab_mps', 'master_account_relationships') }}