select *
from {{ source('aux', 'tda_account_mappings') }}
