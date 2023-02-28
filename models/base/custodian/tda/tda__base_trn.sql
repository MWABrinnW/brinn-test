select
    json:c1::varchar(100)      as advisor_rep_code
  , json:c2::date              as file_date
  , json:c3::varchar(100)      as account_number
  , json:c4::varchar(100)      as transaction_code
  , json:c5::varchar(100)      as cancel_status_flag
  , json:c6::varchar(100)      as symbol
  , json:c7::varchar(100)      as security_code
  , json:c8::date              as trade_date
  , json:c9::varchar(100)      as quantity
  , json:c10::double           as net_amount
  , json:c11::decimal(19, 6)   as principal
  , json:c12::decimal(19, 6)   as broker_fee
  , json:c13::decimal(19, 6)   as other_fee
  , json:c14::date             as settle_date
  , json:c15::varchar(100)     as from_to_account
  , json:c16::varchar(100)     as account_type
  , json:c17::decimal(19, 6)   as accrued_interest
  , json:c18::varchar(100)     as closing_accounting_method
  , json:c19::varchar(100)     as comment
  , rc.firm                    as rep_code_firm
  , rc.status                  as rep_code_status
  , rc.description             as rep_code_description
  , effective_date::date       as effective_date
  , _rep_code::varchar(10)     as _rep_code
  , _file_type::varchar(100)   as _file_type
  , _source_file::varchar(100) as _source_file 
  , _created_at::timestamp     as _created_at
  , {{ col_is_head(reference=source('tda', 'trn')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('tda', 'trn') }} a
left join {{ref('tda__rep_codes')}} rc
  on a._rep_code = rc.rep_code