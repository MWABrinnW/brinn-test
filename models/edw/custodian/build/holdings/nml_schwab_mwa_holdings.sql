select
    p.effective_date                                                as effective_date
    , p.custodian                                                   as custodian
    , p.firm                                                        as firm
    , p.firm_source                                                 as firm_source
    , p.account_number                                              as account_number
    , p.account_number                                              as account_number_formatted

    , coalesce(p.ticker_symbol , p.cusip)                           as symbol
    , case
        when p.ticker_symbol is null and p.cusip is null
            and cmsd.definition not in ('Put Option' , 'Call Option')
            then p.schwab_security_number
        else p.ticker_symbol
    end                                                             as ticker
    , p.cusip                                                       as cusip
    , rtrim(ltrim(regexp_replace(concat_ws(
        ' '
        , coalesce(p.security_description_line_1 , '')
        , coalesce(p.security_description_line_2 , '')
        , coalesce(p.security_description_line_3 , '')
        , coalesce(p.security_description_line_4 , '')
    )
    , '(\s{2,})' , ' ') , ' '))                                     as security_name_source

    , case
        when p.ticker_symbol in ('SWGXX')
            then 1
        else 0
    end::int                                                        as is_cash
    , case
        when p.ticker_symbol in ('SWGXX')
            then 1
        else 0
    end::int                                                        as is_sweep

    , p.market_value_settled_and_unsettled::decimal(15 , 2)         as market_value
    , p.quantity_settled_and_unsettled::decimal(20 , 5)             as units_shares
    , p.quantity_settled_and_unsettled::decimal(20 , 5)             as quantity
    , p.quantity_settled::decimal(20 , 5)                           as quantity_settled
    , (
        p.quantity_unsettled_long
        + p.quantity_unsettled_short
    )::decimal(20 , 5
    )                                                               as quantity_unsettled

    , p.closing_price::decimal(20 , 5)                              as price
    , p.closing_price_unfactored::decimal(20 , 5)                   as price_unfactored
    , p.factor::decimal(20 , 5)                                     as factor

    , pcb.cost_basis_unamortized_cost_basis_amount::decimal(20 , 5) as cost_basis

    , p.item_issue_id                                               as security_id_source

    , p.underlying_ticker_symbol                                    as underlying_ticker
    , p.underlying_cusip                                            as underlying_cusip
    , p.underlying_item_issue_id                                    as underlying_security_id_source

    , cmpt.normalized::text(500)                                    as product_type
    , cmpt.definition::text(500)                                    as product_type_source_definition
    , p.product_code::text(500)                                     as product_type_source_code

    , null::varchar(500)                                            as account_type
    , initcap(p.accounting_rule_code)::varchar(500)                 as account_type_source
    , null::varchar(500)                                            as account_type_source_code

    , p.isin::varchar(500)                                          as isin
    , p.sedol::varchar(500)                                         as sedol

    , object_construct_keep_null(
        'legacy_product_type' , cmsd.normalized::text
        , 'legacy_product_type_source_definition' , cmsd.definition::text
        , 'legacy_product_type_source_code' , p.product_code::text
    )                                                               as extra_fields

    , p.is_head                                                     as is_head
    , p.is_current                                                  as is_current
    , p._source_loaded_at                                           as _source_loaded_at
    , null::varchar(500)                                            as _source_file
from {{ ref('schwab__base_positions') }} as p
left join {{ ref('schwab__base_cost_basis') }} as pcb
    on p.effective_date = pcb.effective_date
    and p.firm_source = pcb.firm_source
    and pcb.rn = 1
    and p.account_number = pcb.account_number
    and p.cusip = pcb.cusip
left join {{ ref('custodian_mappings') }} as cmpt
    on p.custodian = cmpt.custodian
    and cmpt.field = 'product_type'
    and p.product_code = cmpt.source
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'legacy_product_type'
    and p.legacy_security_type = cmsd.source
where true
    and p.firm_source = 'mwa'
    and p.rn = 1
qualify row_number() over (
    partition by p.effective_date , p.account_number , p.cusip , ticker , p.item_issue_id , account_type_source
    order by coalesce(pcb.cost_basis_unamortized_cost_basis_amount , 0) desc
) = 1
