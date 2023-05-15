select
    p.effective_date
  , p.custodian                             as custodian
  , cf.firm                                 as firm
  , p.firm_source                           as firm_source
  , p.account_custodial                     as account_number
  , p.account_custodial_formatted           as account_number_formatted
  , p.cusip                                 as cusip
  , case 
      when p.security_description_line_1 = 'Option'
        then p.option_symbol_id
      else p.symbol                                
      end                                   as ticker
  , case
        when p.product_code in ('SEMYM')
            then 1
        else 0
        end::int                            as is_cash
  , 0::int                                  as is_sweep
  , rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(p.security_description_line_1, '')
                             , nvl(p.security_description_line_2, '')
                             , nvl(p.security_description_line_4, '')
                             , nvl(p.security_description_line_4, '')
                             , nvl(p.security_description_line_5, ''))
            , '(\s{2,})', ' '), ' '))       as source_security_name
  , p.position_market_value::decimal(15, 2) as market_value
  , p.trade_date_quantity::decimal(19, 9)   as units_shares
  , p.market_price::decimal(19, 9)          as price
  , p.unfactored_price::decimal(19, 9)      as price_unfactored
  , p.current_factor_amount::decimal(19, 9) as factor
  , cb.cost_basis::decimal(19,9)            as cost_basis
  , cmsd.normalized                         as security_type
  , cmsd.definition                         as source_security_type
  , p.security_type                         as source_security_type_code
  , cmat.normalized::varchar(100)           as account_type
  , cmat.definition::varchar(100)           as source_account_type --cash/margin/Legal Hold and Repo/Margin/Partially Called Bonds/Restricted Shares Position/Short
  , p.account_type::varchar(100)            as source_account_type_code
  , p.is_head                               as is_head
  , p.is_current                            as is_current
  , p._source_loaded_at                     as _source_loaded_at
  , p._source_file                          as _source_file
from {{ ref('fidelity_mps_history__vw_positd_position') }} p
left join {{ ref('custodian_firms') }} cf
    on p.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }}     cmat
    on p.custodian = cmat.custodian
    and cmat.field = 'account_type'
    and p.account_type = cmat.source
left join {{ ref('custodian_mappings') }}     cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'security_type_description'
    and p.security_type = cmsd.source
left join (
    select effective_date, account_custodial, cusip, sum(current_cost_unadjusted_wash) as cost_basis
    from {{ ref('fidelity_mps_history__vw_tlaopen_tax_accounting') }}
    where is_head = 1
    group by effective_date, account_custodial, cusip
    ) cb
    on p.effective_date = cb.effective_date
    and p.account_custodial = cb.account_custodial
    and p.cusip = cb.cusip
where true