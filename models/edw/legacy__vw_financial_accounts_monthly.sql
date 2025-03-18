{{ config(
  grants = {'+select': ['db_pms_mwa_r']},
) }}

select
    system_name
    , system_details
    , financial_account_number
    , financial_account_number_clean
    , internal_financial_account_number
    , internal_household_number
    , registrant_name
    , financial_account_name
    , household_name
    , location_code
    , location_name
    , type_of_account
    , custodian
    , model_investment_strategy
    , client_manager
    , fee_schedule
    , erisa
    , account_active
    , aum_classification_status
    , discretion_status
    , proxy_voting_status
    , cost_basis_disposal_method
    , prime_broker_enabled
    , current_value
    , account_open_date
    , closed_date
    , as_of_date
    , effective_date
    , month_end_date
    , source_of_truth_final
    , id
    , record_date
    , record_datetime
    , hh_sf_18_digit_id
    , sf_18_digit_id as fa_sf_18_digit_id
    , {{ col_is_head(reference=source('edw_mwa', 'financial_account_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
from {{ source('edw_mwa', 'financial_account_monthly') }}
where true
    and effective_date <= '2024-12-31'
qualify row_number() over (
        partition by effective_date , month_end_date , id
        order by record_date desc
    ) = 1
union all
-- unions accounts with an effective date greater than or equal to 2025-01-01
select
    a.system_name::text                 as system_name
    , a.system_key::text                as system_details
    , a.account_number_formatted::text  as financial_account_number
    , a.account_number::text            as financial_account_number_clean
    , a.pms_account_id::text            as internal_financial_account_number
    , a.pms_client_id::text             as internal_household_number
    , null::text                        as registrant_name
    , a.account_name::text              as financial_account_name
    , a.client_name::text               as household_name
    , a.location_code::text             as location_code
    , a.office_name::text               as location_name
    , a.account_type::text              as type_of_account
    , a.custodian::text                 as custodian
    , a.model_investment_strategy::text as model_investment_strategy
    , a.advisor::text                   as client_manager
    , a.fee_schedule::text              as fee_schedule
    , a.is_erisa::text                  as erisa
    , a.is_active::boolean              as account_active
    , a.aum_classification::text        as aum_classification_status
    , case when a.is_discretionary = 1 then 'discretionary'
        when a.is_discretionary = 0 then 'non-discretionary'
        when a.is_discretionary = 2 then 'partial'
    end::text                           as discretion_status
    , null::text                        as proxy_voting_status
    , null::text                        as cost_basis_disposal_method
    , null::text                        as prime_broker_enabled
    , a.account_value::number(22 , 2)   as current_value
    , a.opened_date::date               as account_open_date
    , a.closed_date::date               as closed_date
    , a.effective_date::date            as as_of_date
    , a.effective_date::date            as effective_date
    , dt.month_end_date::date           as month_end_date
    , null::text                        as source_of_truth_final
    , null::text                        as id
    , a._created_at::date               as record_date
    , a._created_at                     as record_datetime
    , a.crm_client_id::text             as hh_sf_18_digit_id
    , a.crm_account_id::text            as fa_sf_18_digit_id
    , null::int                         as is_head
    , {{ col_is_current(date_col='effective_date') }}

from {{ ref('bld_accounts') }} as a
left join {{ ref('dates') }} as dt
    on a.effective_date = dt.date_key
where true
    and a.effective_date >= '2025-01-01'
    and a.is_excluded = 0
    and a.is_primary = 1
    and (a.closed_date is null or a.effective_date < a.closed_date)
    and a.is_market_month_end = 1
order by effective_date desc , system_name asc
