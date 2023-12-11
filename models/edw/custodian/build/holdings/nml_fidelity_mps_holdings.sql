with cte_cost_basis as (
    select
        effective_date
        , account_custodial
        , cusip
        , sum(current_cost_unadjusted_wash) as cost_basis
    from {{ ref('fidelity_mps_history__vw_tlaopen_tax_accounting') }}
    where 1 = 1
    group by effective_date , account_custodial , cusip
)

select
    p.effective_date
    , p.custodian                                 as custodian
    , cf.firm                                     as firm
    , p.firm_source                               as firm_source
    , p.account_custodial                         as account_number
    , p.account_custodial_formatted               as account_number_formatted
    , coalesce(p.symbol , p.cusip)                as symbol
    , case
        when p.security_description_line_1 = 'Option'
            then p.option_symbol_id
        else p.symbol
    end                                           as ticker
    , p.cusip                                     as cusip
    , rtrim(ltrim(regexp_replace(concat_ws(
        ' '
        , coalesce(p.security_description_line_1 , '')
        , coalesce(p.security_description_line_2 , '')
        , coalesce(p.security_description_line_4 , '')
        , coalesce(p.security_description_line_4 , '')
        , coalesce(p.security_description_line_5 , '')
    )
    , '(\s{2,})' , ' ') , ' '))                   as security_name_source
    , case
        when p.product_code = 'SEMYM' or sweep.ticker is not null
            then 1
        else 0
    end::int                                      as is_cash
    , case
        when sweep.ticker is not null
            then 1
        else 0
    end::int                                      as is_sweep

    , p.position_market_value::decimal(15 , 2)    as market_value
    , p.trade_date_quantity::decimal(20 , 5)      as units_shares
    , p.trade_date_quantity::decimal(20 , 5)      as quantity
    , p.trade_date_quantity::decimal(20 , 5)      as quantity_settled
    , (
        p.settlement_date_quantity
        - p.trade_date_quantity
    )::decimal(20 , 5
    )                                             as quantity_unsettled

    , p.market_price::decimal(20 , 5)             as price
    , p.unfactored_price::decimal(20 , 5)         as price_unfactored
    , p.current_factor_amount::decimal(20 , 5)    as factor

    , cb.cost_basis::decimal(20 , 5)              as cost_basis

    , p.cusip::varchar(200)                       as security_id_source

    , s2.symbol::varchar(100)                     as underlying_ticker
    , s1.underlying_cusip::varchar(100)           as underlying_cusip
    , s1.underlying_cusip::varchar(100)           as underlying_security_id_source

    , cmpt.normalized::varchar(100)               as product_type
    , cmpt.definition::varchar(100)               as product_type_source_definition
    , p.product_code::text(200)                   as product_type_source_code

    , cmat.normalized::varchar(100)               as account_type
    , cmat.definition::varchar(100)               as account_type_source
    , p.account_type::varchar(100)                as account_type_source_code

    , p.isin::varchar(200)                        as isin
    , p.sedol::varchar(200)                       as sedol

    , null::variant                               as extra_fields

    , p.is_head                                   as is_head
    , p.is_current                                as is_current
    , p._source_loaded_at                         as _source_loaded_at
    , p._source_file                              as _source_file
from {{ ref('fidelity_mps_history__vw_positd_position') }} as p
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('fidelity_mps_history__vw_secmast_1_security') }} as s1
    on p.effective_date = s1.effective_date
    and p.cusip = s1.cusip
left join {{ ref('fidelity_mps_history__vw_secmast_1_security') }} as s2
    on s1.effective_date = s2.effective_date
    and s1.underlying_cusip = s2.cusip
left join {{ ref('custodian_mappings') }} as cmat
    on p.custodian = cmat.custodian
    and cmat.field = 'account_type'
    and p.account_type = cmat.source
left join {{ ref('custodian_mappings') }} as cmpt
    on p.custodian = cmpt.custodian
    and cmpt.field = 'product_type'
    and p.product_code = cmpt.source
left join cte_cost_basis as cb
    on p.effective_date = cb.effective_date
    and p.account_custodial = cb.account_custodial
    and p.cusip = cb.cusip
left join {{ ref('int_fidelity_mps_account_sweep_fund') }} as sweep
    on p.effective_date = sweep.effective_date
    and p.account_custodial = sweep.account_number
    and p.symbol = sweep.ticker
where true
