select
    created_date                    as first_day_in_copilot
    , account_number                as account_number
    , custodian                     as custodian
    , crm_household_name            as crm_household_name
    , account_name                  as account_name
    , array_to_string(groups , ';') as groups
    , total_value                   as total_value
    , iff(is_linked = 0 , 1 , 0)    as is_orphaned
    , crm_account_id                as crm_account_id
    , crm_household_id              as crm_household_id
    , last_collected_at             as last_collected_at
from {{ ref('tradeops__accounts') }}
where system_key = 'copilot__mwa-options'
order by created_date desc
