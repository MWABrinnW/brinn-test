select
    json:"effective_date"::date              as effective_date
    , json:"system_name"::text               as system_name
    , json:"system_instance"::text           as system_instance
    , json:"system_key"::text                as system_key
    , json:"firm_source"::text               as firm_source
    , json:"account_number_formatted"::text  as account_number_formatted
    , json:"account_number"::text            as account_number
    , json:"account_value"::number(18 , 2)   as account_value
    , json:"account_id_crm"::text            as account_id_crm
    , json:"account_id_pms"::text            as account_id_pms
    , json:"account_name"::text              as account_name
    , json:"client_id_crm"::text             as client_id_crm
    , json:"client_id_pms"::text             as client_id_pms
    , json:"client_name"::text               as client_name
    , json:"custodian"::text                 as custodian
    , json:"account_type"::text              as account_type
    , json:"aum_classification"::text        as aum_classification
    , json:"model_investment_strategy"::text as model_investment_strategy
    , json:"fee_schedule"::text              as fee_schedule
    , json:"advisor"::text                   as advisor
    , json:"advisor_id"::text                as advisor_id
    , json:"advisor_id_source"::text         as advisor_id_source
    , json:"advisor_email"::text             as advisor_email
    , json:"discretion_status"::text         as discretion_status
    , json:"is_active"::text                 as is_active
    , json:"opened_date"::date               as opened_date
    , json:"closed_date"::date               as closed_date
    , json:"location_code"::text             as location_code
    , json:"office_name"::text               as office_name
    , json:"link"::text                      as link
    , json:"link_type"::text                 as link_type
    , json:"link_subtype"::text              as link_subtype
    , json:"is_institutional"::int           as is_institutional
    , json:"is_erisa"::int                   as is_erisa
    , json:"is_market_day"::int              as is_market_day
    , json:"is_market_month_end"::int        as is_market_month_end
    , json:"is_manual_account"::int          as is_manual_account
    , json:"is_legacy"::int                  as is_legacy
    , json:"_source_loaded_at"::datetime     as _source_loaded_at
    , json:"_extra_fields"::variant          as _extra_fields
    , json:"is_excluded"::int                as is_excluded
    , json:"excluded_reasons"::text          as excluded_reasons
    , _created_at::datetime                  as _created_at
    , case when _created_at = max(_created_at)
                over (partition by system_key , effective_date)
            then 1
        else 0
    end::int                                 as is_head_for_day
from {{ source('raw', 'accounts') }}
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
    -- fee schedule is in XML  format for Cambak, excluded from legacy data
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
    , la.is_manual_account
    , la.is_legacy
    , la._source_loaded_at
    , la._extra_fields
    , la.is_excluded
    , la.excluded_reasons
    , la._created_at
    , la.is_head_for_day
from {{ ref('stg_legacy_accounts') }} as la
order by effective_date , system_key , account_number
