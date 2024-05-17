{% set src = source('black_diamond_mps', 'accounts') %}

select
    'black_diamond'                                as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mps'                                        as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , h.value:Name::string                         as tag_name
    , h.value:Value::string                        as tag_value
    , a.record_id                                  as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , a.record_datetime                            as _source_loaded_at
from {{ src }} as a
, lateral flatten(input => a.json:Tags) as h
