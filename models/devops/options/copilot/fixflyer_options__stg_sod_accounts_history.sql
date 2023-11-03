select
    effective_date::date                as effective_date
  , account_no::text(200)               as account_no
  , account_name::text(200)             as account_name
  , custodian::text(200)                as custodian
  , description::text(200)              as description
  , notes::text(200)                    as notes
  , model_name::text(200)               as model_name
  , closing_method::text(200)           as closing_method
  , long_term_tax_rate::decimal(19, 6)  as long_term_tax_rate
  , short_term_tax_rate::decimal(19, 6) as short_term_tax_rate
  , use_account_cash::text(200)         as use_account_cash
  , cash_reserve_type::text(200)        as cash_reserve_type
  , cash_reserve::text(200)             as cash_reserve
  , taxable::text(200)                  as taxable
  , cashreserveexpiry::text(200)        as cashreserveexpiry
  , disablesleeves::text(200)           as disablesleeves
  , portfoliocode1::text(200)           as portfoliocode1
  , portfoliocode2::text(200)           as portfoliocode2
  , portfoliocode3::text(200)           as portfoliocode3
  , accounttype::text(200)              as accounttype
  , associated_users::text(600)         as associated_users
  , _created_at::timestamp_ntz          as created_at
from {{ source('copilot', 'sod_accounts_history') }}
