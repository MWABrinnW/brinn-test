select
    json:c1::varchar(100)      as symbol
  , json:c2::varchar(100)      as security_type
  , json:c3::varchar(100)      as description
  , json:c4::date              as exp_date
  , json:c5::date              as call_date
  , json:c6::decimal(19, 6)    as call_price
  , json:c7::date              as issue_date
  , json:c8::varchar(100)      as first_coupon
  , json:c9::double            as interest_rate
  , json:c10::double           as share_per_contract
  , json:c11::double           as annual_income_amount
  , json:c12::varchar(100)     as comment
  , rc.firm                    as rep_code_firm
  , rc.status                  as rep_code_status
  , rc.description             as rep_code_description
  , effective_date::date       as effective_date
  , _rep_code::varchar(10)     as _rep_code
  , _file_type::varchar(100)   as _file_type
  , _source_file::varchar(100) as _source_file 
  , _created_at::timestamp     as _created_at
  , {{ col_is_head(reference=source('tda', 'sec')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('tda', 'sec') }} a
left join {{ref('tda__rep_codes')}} rc
  on a._rep_code = rc.rep_code