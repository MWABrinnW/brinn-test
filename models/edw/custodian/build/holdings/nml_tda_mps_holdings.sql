select
      p.effective_date                          as effective_date
    , p.custodian                               as custodian
    , cf.firm                                   as firm
    , p.firm_source                             as firm_source
    , p.account_number                          as account_number
    , p.account_number                          as account_number_formatted
    , null::varchar(100)                        as cusip
    , p.symbol::varchar(100)                    as ticker
    , case
        when p.symbol in ('Cash')
            then 1
        else 0
        end::int                                as is_cash
    , 0::int                                    as is_sweep
    , null::varchar(200)                        as source_security_name
    , p.market_value::decimal(15,2)             as market_value
    , p.quantity::decimal(19,9)                 as units_shares
    , p.price::decimal(19,9)                    as price
    , p.price_unfactored::decimal(19,9)         as price_unfactored
    , p.factor::decimal(19,9)                   as factor
    , cb.avg_cost_basis::decimal(19,9)          as cost_basis
    , cmsd.normalized                           as security_type
    , cmsd.definition                           as source_security_type
    , p.security_type                           as source_security_type_code
    , null::varchar(100)                        as account_type
    , null::varchar(100)                        as source_account_type
    , p.account_type::varchar(100)              as source_account_type_code
    , p.is_head                                 as is_head
    , p.is_current                              as is_current
    , p._source_loaded_at                       as _source_loaded_at
    , p._source_file                            as _source_file
from {{ ref('tda__int_positions') }} p
left join {{ ref('tda__int_cost_basis_aggregated') }} cb
    on p.effective_date = cb.effective_date
    and p._rep_code = cb._rep_code
    and p.account_number = cb.account_number
    and p.symbol = cb.symbol
left join {{ ref('custodian_firms') }} cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }}                 cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'security_type_description'
    and p.security_type = cmsd.source
where true
    and p.firm_source = 'mps'
qualify row_number() over(partition by p.effective_date, p.account_number, p.symbol order by p._source_loaded_at) = 1
