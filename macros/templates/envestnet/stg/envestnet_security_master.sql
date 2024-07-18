{%- macro envestnet_security_master(src) -%}
select
    'envestnet'                                       as system_name
    , {{ "'" ~ src ~ "'" }}                                              as system_instance
    , concat(system_name , '__' , system_instance)    as system_key
    , {{ envestnet_instance_map(src) }}                                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::int              as security_id
    , nullif(split_part(content , '|' , 2), '')::varchar(22)      as cusip
    , nullif(split_part(content , '|' , 3), '')::varchar(22)      as ticker
    , nullif(split_part(content , '|' , 4), '')::varchar(210)     as security_description
    , nullif(split_part(content , '|' , 5), '')::varchar(4)       as security_type
    , nullif(split_part(content , '|' , 6), '')::int              as security_style
    , nullif(split_part(content , '|' , 7), '')::decimal(18 , 4)  as issue_type_multiplier
    , nullif(split_part(content , '|' , 8), '')::decimal(18 , 7)  as agency_factor
    , nullif(split_part(content , '|' , 9), '')::varchar(50)     as share_class
    , nullif(split_part(content , '|' , 10), '')::char(1)         as cdsc_fund_flag
    , nullif(split_part(content , '|' , 11), '')::int             as fund_family_id
    , nullif(split_part(content , '|' , 12), '')::char(1)         as closed_flag
    , nullif(split_part(content , '|' , 13), '')::int             as sp_rating_id
    , nullif(split_part(content , '|' , 14), '')::int             as moody_rating_id
    , nullif(split_part(content , '|' , 15), '')::int         as firm_eligible
    , nullif(split_part(content , '|' , 16), '')::date            as issue_date
    , nullif(split_part(content , '|' , 17), '')::date            as maturity_date
    , nullif(split_part(content , '|' , 18), '')::date            as call_date
    , nullif(split_part(content , '|' , 19), '')::decimal(18 , 6) as call_price
    , nullif(split_part(content , '|' , 20), '')::int         as sector_id
    , nullif(split_part(content , '|' , 21), '')::int         as sub_sector_id
    , nullif(split_part(content , '|' , 22), '')::date            as last_modified_date
    , nullif(split_part(content , '|' , 23), '')::decimal(18 , 4) as interest_rate
    , nullif(split_part(content , '|' , 24), '')::varchar(25)     as accrual_method
    , nullif(split_part(content , '|' , 25), '')::varchar(2)      as state_taxable
    , nullif(split_part(content , '|' , 26), '')::char(1)         as federal_taxable
    , nullif(split_part(content , '|' , 27), '')::int             as exchange_id
    , nullif(split_part(content , '|' , 28), '')::varchar(3)      as trade_currency
    , nullif(split_part(content , '|' , 29), '')::int             as coupon_frequency
    , nullif(split_part(content , '|' , 30), '')::varchar(12)     as isin
    , nullif(split_part(content , '|' , 31), '')::varchar(7)      as sedol
    , nullif(split_part(content , '|' , 32), '')::date            as first_coupon_date
    , nullif(split_part(content , '|' , 33), '')::date            as last_coupon_date
    , nullif(split_part(content , '|' , 34), '')::int             as minimum_purchase
    , nullif(split_part(content , '|' , 35), '')::varchar(3)      as income_currency
    , nullif(split_part(content , '|' , 36), '')::char(1)         as dummy_flag
    , nullif(split_part(content , '|' , 37), '')::varchar(16)     as valor_number
    , nullif(split_part(content , '|' , 38), '')::varchar(256)    as issuer_name
    , nullif(split_part(content , '|' , 39), '')::varchar(10)     as fund_code
    , nullif(split_part(content , '|' , 40), '')::varchar(10)     as broadridge_sec_number
    , nullif(split_part(content , '|' , 41), '')::varchar(12)     as status_code
    , nullif(split_part(content , '|' , 42), '')::int             as product_type_id
    , nullif(split_part(content , '|' , 43), '')::date            as created_date
    , nullif(split_part(content , '|' , 44), '')::int             as gics_industry_group_id
    , nullif(split_part(content , '|' , 45), '')::int             as gics_industry_id
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'securitymaster')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                     as _created_at
    , _source_file                                    as _source_file
from {{ source('envestnet_' + src, 'securitymaster') }}
where split_part(content , '|' , 1) not in ('H', 'T') --ignore header and tail records
{%- endmacro -%}
