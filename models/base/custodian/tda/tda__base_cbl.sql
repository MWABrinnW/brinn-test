select
    json:c1::varchar(100)      as custodial_id
  , json:c2::date              as business_date
  , json:c3::varchar(100)      as account_number
  , json:c4::varchar(100)      as account_type
  , json:c5::varchar(100)      as security_type
  , json:c6::varchar(100)      as symbol
  , json:c7::double            as current_quantity
  , json:c8::decimal(19, 6)    as cost_basis
  , json:c9::decimal(19, 6)    as adjusted_cost_basis
  , json:c10::decimal(19, 6)   as unrealized_gain_loss
  , json:c11::boolean          as cost_basis_fully_known
  , json:c12::varchar(100)     as certified_flag
  , json:c13::date             as original_purchase_date
  , json:c14::decimal(19, 6)   as original_purchase_price
  , json:c15::varchar(100)     as wash_sale_indicator
  , json:c16::decimal(19, 6)   as disallowed_amount
  , json:c17::varchar(100)     as averaged_cost
  , json:c18::decimal(19, 6)   as book_cost
  , json:c19::varchar(100)     as book_proceeds
  , json:c20::decimal(19, 6)   as fixed_income_cost_adjustment
  , json:c21::varchar(100)     as id
  , json:c22::varchar(100)     as security_name
  , json:c23::varchar(100)     as covered
  , json:c24::varchar(100)     as unknown_total
  , rc.firm                    as rep_code_firm
  , rc.status                  as rep_code_status
  , rc.description             as rep_code_description
  , effective_date::date       as effective_date
  , _rep_code::varchar(10)     as _rep_code
  , _file_type::varchar(100)   as _file_type
  , _source_file::varchar(100) as _source_file 
  , _created_at::timestamp     as _created_at
  , {{ col_is_head(reference=source('tda', 'cbl')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('tda', 'cbl') }} a
left join {{ref('tda__rep_codes')}} rc
  on a._rep_code = rc.rep_code