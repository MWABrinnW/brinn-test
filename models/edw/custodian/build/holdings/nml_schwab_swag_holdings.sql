select
    p.effective_date                                            as effective_date
  , p.custodian                                                 as custodian
  , p.firm                                                      as firm
  , p.firm_source                                               as firm_source
  , p.account_number                                            as account_number
  , p.account_number                                            as account_number_formatted
  , p.cusip                                                     as cusip
  , case
        when p.ticker_symbol is null and p.cusip is null
            and cmsd.definition not in ('Put Option', 'Call Option')
            then p.schwab_security_number
        else p.ticker_symbol
        end                                                     as ticker
  , case
        when p.ticker_symbol in ('SWGXX')
            then 1
        else 0
        end::int                                                as is_cash
  , case
        when p.ticker_symbol in ('SWGXX')
            then 1
        else 0
        end::int                                                as is_sweep
  , rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(p.security_description_line_1, '')
                             , nvl(p.security_description_line_2, '')
                             , nvl(p.security_description_line_3, '')
                             , nvl(p.security_description_line_4, ''))
            , '(\s{2,})', ' '), ' '))                           as source_security_name
  , p.market_value_settled_and_unsettled::decimal(15, 2)        as market_value
  , p.quantity_settled_and_unsettled::decimal(19, 9)            as units_shares
  , p.closing_price::decimal(19, 9)                             as price
  , p.closing_price_unfactored::decimal(19, 9)                  as price_unfactored
  , p.factor::decimal(19, 9)                                    as factor
  , pcb.cost_basis_unamortized_cost_basis_amount::decimal(19,9) as cost_basis
  , cmsd.normalized                                             as security_type
  , cmsd.definition                                             as source_security_type
  , p.legacy_security_type                                      as source_security_type_code
  , null::varchar(100)                                          as account_type
  , initcap(p.accounting_rule_code)                             as source_account_type
  , null::varchar(100)                                          as source_account_type_code
  , p.is_head                                                   as is_head
  , p.is_current                                                as is_current
  , p._source_loaded_at                                         as _source_loaded_at
  , null::varchar(200)                                          as _source_file
from {{ ref('schwab__base_positions') }} as p
left join {{ ref('schwab__base_cost_basis') }} as pcb
    on p.effective_date = pcb.effective_date
    and p.firm_source = pcb.firm_source
    and p.rn = pcb.rn
    and p.account_number = pcb.account_number
    and p.cusip = pcb.cusip
left join {{ ref('custodian_mappings') }} as cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'security_type_description'
    and p.legacy_security_type = cmsd.source
where true
    and p.firm_source = 'swag'
    and p.rn = 1
qualify row_number() over (
    partition by p.effective_date , p.account_number , coalesce(p.cusip , ticker) , source_account_type
    order by coalesce(pcb.cost_basis_unamortized_cost_basis_amount , 0) desc
) = 1
