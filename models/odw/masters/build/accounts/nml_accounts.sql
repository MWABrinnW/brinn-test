-- unions accounts from the masters pipeline
select
    ba.effective_date
    , ba.system_name
    , ba.system_instance
    , ba.system_key
    , ba.firm_source
    , ba.account_number_formatted
    , ba.account_number
    , ba.__account_key              as __account_key
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
    , ba.advisor_id
    , ba.advisor_id_source
    , ba.advisor_email
    , case when ba.is_discretionary = 1 then 'discretionary'
        when ba.is_discretionary = 0 then 'non-discretionary'
        when ba.is_discretionary = 2 then 'partial'
    end::text                       as discretion_status
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
    , ma.account_number::text                 as __account_key
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
    , ma.advisor_id::text                     as advisor_id
    , ma.advisor_id_source::text              as advisor_id_source
    , ma.advisor_email::text                  as advisor_email
    , ma.discretion_status::text              as discretion_status
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
-- unions account from legacy masters pipeline prior to 2025
union all
select
    la.effective_date
    , la.system_name
    , la.system_instance
    , la.system_key
    , la.firm_source
    , la.account_number_formatted
    , la.account_number
    , la.__account_key
    , la.account_value
    , la.account_id_crm
    , la.account_id_pms
    , la.account_name
    , la.client_id_crm
    , la.client_id_pms
    , la.client_name
    , la.custodian
    , la.account_type
    , la.aum_classification
    , la.model_investment_strategy
    , la.fee_schedule
    , la.advisor
    , la.advisor_id
    , la.advisor_id_source
    , la.advisor_email
    , la.discretion_status
    , la.is_active
    , la.opened_date
    , la.closed_date
    , la.location_code
    , la.office_name
    , la.link
    , la.link_type
    , la.link_subtype
    , la.is_institutional
    , la.is_erisa
    , la.is_market_day
    , la.is_market_month_end
    , la.is_excluded
    , la.excluded_reasons
    , la.is_primary
    , la.is_manual_account
    , la.is_legacy
    , la._source_loaded_at
    , la._created_at
    , la._extra_fields
from {{ ref('stg_legacy_accounts') }} as la
order by effective_date , system_key , account_number
