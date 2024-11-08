{% set src = source('emoney_mwa', 'assumptions') %}
select
    _data:"type"::text(200)                      as type
    , _data:"name"::text(200)                    as name
    , _data:"clientbenefitcalcmethod"::text(200) as client_benefit_calc_method
    , _data:"clientid"::text(200)                as client_id
    , _data:"accountid"::text(200)               as account_id
    , _data:"spousebenefitcalcmethod"::text(200) as spouse_benefit_calc_method
    , _data:"facttypename"::text(200)            as fact_type_name

    , effective_date::date                       as effective_date
    , _created_at::timestamp                     as _created_at
    , _source_file::text(200)                    as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
