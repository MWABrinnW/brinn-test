select
      p.effective_date                     as effective_date
    , p.custodian                          as custodian
    , cf.firm                              as firm
    , p.firm_source                        as firm_source
    , p.cgf_account_number                 as account_number
    , p.cgf_account_number                 as account_number_formatted
    , price.cusip                          as cusip
    , p.symbol_pool_identifier             as ticker
    , case
        when price.fund_name = 'Money Market'
            then 1
        else 0
        end::int                           as is_cash
    , 0::int                               as is_sweep
    , price.fund_name::varchar(200)        as source_security_name
    , market_value::decimal(15, 2)         as market_value
    , units_value::decimal(19, 9)          as units_shares
    , coalesce(price.close_price, p.price::decimal(19, 9))  as price
    , coalesce(price.close_price, p.price::decimal(19, 9))  as price_unfactored
    , null::decimal(19, 9)                 as factor    
    , null::decimal(19, 9)                 as cost_basis
    , cmsd.normalized                      as security_type
    , cmsd.definition                      as source_security_type
    , p.security_type                      as source_security_type_code
    , 'Charitable Gift Fund'::varchar(100) as account_type
    , 'Charitable Gift Fund'::varchar(100) as source_account_type
    , 'cgf'::varchar(100)                  as source_account_type_code
    , p.is_head                            as is_head
    , p.is_current                         as is_current
    , p._source_loaded_at                  as _source_loaded_at
    , p._source_file                       as _source_file
from {{ ref('fidelity_mps_history__vw_cgf_pos') }} as p
left join {{ ref('fidelity_mps_history__vw_cgf_prc') }} price
    on p.effective_date = price.effective_date
    and p.symbol_pool_identifier = price.symbol
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'security_type_description'
    and p.security_type = cmsd.source
where true
