select
    p.effective_date                      as effective_date
    , p.custodian                         as custodian
    , cf.firm                             as firm
    , p.firm_source                       as firm_source
    , p.account_number                    as account_number
    , p.account_number                    as account_number_formatted

    , p.symbol::varchar(500)              as symbol
    , p.symbol::varchar(500)              as ticker
    , null::varchar(500)                  as cusip
    , null::varchar(500)                  as security_name_source

    , case
        when p.symbol in ('Cash')
            then 1
        else 0
    end::int                              as is_cash
    , 0::int                              as is_sweep

    , p.market_value::decimal(15 , 2)     as market_value
    , p.quantity::decimal(20 , 5)         as units_shares
    , p.quantity::decimal(20 , 5)         as quantity
    , null::decimal(20 , 5)               as quantity_settled
    , null::decimal(20 , 5)               as quantity_unsettled

    , p.price::decimal(20 , 5)            as price
    , p.price_unfactored::decimal(20 , 5) as price_unfactored
    , p.factor::decimal(20 , 5)           as factor

    , cb.avg_cost_basis::decimal(20 , 5)  as cost_basis

    , null::varchar(500)                  as security_id_source

    , null::varchar(500)                  as underlying_ticker
    , null::varchar(500)                  as underlying_cusip
    , null::varchar(500)                  as underlying_security_id_source

    , cmsd.normalized::varchar(500)       as product_type
    , cmsd.definition::varchar(500)       as product_type_source
    , p.security_type::varchar(500)       as product_type_source_code

    , null::varchar(500)                  as account_type
    , null::varchar(500)                  as account_type_source
    , p.account_type::varchar(500)        as account_type_source_code

    , null::varchar(500)                  as isin
    , null::varchar(500)                  as sedol

    , null::variant                       as extra_fields

    , p.is_head                           as is_head
    , p.is_current                        as is_current
    , p._source_loaded_at                 as _source_loaded_at
    , p._source_file                      as _source_file
from {{ ref('tda__int_positions') }} as p
left join {{ ref('tda__int_cost_basis_aggregated') }} as cb
    on p.effective_date = cb.effective_date
    and p._rep_code = cb._rep_code
    and p.account_number = cb.account_number
    and p.symbol = cb.symbol
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'product_type'
    and p.security_type = cmsd.source
where true
    and p.firm_source = 'mps'
qualify row_number() over (partition by p.effective_date , p.account_number , p.symbol order by p._source_loaded_at) = 1
