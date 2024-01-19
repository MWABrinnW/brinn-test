{% set src = source('black_diamond_baystate', 'accounts') %}

select
    'black_diamond'              as pms
    , 'baystate'                 as pms_location
    , 'baystate'                 as firm_source
    , effective_date             as effective_date
    , json:AccountNumber::string as account_number
    , h.value:Name::string       as tag_name
    , h.value:Value::string      as tag_value
    , record_id                  as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime            as _source_loaded_at
from {{ src }} , lateral flatten(input => json:Tags) as h
