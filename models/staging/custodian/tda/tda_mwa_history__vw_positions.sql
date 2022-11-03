
select
    value:c1::string         as account_number,
    value:c2::string         as account_type,
    value:c3::string         as security_type,
    value:c4::string         as symbol,
    value:c5::double         as quantity,
    value:c6::decimal(19, 6) as amount,
    effective_date::date     as effective_date,
    file_type::string        as file_type
from {{ source('tda_mwa', 'positions') }}