select
    r.value:s::string                                           as symbol
  , r.value:st::string                                          as status
  , r.value:copi_symbol::string                                 as copi_symbol
  , r.value:columns.s::string                                   as feed_source_code
  , r.value:columns.pc::number(19, 6)                           as previous_close
  , r.value:columns.op::number(19, 6)                           as open_price
  , r.value:columns.cl::number(19, 6)                           as close_price
  , r.value:columns.l::number(19, 6)                            as last_trade_price
  , r.value:columns.b::number(19, 6)                            as bid_price
  , r.value:columns.a::number(19, 6)                            as ask_price
  , r.value:columns.hi::number(19, 6)                           as high_price
  , r.value:columns.lo::number(19, 6)                           as low_price
  , r.value:columns.dhi::number(19, 6)                          as daily_high_price
  , r.value:columns.dlo::number(19, 6)                          as daily_low_price
  , r.value:columns.yhi::number(19, 6)                          as "52_week_high_price"
  , r.value:columns.ylo::number(19, 6)                          as "52_week_low_price"
  , r.value:columns.pop::number(19, 6)                          as pre_market_open_price
  , r.value:columns.el::number(19, 6)                           as extended_hours_last_price
  , r.value:columns.ecl::number(19, 6)                          as extended_hours_close_price
  , r.value:columns.bex::string                                 as bid_exchange
  , r.value:columns.aex::string                                 as ask_exchange
  , r.value:columns.lex::string                                 as last_trade_exchange
  , r.value:columns.lco                                         as last_trade_conditions
  , r.value:columns.qco                                         as quote_condition
  , r.value:columns.sbtm::timestamp_ntz                         as session_begin_time
  , r.value:columns.setm::timestamp_ntz                         as session_end_time
  , r.value:columns.ltm::timestamp_ntz                          as last_trade_time
  , r.value:columns.qtm::timestamp_ntz                          as quote_time
  , r.value:columns.hitm::timestamp_ntz                         as high_time
  , r.value:columns.lotm::timestamp_ntz                         as low_time
  , r.value:columns.dhitm::timestamp_ntz                        as daily_high_time
  , r.value:columns.dlotm::timestamp_ntz                        as daily_low_time
  , try_to_timestamp(r.value:columns.yhitm::varchar(100))       as "52_week_high_time"
  , try_to_timestamp(r.value:columns.ylotm::varchar(100))       as "52_week_low_time"
  , r.value:columns.lsz::number(19, 6)                          as last_trade_size
  , r.value:columns.bsz::number(19, 6)                          as bid_size
  , r.value:columns.asz::number(19, 6)                          as ask_size
  , r.value:columns.v::number(19, 6)                            as volume
  , r.value:columns.pv::number(19, 6)                           as pre_market_volume
  , r.value:columns.ev::number(19, 6)                           as extended_hours_volumne
  , r.value:columns.tc::number(19, 6)                           as trade_count
  , r.value:columns.ptc::number(19, 6)                          as pre_market_trade_count
  , r.value:columns.etc::number(19, 6)                          as extended_hours_trade_count
  , r.value:columns.tsum::number(19, 6)                         as transactions_sum
  , r.value:columns.vwap::number(19, 6)                         as vwap
  , try_to_number(r.value:columns.opoi::varchar(100), 19, 6)    as option_open_interest
  , try_to_number(r.value:columns.opnpv::varchar(100), 19, 6)   as option_theoretical_calculated_price
  , try_to_number(r.value:columns.opdelta::varchar(100), 19, 6) as option_greek_delta
  , try_to_number(r.value:columns.opgamma::varchar(100), 19, 6) as option_greek_gamma
  , try_to_number(r.value:columns.oprho::varchar(100), 19, 6)   as option_greek_rho
  , try_to_number(r.value:columns.opvega::varchar(100), 19, 6)  as option_greek_vega
  , try_to_number(r.value:columns.optheta::varchar(100), 19, 6) as option_greek_theta
  , try_to_number(r.value:columns.opiv::varchar(100), 19, 6)    as option_implied_volatility
  , try_to_number(r.value:columns.av5::varchar(100), 19, 6)     as "5_day_avg_volume"
  , try_to_number(r.value:columns.av10::varchar(100), 19, 6)    as "10_day_avg_volume"
  , try_to_number(r.value:columns.av20::varchar(100), 19, 6)    as "20_day_avg_volume"
  , try_to_number(r.value:columns.av50::varchar(100), 19, 6)    as "50_day_avg_volume"
  , try_to_number(r.value:columns.av100::varchar(100), 19, 6)   as "100_day_avg_volume"
  , try_to_number(r.value:columns.av200::varchar(100), 19, 6)   as "200_day_avg_volume"
  , try_to_number(r.value:columns.ap5::varchar(100), 19, 6)     as "5_day_avg_price"
  , try_to_number(r.value:columns.ap10::varchar(100), 19, 6)    as "10_day_avg_price"
  , try_to_number(r.value:columns.ap20::varchar(100), 19, 6)    as "20_day_avg_price"
  , try_to_number(r.value:columns.ap50::varchar(100), 19, 6)    as "50_day_avg_price"
  , try_to_number(r.value:columns.ap100::varchar(100), 19, 6)   as "100_day_avg_price"
  , try_to_number(r.value:columns.ap200::varchar(100), 19, 6)   as "200_day_avg_price"
  , r.value:columns.divtype::string                             as dividend_type
  , try_to_number(r.value:columns.divamt::varchar(100), 19, 6)  as dividend_amount
  , try_to_date(r.value:columns.divdecldt::varchar(100))        as dividend_declared_date
  , try_to_date(r.value:columns.divexdt::varchar(100))          as dividend_ex_date
  , try_to_date(r.value:columns.divrecdt::varchar(100))         as dividend_record_date
  , try_to_date(r.value:columns.divpaydt::varchar(100))         as dividend_payable_date
  , r.value:columns.sd::string                                  as company_short_description
  , r.value:columns.ld::string                                  as company_long_description
  , r.value:columns.sic::string                                 as stock_sic_code
  , r.value:columns.sok::string                                 as stock_sik_code
  , r.value:columns.pex::string                                 as stock_primary_exchange
  , {{ col_is_head(reference=source('activetick', 'activetick_prices'), source_date_col='p.record_datetime', reference_date_col='record_datetime') }}
  , p.record_date
  , p.record_datetime
from {{ source('activetick', 'activetick_prices') }}      p
   , lateral flatten(input => p.variant_data, path => '') o
   , lateral flatten(input => o.value, path => 'rows')    r