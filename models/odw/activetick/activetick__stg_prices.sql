select
    a.variant_data:symbol::text(200)                          as ticker
    , a.variant_data:at_symbol::text(200)                     as activetick_symbol
    , a.variant_data:option_type::text(200)                   as option_type
    , a.variant_data:strike_price::decimal(20,2)              as strike_price
    , a.variant_data:underlying::text(200)                    as underlying_ticker
    , nullif(a.variant_data:l , 'NaN')::decimal(18 , 2)       as last_price
    , nullif(a.variant_data:pc , 'NaN')::decimal(18 , 2)      as prev_close_price
    , nullif(a.variant_data:op , 'NaN')::decimal(18 , 2)      as open_price
    , nullif(a.variant_data:cl , 'NaN')::decimal(18 , 2)      as close_price
    , nullif(a.variant_data:b , 'NaN')::decimal(18 , 2)       as bid_price
    , nullif(a.variant_data:a , 'NaN')::decimal(18 , 2)       as ask_price
    , nullif(a.variant_data:hi , 'NaN')::decimal(18 , 2)      as high_price
    , nullif(a.variant_data:lo , 'NaN')::decimal(18 , 2)      as low_price
    , nullif(a.variant_data:st , 'NaN')::text(200)            as status
    , nullif(a.variant_data:s , 'NaN')::text(200)             as feed_source_code
    , nullif(a.variant_data:s , 'NaN')::text(200)             as feed_source_code
    , nullif(a.variant_data:dhi , 'NaN')::number(18 , 2)      as daily_high_price
    , nullif(a.variant_data:dlo , 'NaN')::number(18 , 2)      as daily_low_price
    , nullif(a.variant_data:pop , 'NaN')::number(18 , 2)      as pre_market_open_price
    , nullif(a.variant_data:el , 'NaN')::number(18 , 2)       as extended_hours_last_price
    , nullif(a.variant_data:ecl , 'NaN')::number(18 , 2)      as extended_hours_close_price
    , nullif(a.variant_data:bex , 'NaN')::text(200)           as bid_exchange
    , nullif(a.variant_data:aex , 'NaN')::text(200)           as ask_exchange
    , nullif(a.variant_data:lex , 'NaN')::text(200)           as last_trade_exchange
    , nullif(a.variant_data:lco , 'NaN')::text(200)           as last_trade_conditions
    , nullif(a.variant_data:qco , 'NaN')::text(200)           as quote_condition
    , nullif(a.variant_data:sbtm , 'NaN')::timestamp_ntz      as session_begin_time
    , nullif(a.variant_data:setm , 'NaN')::timestamp_ntz      as session_end_time
    , nullif(a.variant_data:ltm , 'NaN')::timestamp_ntz       as last_trade_time
    , nullif(a.variant_data:qtm , 'NaN')::timestamp_ntz       as quote_time
    , nullif(a.variant_data:hitm , 'NaN')::timestamp_ntz      as high_time
    , nullif(a.variant_data:lotm , 'NaN')::timestamp_ntz      as low_time
    , nullif(a.variant_data:dhitm , 'NaN')::timestamp_ntz     as daily_high_time
    , nullif(a.variant_data:dlotm , 'NaN')::timestamp_ntz     as daily_low_time
    , nullif(a.variant_data:yhi , 'NaN')::decimal(18 , 2)     as fifty_two_week_high_price
    , nullif(a.variant_data:ylo , 'NaN')::decimal(18 , 2)     as fifty_two_week_low_price
    , nullif(a.variant_data:yhitm , 'NaN')::varchar(100)      as fifty_two_week_high_time
    , nullif(a.variant_data:ylotm , 'NaN')::varchar(100)      as fifty_two_week_low_time
    , nullif(a.variant_data:lsz , 'NaN')::number(18 , 2)      as last_trade_size
    , nullif(a.variant_data:bsz , 'NaN')::number(18 , 2)      as bid_size
    , nullif(a.variant_data:asz , 'NaN')::number(18 , 2)      as ask_size
    , nullif(a.variant_data:v , 'NaN')::number(18 , 2)        as volume
    , nullif(a.variant_data:pv , 'NaN')::number(18 , 2)       as pre_market_volume
    , nullif(a.variant_data:ev , 'NaN')::number(18 , 2)       as extended_hours_volumne
    , nullif(a.variant_data:tc , 'NaN')::number(18 , 2)       as trade_count
    , nullif(a.variant_data:ptc , 'NaN')::number(18 , 2)      as pre_market_trade_count
    , nullif(a.variant_data:etc , 'NaN')::number(18 , 2)      as extended_hours_trade_count
    , nullif(a.variant_data:tsum , 'NaN')::number(18 , 2)     as transactions_sum
    , nullif(a.variant_data:vwap , 'NaN')::number(18 , 2)     as vwap
    , nullif(a.variant_data:opoi , 'NaN')::decimal(18 , 2)    as option_open_interest
    , nullif(a.variant_data:opnpv , 'NaN')::decimal(18 , 2)   as option_theoretical_calculated_price
    , nullif(a.variant_data:opdelta , 'NaN')::decimal(18 , 2) as option_greek_delta
    , nullif(a.variant_data:opgamma , 'NaN')::decimal(18 , 2) as option_greek_gamma
    , nullif(a.variant_data:oprho , 'NaN')::decimal(18 , 2)   as option_greek_rho
    , nullif(a.variant_data:opvega , 'NaN')::decimal(18 , 2)  as option_greek_vega
    , nullif(a.variant_data:optheta , 'NaN')::decimal(18 , 2) as option_greek_theta
    , nullif(a.variant_data:opiv , 'NaN')::decimal(18 , 2)    as option_implied_volatility
    , nullif(a.variant_data:av5 , 'NaN')::decimal(18 , 2)     as five_day_avg_volume
    , nullif(a.variant_data:av10 , 'NaN')::decimal(18 , 2)    as ten_day_avg_volume
    , nullif(a.variant_data:av20 , 'NaN')::decimal(18 , 2)    as twenty_day_avg_volume
    , nullif(a.variant_data:av50 , 'NaN')::decimal(18 , 2)    as fifty_day_avg_volume
    , nullif(a.variant_data:av100 , 'NaN')::decimal(18 , 2)   as one_hundred_day_avg_volume
    , nullif(a.variant_data:av200 , 'NaN')::decimal(18 , 2)   as two_hundred_day_avg_volume
    , nullif(a.variant_data:ap5 , 'NaN')::decimal(18 , 2)     as five_day_avg_price
    , nullif(a.variant_data:ap10 , 'NaN')::decimal(18 , 2)    as ten_day_avg_price
    , nullif(a.variant_data:ap20 , 'NaN')::decimal(18 , 2)    as twenty_day_avg_price
    , nullif(a.variant_data:ap50 , 'NaN')::decimal(18 , 2)    as fifty_day_avg_price
    , nullif(a.variant_data:ap100 , 'NaN')::decimal(18 , 2)   as one_hundred_day_avg_price
    , nullif(a.variant_data:ap200 , 'NaN')::decimal(18 , 2)   as two_hundred_day_avg_price
    , nullif(a.variant_data:divamt , 'NaN')::decimal(18 , 2)  as dividend_amount
    , nullif(a.variant_data:divdecldt , 'NaN')::date          as dividend_declared_date
    , nullif(a.variant_data:divexdt , 'NaN')::date            as dividend_ex_date
    , nullif(a.variant_data:divrecdt , 'NaN')::date           as dividend_record_date
    , nullif(a.variant_data:divpaydt , 'NaN')::date           as dividend_payable_date
    , nullif(a.variant_data:divtype , 'NaN')::text(200)       as dividend_type
    , nullif(a.variant_data:sd , 'NaN')::text(200)            as company_short_description
    , nullif(a.variant_data:ld , 'NaN')::text(200)            as company_long_description
    , nullif(a.variant_data:sic , 'NaN')::text(200)           as stock_sic_code
    , nullif(a.variant_data:sok , 'NaN')::text(200)           as stock_sik_code
    , nullif(a.variant_data:pex , 'NaN')::text(200)           as stock_primary_exchange
    , a._created_at::timestamp                                as _created_at
from {{ source('activetick', 'snapshots') }} as a
