select
     p.effective_date                        as effective_date
    ,p.custodian                             as custodian
    ,cf.firm                                 as firm
    ,p.firm_source                           as firm_source
    ,p.account_number                        as account_number
    ,p.account_number                        as account_number_formatted
    ,p.cusip                                 as cusip
    ,s.symbol                                as ticker
    ,case
        when s.security_type_code = 'MM'
            then 1
        else 0
        end::int                             as is_cash
    ,0::int                                  as is_sweep
    ,s.security_description                  as source_security_name
    ,p.position_value::decimal(15,2)         as market_value
    ,p.quantity::decimal(19,9)               as units_shares
    ,p.price::decimal(19,9)                  as price
    ,p.price::decimal(19,9)                  as price_unfactored
    ,null::decimal(19,9)                     as factor
    ,null::decimal(19,9)                     as cost_basis
    ,cmsd.normalized                         as security_type
    ,cmsd.definition                         as source_security_type
    ,s.security_type_code                    as source_security_type_code
    ,null::varchar(100)                      as account_type
    ,null::varchar(100)                      as source_account_type --cash/margin/Legal Hold and Repo/Margin/Partially Called Bonds/Restricted Shares Position/Short
    ,null::varchar(100)                      as source_account_type_code
    ,p.is_head                               as is_head
    ,p.is_current                            as is_current
    ,p._source_loaded_at                     as _source_loaded_at
    ,p._source_file                          as _source_file
from {{ ref('lpl_network__base_position') }} p
left join {{ ref('lpl_network__base_position_securities') }} s
    on p.effective_date = s.effective_date
    and p.security_id = s.security_id
    and p.subscriber_id = s.subscriber_id
left join {{ ref('custodian_firms') }} cf
    on p.firm_source = cf.firm_source
{# left join {{ ref('custodian_mappings') }}     cmat
    on p.account_type = cmat.source
    and cmat.custodian = 'fidelity'
    and cmat.field = 'account_type' #}
left join {{ ref('custodian_mappings') }}     cmsd
    on p.custodian = cmsd.custodian
    and cmsd.field = 'security_type_description'
    and s.security_type_code = cmsd.source
where true
    and p.firm_source = 'swag'
