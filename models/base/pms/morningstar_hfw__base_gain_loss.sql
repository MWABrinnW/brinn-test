select
    effective_at::date                                      as effective_date
    ,advisor_name                                           as advisor_name
    ,client_name                                            as client_name
    ,account_name                                           as account_name
    ,account_number                                         as account_number
    ,security_name                                          as security_name
    ,symbol_cusip                                           as symbol_cusip
    ,acquisition_date                                       as acquisition_date
    ,short_term_unrealized_g_l::decimal(15,2)               as short_term_unrealized_gl
    ,long_term_unrealized_g_l::decimal(15,2)                as long_term_unrealized_gl
    ,percent_g_l::decimal(10,6) * .01                       as gl_percent
    ,unit_cost::decimal(17,8)                               as unit_cost
    ,price::decimal(11,2)                                   as price
    ,quantity::decimal(15,2)                                as quantity
    ,market_value::decimal(15,2)                            as market_value
    ,percent_of_asset_percent::decimal(9,6) * .01           as percent_of_asset_percent
    ,{{ col_is_head(reference=source('morningstar_hfw', 'gain_loss'), reference_date_col='effective_at', source_date_col='effective_at') }}
    ,{{ col_is_current(date_col='effective_at') }}
    ,effective_at
    ,_created_at
    ,_source_file
from {{ source('morningstar_hfw', 'gain_loss') }}
