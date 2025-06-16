{{
  config(
    alias = 'accounts' if target.name in ['prod', 'ci'] else none,
    schema = 'enterprise' if target.name in ['prod', 'ci'] else none
    )
}}

select
    effective_date
    , system_name
    , system_instance
    , system_key
    , firm_source
    , account_number_formatted
    , account_number
    , account_value
    , account_id_crm
    , account_id_pms
    , account_name
    , client_id_crm
    , client_id_pms
    , client_name
    , custodian
    , account_type
    , aum_classification
    , model_investment_strategy
    , fee_schedule
    , advisor
    , advisor_id
    , advisor_id_source
    , advisor_email
    , discretion_status
    , is_active
    , opened_date
    , closed_date
    , location_code
    , office_name
    , link
    , link_type
    , link_subtype
    , is_institutional
    , is_erisa
    , is_market_day
    , is_market_month_end
    , is_manual_account
    , is_legacy
    , {{ col_is_head(
        reference=ref('bld_accounts_all'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
    ) }}
    , _source_loaded_at
    , _created_at
    , _extra_fields
from {{ ref('bld_accounts_all') }}
where true
    and is_excluded = 0
    and is_primary = 1
    and (closed_date is null or effective_date < closed_date)
order by effective_date , system_key
