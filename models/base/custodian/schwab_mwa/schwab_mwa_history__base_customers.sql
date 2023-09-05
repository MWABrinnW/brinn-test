{{ config(enabled=false) }}
select
   'schwab'                    as custodian
  , 'mwa'                      as firm_source
  , accountnumber              as account_number
  , accountdesc                as account_description
  , accountaddr1               as account_address_1
  , accountaddr2               as account_address_2
  , accountaddr3               as account_address_3
  , accountaddr4               as account_address_4
  , phone1                     as phone_1
  , phone2                     as phone_2
  , accountopendate            as account_open_date
  , branchid                   as branch_id
  , taxid                      as tax_id
  , mmf                        as mmf
  , cashinstructions           as cash_instructions
  , margininstructions         as margin_instructions
  , restrictions               as restrictions
  , optionlevel                as option_level
  , effective_date::date       as effective_date
  ,{{ col_is_head(reference=source('schwab_mwa', 'customer')) }}
  ,{{ col_is_current(date_col='effective_date') }}
  , record_datetime::timestamp as record_datetime
  , record_date::date          as record_date
  , record_datetime::timestamp as _source_loaded_at
from {{ source('schwab_mwa', 'customer') }}