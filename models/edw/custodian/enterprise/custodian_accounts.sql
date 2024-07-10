with cte_dates as
(
    select date_key as effective_date
    from {{ ref('dates') }}
    where is_market_day = 1
        and date_key between
            (select min(effective_date) from {{ ref('bld_custodian_holdings') }})
            and
            (select max(effective_date) from {{ ref('bld_custodian_holdings') }})
)
,cte_custodians_spined as
(
    select distinct c.custodian, c.firm_source, cf.firm, d.effective_date
    from {{ ref('custodians') }} c
    left join {{ ref('custodian_firms') }} cf
        on c.firm_source = cf.firm_source
    cross join cte_dates d
)

select
      c.effective_date
    , c.custodian
    , c.firm
    , c.firm_source
    , ca.account_number
    , ca.account_number_formatted
    , ca.total_value
    , ca.cash_value
    , ca.custodian_link
    , ca.custodian_link_detail
    , ca.rep_link
    , ca.rep_link_detail
    , ca.account_type_source_code
    , ca.account_type_source_definition
    , ca.account_type
    , ca.opened_date
    , ca.account_title
    , ca.first_name
    , ca.middle_name
    , ca.last_name
    {# , irs_id #}
    , ca.irs_id_type
    , ca.birth_date
    , ca.email_address
    , ca.phone
    , ca.cost_basis_method_mutual_funds
    , ca.cost_basis_method_non_mutual_funds
    , ca.is_taxable
    , ca.is_fee_authorized
    , ca.is_prime_broker
    , ca.is_margin_enabled
    , ca.is_multiple_margin_enabled
    , ca.options_approval_level
    , ca.restrictions_source_code
    , ca.restrictions_source_definition
    , ca.restrictions
    , ca.mailing_address_street
    , ca.mailing_address_city
    , ca.mailing_address_state
    , ca.mailing_address_zip
    , ca.legal_address_street
    , ca.legal_address_city
    , ca.legal_address_state
    , ca.legal_address_zip
    , ca.legal_address_country
    , {{ col_is_head(reference='cte_custodians_spined', source_date_col='c.effective_date') }}
    , {{ col_is_current(date_col='c.effective_date') }}
    , ca.rn_firm_source
    , ca.rn_global
    , ca._created_at
    , ca._source_loaded_at
    {# , ca._source_file #}
from cte_custodians_spined c
left join {{ ref('bld_custodian_accounts') }} ca
    on c.custodian = ca.custodian
    and c.firm_source = ca.firm_source
    and c.effective_date = ca.effective_date
    -- exclude duplicated records (i.e. MWA schwab account linked
    -- to both orion and non-orion master--return only one)
    and ca.rn_firm_source = 1
where true
