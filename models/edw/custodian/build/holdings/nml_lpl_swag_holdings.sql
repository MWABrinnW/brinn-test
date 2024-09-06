select
    p.effective_date                             as effective_date
    , p.custodian                                as custodian
    , cf.firm                                    as firm
    , p.firm_source                              as firm_source
    , p.account_number                           as account_number
    , p.account_number                           as account_number_formatted

    , coalesce(s.symbol , p.cusip)::varchar(500) as symbol
    , s.symbol::varchar(500)                     as ticker
    , p.cusip::varchar(500)                      as cusip
    , s.security_description::varchar(500)       as security_name_source

    , case
        when s.security_type_code = 'MM'
            then 1
        else 0
    end::int                                     as is_cash
    , 0::int                                     as is_sweep

    , p.position_value::decimal(15 , 2)          as market_value
    , p.quantity::decimal(20 , 5)                as units_shares
    , p.quantity::decimal(20 , 5)                as quantity
    , null::decimal(20 , 5)                      as quantity_settled
    , null::decimal(20 , 5)                      as quantity_unsettled

    , p.price::decimal(20 , 5)                   as price
    , p.price::decimal(20 , 5)                   as price_unfactored
    , null::decimal(20 , 5)                      as factor

    , null::decimal(20 , 5)                      as cost_basis

    , p.security_id::varchar(500)                as security_id_source

    , null::varchar(500)                         as underlying_ticker
    , null::varchar(500)                         as underlying_cusip
    , null::varchar(500)                         as underlying_security_id_source

    , cmsd.normalized::varchar(500)              as product_type
    , cmsd.definition::varchar(500)              as product_type_source_definition
    , s.security_type_code::varchar(500)         as product_type_source_code

    , null::varchar(500)                         as account_type
    , null::varchar(500)                         as account_type_source
    , null::varchar(500)                         as account_type_source_code

    , null::varchar(500)                         as isin
    , null::varchar(500)                         as sedol

    , null::variant                              as extra_fields

    , p.is_head                                  as is_head
    , p.is_current                               as is_current
    , p._source_loaded_at                        as _source_loaded_at
    , p._source_file                             as _source_file
from {{ ref('lpl_network__base_position') }} as p
left join {{ ref('lpl_network__base_position_securities') }} as s
    on p.effective_date = s.effective_date
    and p.security_id = s.security_id
    and p.subscriber_id = s.subscriber_id
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'product_type'
    and s.security_type_code = cmsd.source
where true
    and p.firm_source = 'swag'
