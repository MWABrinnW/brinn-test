select
    _data:portfolio_id::text                                                            as portfolio_id
    , replace(replace(trim(_data:portfolio_id::text) , '-' , '') , ' ' , '')            as account_number
    , _data:portfolio_name::text                                                        as portfolio_name
    , _data:port_mgmt_style::text                                                       as port_mgmt_style
    , _data:port_tag::text                                                              as port_tag
    , _data:port_custodian::text                                                        as port_custodian
    , _data:enable_inquiries_system::text                                               as enable_inquiries_system
    , _data:portfolio_state::text                                                       as portfolio_state
    , _data:portfolio_type::text                                                        as portfolio_type
    , _data:nobuys::text                                                                as nobuys
    , replace(replace(trim(_data:mincash::text) , '$' , '') , ',' , '')::number(19 , 3) as mincash
    , _data:port_total_cash::number(19 , 3)                                             as port_total_cash
    , _data:"port_market_value_+_accrued"::number(19 , 3)                               as port_market_value_accrued
    , _data:cashper::number(19 , 3)                                                     as cash_percentage
    , _data:port_avg_effective_dur::number(19 , 3)                                      as port_avg_effective_dur
    , _data:port_avg_maturity::date                                                     as port_avg_maturity
    , _data:port_avg_life_date::date                                                    as port_avg_life_date
    , _data:port_net_income::number(19 , 3)                                             as port_net_income
    , _data:port_coupon_income::number(19 , 3)                                          as port_coupon_income
    , _data:port_acq_yld::number(19 , 3)                                                as port_acq_yld
    , _data:port_book_yld::number(19 , 3)                                               as port_book_yld
    , _data:port_avg_yield::number(19 , 3)                                              as port_avg_yield
    , _data:port_mtd_total_return::number(19 , 3)                                       as port_mtd_total_return
    , _data:financial_advisor::text                                                     as financial_advisor
    , _data:port_status::text                                                           as port_status
    , _data:port_status_dt::date                                                        as port_status_dt
    , _data:created_dt::date                                                            as created_dt
    , _data:secondary_portfolio_id::date                                                as secondary_portfolio_id
    , _data:last_mod_date::date                                                         as last_mod_date
    , _data:port_inception_dt::date                                                     as port_inception_dt
    , _data:performance_start_dt::date                                                  as performance_start_dt
    , _data:open_date::date                                                             as open_date
    , _data:creation_date::date                                                         as creation_date
    , _created_at::timestamp_ntz                                                        as _created_at
    , {{ col_is_head(
        reference=source('perform', 'accounts'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz'
        ) }}
    , _id                                                                               as _id
from {{ source('perform', 'accounts') }}
