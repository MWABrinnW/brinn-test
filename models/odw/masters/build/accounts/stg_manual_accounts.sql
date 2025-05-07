select
    effective_date::date                        as effective_date
    , lower(json:system_name::text(200))        as system_name
    , lower(json:system_instance::text(200))    as system_instance
    , lower(json:system_key::text(200))         as system_key
    , json:firm_source::text(200)               as firm_source
    , json:account_number_formatted::text(200)  as account_number_formatted
    , json:account_number::text(200)            as account_number
    , json:account_value::number(18 , 2)        as account_value
    , json:account_id_crm::text(200)            as account_id_crm
    , json:account_id_pms::text(200)            as account_id_pms
    , json:account_name::text(200)              as account_name
    , json:client_id_crm::text(200)             as client_id_crm
    , json:client_id_pms::text(200)             as client_id_pms
    , json:client_name::text(200)               as client_name
    , json:custodian::text(200)                 as custodian
    , json:account_type::text(200)              as account_type
    , json:aum_classification::text(200)        as aum_classification
    , json:model_investment_strategy::text(200) as model_investment_strategy
    , json:fee_schedule::text(200)              as fee_schedule
    , json:advisor::text(200)                   as advisor
    , json:advisor_id::text                     as advisor_id
    , json:advisor_id_source::text              as advisor_id_source
    , json:advisor_email::text                  as advisor_email
    , lower(json:discretion_status)::text       as discretion_status
    , json:is_active::int                       as is_active
    , json:opened_date::date                    as opened_date
    , json:closed_date::date                    as closed_date
    , json:location_code::text(200)             as location_code
    , json:office_name::text(200)               as office_name
    , json:link::text(200)                      as link
    , json:link_type::text(200)                 as link_type
    , json:link_subtype::text(200)              as link_subtype
    , json:legacy_system_name::text(200)        as legacy_system_name
    , json:is_institutional::int                as is_institutional
    , json:is_erisa::int                        as is_erisa
    , json:is_market_day::int                   as is_market_day
    , json:is_market_month_end::int             as is_market_month_end
    , json:is_excluded::int                     as is_excluded
    , json:excluded_reasons::text               as excluded_reasons
    , 1::int                                    as is_manual_account
    , _created_at::datetime                     as _created_at
    , null::variant                             as _extra_fields
from {{ source('manual', 'accounts_manual') }}
