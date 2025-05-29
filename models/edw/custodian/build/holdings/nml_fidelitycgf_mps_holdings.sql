select
    p.effective_date                                                 as effective_date
    , p.custodian                                                    as custodian
    , cf.firm                                                        as firm
    , p.firm_source                                                  as firm_source
    , p.cgf_account_number                                           as account_number
    , p.cgf_account_number                                           as account_number_formatted

    , coalesce(p.symbol_pool_identifier , price.cusip)::varchar(500) as symbol
    , p.symbol_pool_identifier::varchar(500)                         as ticker
    , price.cusip::varchar(500)                                      as cusip
    , price.fund_name::varchar(500)                                  as security_name_source

    , case
        when price.fund_name = 'Money Market'
            then 1
        else 0
    end::int                                                         as is_cash
    , 0::int                                                         as is_sweep

    , p.market_value::decimal(15 , 2)                                as market_value
    , p.units_value::decimal(20 , 5)                                 as units_shares
    , p.units_value::decimal(20 , 5)                                 as quantity
    , null::decimal(20 , 5)                                          as quantity_settled
    , null::decimal(20 , 5)                                          as quantity_unsettled

    , coalesce(price.close_price , p.price::decimal(20 , 5))         as price
    , coalesce(price.close_price , p.price::decimal(20 , 5))         as price_unfactored
    , null::decimal(20 , 5)                                          as factor

    , null::decimal(20 , 5)                                          as cost_basis

    , null::varchar(500)                                             as security_id_source
    , null::varchar(500)                                             as underlying_ticker
    , null::varchar(500)                                             as underlying_cusip
    , null::varchar(500)                                             as underlying_security_id_source

    , cmsd.normalized::varchar(500)                                  as product_type
    , cmsd.definition::varchar(500)                                  as product_type_source_definition
    , p.security_type::varchar(500)                                  as product_type_source_code

    , 'Charitable Gift Fund'::varchar(500)                           as account_type
    , 'Charitable Gift Fund'::varchar(500)                           as account_type_source
    , 'cgf'::varchar(500)                                            as account_type_source_code

    , null::varchar(500)                                             as isin
    , null::varchar(500)                                             as sedol

    , null::variant                                                  as extra_fields

    , p._source_loaded_at                                            as _created_at
    , p._source_loaded_at                                            as _source_loaded_at
    , p._source_file                                                 as _source_file
    , p.is_head                                                      as is_head
from {{ ref('fidelity_mps_history__vw_cgf_pos') }} as p
left join {{ ref('fidelity_mps_history__vw_cgf_prc') }} as price
    on p.effective_date = price.effective_date
    and p.symbol_pool_identifier = price.symbol
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'product_type'
    and p.security_type = cmsd.source
where true
