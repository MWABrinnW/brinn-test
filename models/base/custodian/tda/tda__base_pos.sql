select
    'tda'                      as custodian
  , json:c1::varchar(100)      as account_number
  , json:c2::varchar(100)      as account_type
  , json:c3::varchar(100)      as security_type
  , json:c4::varchar(100)      as symbol
  , json:c5::double            as quantity
  , json:c6::decimal(19, 6)    as amount
  , rc.firm                    as rep_code_firm
  , rc.firm                    as firm_source
  , cf.firm                    as firm
  , effective_date::date       as effective_date
  , _rep_code::varchar(10)     as _rep_code
  , _file_type::varchar(100)   as _file_type
  , _source_file::varchar(100) as _source_file 
  , _created_at::timestamp     as _source_loaded_at
  , {{ col_is_head(reference=source('tda', 'pos')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('tda', 'pos') }} a
left join {{ ref('tda_rep_codes') }} rc
  on a._rep_code = rc.rep_code
left join {{ ref('custodian_firms') }} cf
  on rc.firm = cf.firm_source