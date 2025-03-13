-- unions accounts from the masters pipeline
select
    ba.effective_date
    , ba.system_name
    , ba.system_instance
    , ba.system_key
    , ba.firm_source
    , ba.account_number_formatted
    , ba.account_number
    , ba.account_value
    , ba.crm_account_id             as account_id_crm
    , ba.pms_account_id             as account_id_pms
    , ba.account_name
    , ba.crm_client_id              as client_id_crm
    , ba.pms_client_id              as client_id_pms
    , ba.client_name
    , coalesce((case when ba.__custodian_cust = '' then null
        else ba.__custodian_cust
    end::text(200)) , ba.custodian) as custodian
    , ba.account_type
    , ba.aum_classification
    , ba.model_investment_strategy
    , ba.fee_schedule
    , ba.advisor
    , ba.is_active
    , ba.opened_date
    , ba.closed_date
    , ba.location_code
    , ba.office_name
    , ba.link
    , ba.link_type
    , ba.link_subtype
    , ba.is_institutional
    , ba.is_erisa
    , ba.is_market_day
    , ba.is_market_month_end
    , ba.is_excluded
    , ba.excluded_reasons
    , ba.is_primary
    , 0::int                        as is_manual_account
    , 0::int                        as is_legacy
    , ba._source_loaded_at
    , ba._created_at
    , ba._extra_fields

from {{ ref('bld_accounts') }} as ba
where true
    and ba.effective_date >= '2025-01-01'
union all
-- unions "manual" accounts added by data management
select
    ma.effective_date::date                   as effective_date
    , ma.system_name::text(200)               as system_name
    , ma.system_instance::text(200)           as system_instance
    , ma.system_key::text(200)                as system_key
    , ma.firm_source::text(200)               as firm_source
    , ma.account_number_formatted::text(200)  as account_number_formatted
    , ma.account_number::text(200)            as account_number
    , ma.account_value::number(18 , 2)        as account_value
    , ma.account_id_crm::text(200)            as account_id_crm
    , ma.account_id_pms::text(200)            as account_id_pms
    , ma.account_name::text(200)              as account_name
    , ma.client_id_crm::text(200)             as client_id_crm
    , ma.client_id_pms::text(200)             as client_id_pms
    , ma.client_name::text(200)               as client_name
    , ma.custodian::text(200)                 as custodian
    , ma.account_type::text(200)              as account_type
    , ma.aum_classification::text(200)        as aum_classification
    , ma.model_investment_strategy::text(200) as model_investment_strategy
    , ma.fee_schedule::text(200)              as fee_schedule
    , ma.advisor::text(200)                   as advisor
    , ma.is_active::int                       as is_active
    , ma.opened_date::date                    as opened_date
    , ma.closed_date::date                    as closed_date
    , ma.location_code::text(200)             as location_code
    , ma.office_name::text(200)               as office_name
    , ma.link::text(200)                      as link
    , ma.link_type::text(200)                 as link_type
    , ma.link_subtype::text(200)              as link_subtype
    , ma.is_institutional::int                as is_institutional
    , ma.is_erisa::int                        as is_erisa
    , ma.is_market_day::int                   as is_market_day
    , ma.is_market_month_end::int             as is_market_month_end
    , ma.is_excluded::int                     as is_excluded
    , ma.excluded_reasons::text               as excluded_reasons
    , 1::int                                  as is_primary
    , ma.is_manual_account::int               as is_manual_account
    , 0::int                                  as is_legacy
    , ma._created_at::datetime                as _source_loaded_at
    , ma._created_at::datetime                as _created_at
    , ma._extra_fields                        as _extra_fields
from {{ ref('stg_manual_accounts') }} as ma
where true
union all
-- unions account from legacy masters pipeline prior to 2025
select
    la.effective_date::date                             as effective_date
    , la.system_name::text(200)                         as system_name
    , la.system_details::text(200)                      as system_instance
    , sk.system_key::text(200)                          as system_key
    , sk.firm_source::text(200)                         as firm_source
    , la.financial_account_number::text(200)            as account_number_formatted
    , la.financial_account_number_clean::text(200)      as account_number
    , la.current_value::number(18 , 2)                  as account_value
    , la.fa_sf_18_digit_id::text(200)                   as account_id_crm
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
from {{ ref('legacy__vw_financial_accounts_monthly') }} as la
-- normalize system key for legacy data
left join {{ ref('system_firm') }} as sk
    on la.system_name = sk.legacy_system_name
where la.effective_date <= '2024-12-31'
order by effective_date , system_key , account_number
