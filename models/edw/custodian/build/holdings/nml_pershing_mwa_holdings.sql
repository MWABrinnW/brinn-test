select
      p.effective_date                                                          as effective_date
    , p.custodian                                                               as custodian
    , cf.firm                                                                   as firm
    , p.firm_source                                                             as firm_source
    , p.account_number                                                          as account_number
    , p.account_number                                                          as account_number_formatted
    , p.cusip_number                                                            as cusip
    , p.security_symbol                                                         as ticker
    , case
        when p.cusip_number = 'USD999997'
            then 1
        else 0
        end::int                                                                as is_cash
    , 0::int                                                                    as is_sweep
    , rtrim(ltrim(regexp_replace(concat_ws(' '
                                , nvl(sec.security_description_line_1, '')
                                , nvl(sec.security_description_line_2, '')
                                , nvl(sec.security_description_line_3, '')
                                , nvl(sec.security_description_line_4, '')
                                , nvl(sec.security_description_line_5, ''))
                , '(\s{2,})', ' '), ' '))                                       as source_security_name
    , case 
        when p.security_type_code = '' and p.security_modifier_code = ''
            then aggregated_total_position_trade_date_quantity::decimal(15, 2)
        when factor.factor > 0
            then aggregated_total_position_trade_date_quantity::decimal(15, 2) 
                * factor.factor
        else 
            (
            p.aggregated_total_position_trade_date_quantity::decimal(19, 9)
            *
            price.expanded_latest_price::decimal(19, 9)
            )::decimal(15, 2) 
        end                                                                     as market_value
    , p.aggregated_total_position_trade_date_quantity::decimal(19, 9)           as units_shares
    , case
        when factor.factor > 0
            then price.expanded_latest_price::decimal(19, 9) * factor.factor
        else 
            price.expanded_latest_price::decimal(19, 9)
        end                                                                     as price
    , price.expanded_latest_price::decimal(19, 9)                               as price_unfactored
    , factor.factor::decimal(19, 9)                                             as factor
    , p.current_total_cost_on_position_level::decimal(19,9)                     as cost_basis
    , cmsd.normalized                                                           as security_type
    , cmsd.definition                                                           as source_security_type
    , p.security_type_code                                                      as source_security_type_code
    , cmat.normalized::varchar(100)                                             as account_type
    , cmat.definition::varchar(100)                                             as source_account_type
    , p.portfolio_account_type::varchar(100)                                    as source_account_type_code
    , p.is_head                                                                 as is_head
    , p.is_current                                                              as is_current
    , p._source_loaded_at                                                       as _source_loaded_at
    , p._source_file::varchar(200)                                              as _source_file
from {{ ref('pershing_mwa__potl_a_aggregated_total_position_quantity_holdings') }} p
left join {{ ref('pershing_mwa__isca_f') }} price
    on p.effective_date = price.effective_date
    and p.cusip_number = price.cusip_number
left join {{ ref('pershing_mwa__isca_c') }} sec
    on p.effective_date = sec.effective_date
    and p.cusip_number = sec.cusip_number
left join {{ ref('pershing_mwa__isca_d') }} factor
    on p.effective_date = factor.effective_date
    and p.cusip_number = factor.cusip_number
left join {{ ref('custodian_firms') }} cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }}                 cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'security_type_description'
    and p.security_type_code = cmsd.source
left join {{ ref('custodian_mappings') }}     cmat
    on p.custodian = cmat.custodian
    and cmat.field = 'account_type'
    and p.portfolio_account_type = cmat.source
where true
