select
    p.effective_date                                                                       as effective_date
    , p.custodian                                                                          as custodian
    , cf.firm                                                                              as firm
    , p.firm_source                                                                        as firm_source
    , p.account_number                                                                     as account_number
    , p.account_number                                                                     as account_number_formatted

    , coalesce(nullif(p.security_symbol , '') , nullif(p.cusip_number , ''))::varchar(500) as symbol
    , nullif(p.security_symbol , '')::varchar(500)                                         as ticker
    , nullif(p.cusip_number , '')::varchar(500)                                            as cusip
    , rtrim(ltrim(regexp_replace(concat_ws(
        ' '
        , coalesce(sec.security_description_line_1 , '')
        , coalesce(sec.security_description_line_2 , '')
        , coalesce(sec.security_description_line_3 , '')
        , coalesce(sec.security_description_line_4 , '')
        , coalesce(sec.security_description_line_5 , '')
    )
    , '(\s{2,})' , ' ') , ' '))::varchar(500)                                              as security_name_source

    , case
        when p.cusip_number = 'USD999997'
            then 1
        else 0
    end::int                                                                               as is_cash
    , 0::int                                                                               as is_sweep

    , case
        when p.security_type_code = '' and p.security_modifier_code = ''
            then p.aggregated_total_position_trade_date_quantity::decimal(15 , 2)
        when factor.factor > 0
            then p.aggregated_total_position_trade_date_quantity::decimal(15 , 2)
                * factor.factor
        else
            (
                p.aggregated_total_position_trade_date_quantity::decimal(20 , 5)
                *
                price.expanded_latest_price::decimal(20 , 5)
            )::decimal(15 , 2)
    end                                                                                    as market_value
    , p.aggregated_total_position_trade_date_quantity::decimal(20 , 5)                     as units_shares
    , p.aggregated_total_position_trade_date_quantity::decimal(20 , 5)                     as quantity
    , null::decimal(20 , 5)                                                                as quantity_settled
    , null::decimal(20 , 5)                                                                as quantity_unsettled

    , case
        when factor.factor > 0
            then price.expanded_latest_price::decimal(20 , 5) * factor.factor
        else
            price.expanded_latest_price::decimal(20 , 5)
    end                                                                                    as price
    , price.expanded_latest_price::decimal(20 , 5)                                         as price_unfactored
    , factor.factor::decimal(20 , 5)                                                       as factor

    , p.current_total_cost_on_position_level::decimal(20 , 5)                              as cost_basis

    , null::varchar(500)                                                                   as security_id_source

    , null::varchar(500)                                                                   as underlying_ticker
    , null::varchar(500)                                                                   as underlying_cusip
    , null::varchar(500)                                                                   as underlying_security_id_source

    , cmsd.normalized::varchar(500)                                                        as product_type
    , cmsd.definition::varchar(500)                                                        as product_type_source
    , p.security_type_code::varchar(500)                                                   as product_type_source_code

    , cmat.normalized::varchar(500)                                                        as account_type
    , cmat.definition::varchar(500)                                                        as account_type_source
    , p.portfolio_account_type::varchar(500)                                               as account_type_source_code

    , isin.isin_code::varchar(500)                                                         as isin
    , sedol.sedol_1::varchar(500)                                                          as sedol

    , null::variant                                                                        as extra_fields

    , p.is_head                                                                            as is_head
    , p.is_current                                                                         as is_current
    , p._source_loaded_at                                                                  as _source_loaded_at
    , p._source_file::varchar(500)                                                         as _source_file
from {{ ref('pershing_mps__potl_a_aggregated_total_position_quantity_holdings') }} as p
left join {{ ref('pershing_mps__isca_f') }} as price
    on p.effective_date = price.effective_date
    and p.cusip_number = price.cusip_number
left join {{ ref('pershing_mps__isca_c') }} as sec
    on p.effective_date = sec.effective_date
    and p.cusip_number = sec.cusip_number
left join {{ ref('pershing_mps__isca_d') }} as factor
    on p.effective_date = factor.effective_date
    and p.cusip_number = factor.cusip_number
left join {{ ref('pershing_mps__isca_g') }} as isin
    on p.effective_date = isin.effective_date
    and p.cusip_number = isin.cusip_number
left join {{ ref('pershing_mps__isca_k') }} as sedol
    on p.effective_date = sedol.effective_date
    and p.cusip_number = sedol.cusip_number
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'product_type'
    and p.security_type_code = cmsd.source
left join {{ ref('custodian_mappings') }} as cmat
    on p.custodian = cmat.custodian
    and cmat.field = 'account_type'
    and p.portfolio_account_type = cmat.source
where true
