
select
    value:c1::string         as symbol,
    value:c2::string         as security_type,
    value:c3::string         as description,
    value:c4::date           as exp_date,
    value:c5::date           as call_date,
    value:c6::decimal(19, 6) as call_price,
    value:c7::date           as issue_date,
    value:c8::string         as first_coupon,
    value:c9::double         as interest_rate,
    value:c10::double        as share_per_contract,
    value:c11::double        as annual_income_amount,
    value:c12::string        as comment,
    effective_date::date     as effective_date,
    file_type::string        as file_type
from {{ source('tda_mwa', 'securities') }}