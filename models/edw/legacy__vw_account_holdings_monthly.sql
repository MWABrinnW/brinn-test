{{ config(
  grants = {'+select': ['db_pms_mwa_r']}
) }}

select
    lh.system_name
    , lh.system_details
    , lh.financial_account_number
    , lh.financial_account_number_clean
    , lh.internal_financial_account_number
    , lh.internal_household_number
    , lh.registrant_name
    , lh.financial_account_name
    , lh.aum_classification_status
    , lh.household_name
    , lh.location_code
    , lh.location_name
    , lh.type_of_account
    , lh.custodian
    , lh.discretion_status
    , lh.proxy_voting_status
    , lh.model_investment_strategy
    , lh.cusip
    , lh.ticker
    , lh.cusip_ticker
    , lh.security_name as source_security_name
    , lh.market_value
    , lh.units_shares
    , lh.price
    , lh.cost_basis
    , lh.as_of_date
    , lh.source_of_truth_final
    , lh.product_type
    , lh.product_sub_type
    , lh.product_class
    , lh.product_description
    , lh.product_category
    , lh.product_category_name
    , lh.product_iso_cfi_type
    , lh.product_iso_cfi_code
    , lh.product_cfi_category
    , lh.product_cfi_attribute
    , lh.product_name
    , lh.security_type as source_security_type
    , lh.effective_date
    , lh.record_datetime
    , lh.record_date
    , lh.account_holdings_id
    , lh.month_end_date
    , {{ col_is_head(reference=source('edw_mwa', 'account_holdings_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
from {{ source('edw_mwa', 'account_holdings_monthly') }} as lh
where true
    and lh.effective_date <= '2024-12-31'
qualify row_number() over (
        partition by lh.effective_date , lh.month_end_date , lh.account_holdings_id
        order by lh.effective_date desc
    ) = 1
-- unions holdings with an effective date greater than or equal to 2025-01-01
union all
select
    h.system_name                            as system_name
    , h.system_key::text(200)                as system_details
    , h.account_number_formatted             as financial_account_number
    , h.account_number                       as financial_account_number_clean
    , h.account_id_pms                       as internal_financial_account_number
    , h.client_id_pms                        as internal_household_number
    , null::text(200)                        as registrant_name
    , h.account_name                         as financial_account_name
    , h.aum_classification                   as aum_classification_status
    , h.client_name                          as household_name
    , h.location_code                        as location_code
    , h.office_name                          as location_name
    , h.account_type                         as type_of_account
    , h.custodian                            as custodian
    , h.discretion_status                    as discretion_status
    , null::text(200)                        as proxy_voting_status
    , h.model_investment_strategy::text(200) as model_investment_strategy
    , h.cusip                                as cusip
    , h.ticker                               as ticker
    , null::text(200)                        as cusip_ticker
    , h.security_name                        as source_security_name
    , h.market_value                         as market_value
    , h.quantity                             as units_shares
    , h.price                                as price
    , h.cost_basis                           as cost_basis
    , h.effective_date                       as as_of_date
    , null::text(200)                        as source_of_truth_final
    , h.security_type::text(200)             as product_type
    , null::text(200)                        as product_sub_type
    , h.asset_class                          as product_class
    , null::text(200)                        as product_description
    , h.security_subtype                     as product_category
    , null::text(200)                        as product_category_name
    , null::text(200)                        as product_iso_cfi_type
    , null::text(200)                        as product_iso_cfi_code
    , null::text(200)                        as product_cfi_category
    , null::text(200)                        as product_cfi_attribute
    , h.security_name                        as product_name
    , h.security_type                        as source_security_type
    , h.effective_date                       as effective_date
    , h._created_at                          as record_datetime
    , h._created_at::date                    as record_date
    , null::text(200)                        as account_holdings_id
    , dt.month_end_date                      as month_end_date
    , null::int                              as is_head
    , null::int                              as is_current
from {{ ref('edw_holdings') }} as h
left join {{ ref('dates') }} as dt
    on h.effective_date = dt.date_key
where true
    and h.effective_date >= '2025-01-01'
order by effective_date desc , system_name asc
