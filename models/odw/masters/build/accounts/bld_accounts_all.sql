-- non-inst accounts
select
    ba.effective_date              as effective_date
    , ba.system_name               as system_name
    , ba.system_instance           as system_instance
    , ba.system_key                as system_key
    , ba.firm_source               as firm_source
    , ba.account_number_formatted  as account_number_formatted
    , ba.account_number            as account_number
    , ba.__account_key             as __account_key
    , ba.account_value             as account_value
    , ba.crm_account_id            as account_id_crm
    , ba.pms_account_id            as account_id_pms
    , ba.account_name              as account_name
    , ba.crm_client_id             as client_id_crm
    , ba.pms_client_id             as client_id_pms
    , ba.client_name               as client_name
    , coalesce(
        (case when ba.__custodian_cust = '' then null
            else ba.__custodian_cust
        end) , ba.custodian
    )::text                        as custodian
    , ba.account_type              as account_type
    , ba.aum_classification        as aum_classification
    , ba.model_investment_strategy as model_investment_strategy
    , ba.fee_schedule              as fee_schedule
    , ba.advisor                   as advisor
    , ba.advisor_id                as advisor_id
    , ba.advisor_id_source         as advisor_id_source
    , ba.advisor_email             as advisor_email
    , case when ba.is_discretionary = 1 then 'discretionary'
        when ba.is_discretionary = 0 then 'non-discretionary'
        when ba.is_discretionary = 2 then 'partial'
    end::text                      as discretion_status
    , ba.is_active                 as is_active
    , ba.opened_date               as opened_date
    , ba.closed_date               as closed_date
    , ba.location_code             as location_code
    , ba.office_name               as office_name
    , ba.link                      as link
    , ba.link_type                 as link_type
    , ba.link_subtype              as link_subtype
    , ba.is_institutional          as is_institutional
    , ba.is_erisa                  as is_erisa
    , ba.is_market_day             as is_market_day
    , ba.is_market_month_end       as is_market_month_end
    , ba.is_excluded               as is_excluded
    , ba.excluded_reasons          as excluded_reasons
    , ba.is_primary                as is_primary
    , 0::int                       as is_manual_account
    , 0::int                       as is_legacy
    , ba._source_loaded_at         as _source_loaded_at
    , ba._created_at               as _created_at
    , ba._extra_fields             as _extra_fields
from {{ ref('bld_accounts') }} as ba
where true
    and ba.effective_date >= '2025-01-01'

union all

-- institutional accounts
select
    ba.effective_date              as effective_date
    , ba.system_name               as system_name
    , ba.system_instance           as system_instance
    , ba.system_key                as system_key
    , ba.firm_source               as firm_source
    , ba.account_number_formatted  as account_number_formatted
    , ba.account_number            as account_number
    , ba.__account_key             as __account_key
    , ba.account_value             as account_value
    , ba.crm_account_id            as account_id_crm
    , ba.pms_account_id            as account_id_pms
    , ba.account_name              as account_name
    , ba.crm_client_id             as client_id_crm
    , ba.pms_client_id             as client_id_pms
    , ba.client_name               as client_name
    , coalesce(
        (case when ba.__custodian_cust = '' then null
            else ba.__custodian_cust
        end) , ba.custodian
    )::text                        as custodian
    , ba.account_type              as account_type
    , ba.aum_classification        as aum_classification
    , ba.model_investment_strategy as model_investment_strategy
    , ba.fee_schedule              as fee_schedule
    , ba.advisor                   as advisor
    , ba.advisor_id                as advisor_id
    , ba.advisor_id_source         as advisor_id_source
    , ba.advisor_email             as advisor_email
    , case when ba.is_discretionary = 1 then 'discretionary'
        when ba.is_discretionary = 0 then 'non-discretionary'
        when ba.is_discretionary = 2 then 'partial'
    end::text                      as discretion_status
    , ba.is_active                 as is_active
    , ba.opened_date               as opened_date
    , ba.closed_date               as closed_date
    , ba.location_code             as location_code
    , ba.office_name               as office_name
    , ba.link                      as link
    , ba.link_type                 as link_type
    , ba.link_subtype              as link_subtype
    , ba.is_institutional          as is_institutional
    , ba.is_erisa                  as is_erisa
    , ba.is_market_day             as is_market_day
    , ba.is_market_month_end       as is_market_month_end
    , ba.is_excluded               as is_excluded
    , ba.excluded_reasons          as excluded_reasons
    , ba.is_primary                as is_primary
    , 0::int                       as is_manual_account
    , 0::int                       as is_legacy
    , ba._source_loaded_at         as _source_loaded_at
    , ba._created_at               as _created_at
    , ba._extra_fields             as _extra_fields
from {{ ref('bld_accounts_institutional') }} as ba
where true
    and ba.effective_date >= '2025-01-01'

union all

-- "manual" accounts added by data management
select
    ma.effective_date::date                   as effective_date
    , ma.system_name::text(500)               as system_name
    , ma.system_instance::text(500)           as system_instance
    , ma.system_key::text(500)                as system_key
    , ma.firm_source::text(500)               as firm_source
    , ma.account_number_formatted::text(500)  as account_number_formatted
    , ma.account_number::text(500)            as account_number
    , ma.account_number::text                 as __account_key
    , ma.account_value::number(18 , 2)        as account_value
    , ma.account_id_crm::text(500)            as account_id_crm
    , ma.account_id_pms::text(500)            as account_id_pms
    , ma.account_name::text(500)              as account_name
    , ma.client_id_crm::text(500)             as client_id_crm
    , ma.client_id_pms::text(500)             as client_id_pms
    , ma.client_name::text(500)               as client_name
    , ma.custodian::text(500)                 as custodian
    , ma.account_type::text(500)              as account_type
    , ma.aum_classification::text(500)        as aum_classification
    , ma.model_investment_strategy::text(500) as model_investment_strategy
    , ma.fee_schedule::text(500)              as fee_schedule
    , ma.advisor::text(500)                   as advisor
    , ma.advisor_id::text                     as advisor_id
    , ma.advisor_id_source::text              as advisor_id_source
    , ma.advisor_email::text                  as advisor_email
    , ma.discretion_status::text              as discretion_status
    , ma.is_active::int                       as is_active
    , ma.opened_date::date                    as opened_date
    , ma.closed_date::date                    as closed_date
    , ma.location_code::text(500)             as location_code
    , ma.office_name::text(500)               as office_name
    , ma.link::text(500)                      as link
    , ma.link_type::text(500)                 as link_type
    , ma.link_subtype::text(500)              as link_subtype
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

-- account from legacy masters pipeline prior to 2025
select
    la.effective_date              as effective_date
    , la.system_name               as system_name
    , la.system_instance           as system_instance
    , la.system_key                as system_key
    , la.firm_source               as firm_source
    , la.account_number_formatted  as account_number_formatted
    , la.account_number            as account_number
    , la.__account_key             as __account_key
    , la.account_value             as account_value
    , la.account_id_crm            as account_id_crm
    , la.account_id_pms            as account_id_pms
    , la.account_name              as account_name
    , la.client_id_crm             as client_id_crm
    , la.client_id_pms             as client_id_pms
    , la.client_name               as client_name
    , la.custodian                 as custodian
    , la.account_type              as account_type
    , la.aum_classification        as aum_classification
    , la.model_investment_strategy as model_investment_strategy
    , la.fee_schedule              as fee_schedule
    , la.advisor                   as advisor
    , la.advisor_id                as advisor_id
    , la.advisor_id_source         as advisor_id_source
    , la.advisor_email             as advisor_email
    , la.discretion_status         as discretion_status
    , la.is_active                 as is_active
    , la.opened_date               as opened_date
    , la.closed_date               as closed_date
    , la.location_code             as location_code
    , la.office_name               as office_name
    , la.link                      as link
    , la.link_type                 as link_type
    , la.link_subtype              as link_subtype
    , la.is_institutional          as is_institutional
    , la.is_erisa                  as is_erisa
    , la.is_market_day             as is_market_day
    , la.is_market_month_end       as is_market_month_end
    , la.is_excluded               as is_excluded
    , la.excluded_reasons          as excluded_reasons
    , la.is_primary                as is_primary
    , la.is_manual_account         as is_manual_account
    , la.is_legacy                 as is_legacy
    , la._source_loaded_at         as _source_loaded_at
    , la._created_at               as _created_at
    , la._extra_fields             as _extra_fields
from {{ ref('stg_legacy_accounts') }} as la
