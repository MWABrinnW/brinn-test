select
    portfolio_id::text                                                      as portfolio_id
    , replace(replace(trim(portfolio_id) , '-' , '') , ' ' , '')            as account_number
    , portfolio_name::text                                                  as portfolio_name
    , port_mgmt_style::text                                                 as port_mgmt_style
    , port_tag::text                                                        as port_tag
    , port_custodian::text                                                  as port_custodian
    , enable_inquiries_system::text                                         as enable_inquiries_system
    , portfolio_state::text                                                 as portfolio_state
    , portfolio_type::text                                                  as portfolio_type
    , nobuys::text                                                          as nobuys
    , replace(replace(trim(mincash) , '$' , '') , ',' , '')::number(19 , 3) as mincash
    , port_total_cash::number(19 , 3)                                       as port_total_cash
    , port_market_value_accrued::number(19 , 3)                             as port_market_value_accrued
    , cash_percentage::number(19 , 3)                                       as cash_percentage
    , port_avg_effective_dur::number(19 , 3)                                as port_avg_effective_dur
    , port_avg_maturity::date                                               as port_avg_maturity
    , port_avg_life_date::date                                              as port_avg_life_date
    , port_net_income::number(19 , 3)                                       as port_net_income
    , port_coupon_income::number(19 , 3)                                    as port_coupon_income
    , port_acq_yld::number(19 , 3)                                          as port_acq_yld
    , port_book_yld::number(19 , 3)                                         as port_book_yld
    , port_avg_yield::number(19 , 3)                                        as port_avg_yield
    , port_mtd_total_return::number(19 , 3)                                 as port_mtd_total_return
    , financial_advisor::text                                               as financial_advisor
    , port_status::text                                                     as port_status
    , port_status_dt::date                                                  as port_status_dt
    , _created_at::timestamp_ntz                                            as _created_at
    , {{ col_is_head(reference=source('perform', 'accounts'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz') }}
from {{ source('perform', 'accounts') }}
