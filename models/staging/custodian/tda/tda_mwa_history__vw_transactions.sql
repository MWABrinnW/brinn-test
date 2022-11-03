
select
   value:c1::string          as advisor_rep_code,
   value:c2::date            as file_date,
   value:c3::string          as account_number,
   value:c4::string          as transaction_code,
   value:c5::string          as cancel_status_flag,
   value:c6::string          as symbol,
   value:c7::string          as security_code,
   value:c8::date            as trade_date,
   value:c9::string          as quantity,
   value:c10::double         as net_amount,
   value:c11::decimal(19, 6) as principal,
   value:c12::decimal(19, 6) as broker_fee,
   value:c13::decimal(19, 6) as other_fee,
   value:c14::date           as settle_date,
   value:c15::string         as from_to_account,
   value:c16::string         as account_type,
   value:c17::decimal(19, 6) as accrued_interest,
   value:c18::string         as closing_accounting_method,
   value:c19::string         as comment,
   effective_date::date      as effective_date,
   file_type::string         as file_type
from {{ source('tda_mwa', 'securities') }}