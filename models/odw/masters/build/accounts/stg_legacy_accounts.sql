select
    la.effective_date::date                             as effective_date
    , la.system_name::text(200)                         as system_name
    , la.system_details::text(200)                      as system_instance
    , sk.system_key::text(200)                          as system_key
    , sk.firm_source::text(200)                         as firm_source
    , la.financial_account_number::text(200)            as account_number_formatted
    , la.financial_account_number_clean::text(200)      as account_number
    , la.financial_account_number_clean::text           as __account_key
    , la.current_value::number(18 , 2)                  as account_value
    , la.sf_18_digit_id::text(200)                      as account_id_crm
    , la.internal_financial_account_number::text(200)   as account_id_pms
    , la.financial_account_name::text(200)              as account_name
    , la.hh_sf_18_digit_id::text(200)                   as client_id_crm
    , la.internal_household_number::text(200)           as client_id_pms
    , la.household_name::text(200)                      as client_name
    , la.custodian::text(200)                           as custodian
    , la.type_of_account::text(200)                     as account_type
    , la.aum_classification_status::text(200)           as aum_classification
    , la.model_investment_strategy::text(200)           as model_investment_strategy
    -- fee schedule is in XML format for Cambak, excluded from legacy data
    , case when la.system_name = 'CamBak' then null
        else la.fee_schedule
    end                                                 as fee_schedule
    , la.client_manager::text(200)                      as advisor
    , la.discretion_status::text                        as discretion_status
    , la.account_active::int                            as is_active
    , la.account_open_date::date                        as opened_date
    , la.closed_date::date                              as closed_date
    , la.location_code::text(200)                       as location_code
    , la.location_name::text(200)                       as office_name
    , null::text(200)                                   as link
    , null::text(200)                                   as link_type
    , null::text(200)                                   as link_subtype
    , case when (
            la.system_name = 'CamBak'
            or la.system_details = 'SNF.FIVETRAN.SALESFORCE_COMPASS.PLAN_C'
        )
            then 1
        else 0
    end::int                                            as is_institutional
    , case when la.erisa = 'Yes' then 1 else 0 end::int as is_erisa
    , 1::int                                            as is_market_day
    , 1::int                                            as is_market_month_end
    , 0::int                                            as is_excluded
    , null::text                                        as excluded_reasons
    , 1::int                                            as is_primary
    , 0::int                                            as is_manual_account
    , 1::int                                            as is_legacy
    , la.record_datetime::datetime                      as _source_loaded_at
    , la.record_datetime::datetime                      as _created_at
    , null::variant                                     as _extra_fields
    , 1::int                                            as is_head_for_day
from {{ source('edw_mwa', 'financial_account_monthly') }} as la
-- normalize system key for legacy data
left join {{ ref('system_firm') }} as sk
    on la.system_name = sk.legacy_system_name
where true
    and la.effective_date <= '2024-12-31'
qualify row_number() over (
        partition by la.effective_date , la.month_end_date , la.id
        order by la.record_date desc
    ) = 1
