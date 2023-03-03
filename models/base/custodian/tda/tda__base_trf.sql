select
    json:c1::varchar(100)       as company_name
  , json:c2::varchar(100)       as last_name
  , json:c3::varchar(100)       as first_name
  , json:c4::varchar(100)       as street
  , json:c5::varchar(100)       as address_2
  , json:c6::varchar(100)       as address_3
  , json:c7::varchar(100)       as address_4
  , json:c8::varchar(100)       as address_5
  , json:c9::varchar(100)       as address_6
  , json:c10::varchar(100)      as city
  , json:c11::varchar(100)      as state
  , json:c12::varchar(50)       as zip_code
  , json:c13::number            as ssn
  , json:c14::varchar(100)      as account_number
  , json:c15::varchar(100)      as advisor_id
  , json:c16::varchar(100)      as taxable
  , json:c17::number            as phone_number
  , json:c18::number            as fax_number
  , json:c19::varchar(100)      as account_type
  , json:c20::varchar(100)      as objective
  , json:c21::varchar(100)      as billing_account_number
  , json:c22::varchar(100)      as default_account
  , json:c23::boolean           as state_of_primary_residence
  , json:c24::date              as performance_inception_date
  , json:c25::date              as billing_inception_date
  , json:c26::varchar(100)      as federal_tax_rate
  , json:c27::varchar(100)      as state_tax_rate
  , json:c28::varchar(100)      as months_in_short_term_holding_period
  , json:c29::varchar(100)      as fiscal_year_end
  , json:c30::decimal(19, 6)    as use_average_cost_accounting
  , json:c31::decimal(19, 6)    as display_accrued_interest
  , json:c32::decimal(19, 6)    as display_accrued_dividends
  , json:c33::decimal(19, 6)    as display_accrued_gains
  , json:c34::date              as birth_date
  , json:c35::double            as discount_rate
  , json:c36::double            as payout_rate
  , rc.firm                     as rep_code_firm
  , effective_date::date        as effective_date
  , _rep_code::varchar(10)      as _rep_code
  , _file_type::varchar(100)    as _file_type
  , _source_file::varchar(100)  as _source_file 
  , _created_at::timestamp      as _created_at
  , {{ col_is_head(reference=source('tda', 'trf')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('tda', 'trf') }} a
left join {{ref('tda_rep_codes')}} rc
  on a._rep_code = rc.rep_code