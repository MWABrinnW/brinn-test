{% set src = source('black_diamond_houston', 'accounts') %}

select 
  'black_diamond'                            as pms
  , 'houston'                                    as pms_location
  , 'mwa'                                    as firm_source
  , EFFECTIVE_DATE as effective_date
  , JSON:AccountNumber::string as account_number
  , H.VALUE: Name::string as tag_name
  , H.value: Value::String as tag_value
  , RECORD_ID as record_id
  , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime as _source_loaded_at
from {{ src }}, lateral flatten(input => JSON:Tags) H
