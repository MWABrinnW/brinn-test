SELECT 
    json:c1::varchar(100)      as symbol
  , json:c2::varchar(100)      as security_type
  , json:c3::date              as date
  , json:c4::decimal(19,6)     as price
  , json:c5::varchar(100)      as factor
  , rc.firm                    as rep_code_firm
  , rc.status                  as rep_code_status
  , rc.description             as rep_code_description
  , effective_date::date       as effective_date
  , _rep_code::varchar(10)     as _rep_code
  , _file_type::varchar(100)   as _file_type
  , _source_file::varchar(100) as _source_file 
  , _created_at::timestamp     as _created_at
  , {{ col_is_head(reference=source('tda', 'pri')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('tda', 'pri') }} a
left join {{ref('tda__rep_codes')}} rc
  on a._rep_code = rc.rep_code