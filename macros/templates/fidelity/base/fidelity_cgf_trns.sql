{%- macro fidelity_cgf_trns(src) -%}

select
    nullif(trim(substring(content, 1, 10)), '')::varchar(10) as g_number
  , nullif(trim(substring(content, 11, 10)), '')::varchar(10) as cgf_account_number
  , nullif(trim(substring(content, 21, 15)), '')::varchar(15) as symbol
  , nullif(trim(substring(content, 36, 4)), '')::varchar(4) as transaction_mnemonic
  , nullif(trim(substring(content, 40, 30)), '')::varchar(30) as transaction_description
  , iff(substring(content, 70, 1)='-', -1, 1) * nullif(trim(substring(content, 71, 11)), '')::decimal(11,3) as units_value
  , iff(substring(content, 82, 1)='-', -1, 1) * nullif(trim(substring(content, 83, 11)), '')::decimal(11,6) as nav_price
  , iff(substring(content, 94, 1)='-', -1, 1) * nullif(trim(substring(content, 95, 11)), '')::decimal(11,2) as amount_value
  , try_to_date(nullif(trim(substring(content, 106, 10)), ''), 'YYYY-MM-DD')::date as process_date
  , nullif(trim(substring(content, 126, 8)), '')::varchar(8) as advisor_transaction_status
  , nullif(trim(substring(content, 134, 9)), '')::varchar(9) as cusip
  , nullif(trim(substring(content, 143, 5)), '')::varchar(5) as transaction_type_code
  , iff(substring(content, 148, 1)='-', -1, 1) * nullif(trim(substring(content, 149, 9)), '')::decimal(11,2) as commission_amount
  , nullif(trim(substring(content, 158, 8)), '')::varchar(8) as fund_source
  , nullif(trim(substring(content, 166, 4)), '')::varchar(4) as broker_code
  , nullif(trim(substring(content, 170, 2)), '')::varchar(2) as security_type
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , try_to_date(nullif(trim(substring(content, 116, 10)), ''), 'YYYY-MM-DD')::date as effective_date
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 1) = 'G'

{%- endmacro -%}