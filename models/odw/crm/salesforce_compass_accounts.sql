{{ config(
    tags=["financials"]
) }}

-- get max effective date from bld table
with max_effective_date as (
    select max(effective_date) as max_date
    from {{ ref('bld_salesforce_compass_accounts') }}
)

-- set "is_head" for records with MAX effective date
, cte_head_accts as (
    select
        *
        , {{ col_is_head(
            reference=ref('bld_salesforce_compass_accounts'), 
            source_date_col='effective_date', 
            reference_date_col='effective_date'
        ) }}
    from {{ ref('bld_salesforce_compass_accounts') }}
    where true
        and rn_acct_num = 1
        and effective_date = (select sub_max.max_date from max_effective_date as sub_max)
)

-- set "is_head" for records with NON MAX effective dates
, cte_non_head_accts as (
    select
        *
        , 0::int as is_head
    from {{ ref('bld_salesforce_compass_accounts') }}
    where true
        and rn_acct_num = 1
        and effective_date != (select sub_max.max_date from max_effective_date as sub_max)
)

select
    effective_at
    , system_name
    , system_instance
    , system_key
    , firm_source
    , id
    , estate_item_id
    , owner_id
    , is_deleted
    , as_of_date
    , account_name
    , registrant_name
    , orion_account_id
    , account_number
    , account_number_formatted
    , account_type
    , registration_type_id
    , registration_type
    , is_qualified
    , custodian
    , custodian_key
    , is_active
    , account_value
    , opened_date
    , closed_date
    , location_name
    , record_type_id
    , created_at
    , created_by_id
    , last_modified_at
    , last_modified_by_id
    , system_modstamp_at
    , aum_classification
    , aum_classification_notes
    , is_erisa
    , is_prime_broker
    , is_discretionary
    , is_broker_dealer_account
    , is_voting_proxied
    , fee_schedule_id
    , fee_schedule
    , household_id
    , client_id
    , unique_identifier
    , household_name
    , orion_client_id
    , household_type
    , household_opened_date
    , household_location_id
    , household_location_code
    , household_accounting_id
    , household_lead_source
    , household_account_source
    , household_legal_firm
    , billing_street
    , billing_city
    , billing_state
    , billing_postal_code
    , billing_country
    , legal_street_address
    , legal_address_city
    , legal_address_state
    , legal_address_postal_code
    , mailing_street_address
    , mailing_street_address_2
    , mailing_street_address_3
    , mailing_city
    , mailing_state
    , mailing_postal_code
    , shipping_street
    , shipping_city
    , shipping_state
    , shipping_postal_code
    , shipping_country
    , other_street_address
    , other_street_address_2
    , other_city
    , other_state
    , other_postal_code
    , key_tags
    , owner_name
    , client_manager
    , client_manager_email
    , employee_number
    , employee_number_source
    , investment_strategy
    , partner_firm
    , trading_system
    , rn_acct_num
    , _fivetran_synced
    , _created_at
    , _source_loaded_at
    , effective_date
    , is_head
from cte_head_accts
union all
select
    effective_at
    , system_name
    , system_instance
    , system_key
    , firm_source
    , id
    , estate_item_id
    , owner_id
    , is_deleted
    , as_of_date
    , account_name
    , registrant_name
    , orion_account_id
    , account_number
    , account_number_formatted
    , account_type
    , registration_type_id
    , registration_type
    , is_qualified
    , custodian
    , custodian_key
    , is_active
    , account_value
    , opened_date
    , closed_date
    , location_name
    , record_type_id
    , created_at
    , created_by_id
    , last_modified_at
    , last_modified_by_id
    , system_modstamp_at
    , aum_classification
    , aum_classification_notes
    , is_erisa
    , is_prime_broker
    , is_discretionary
    , is_broker_dealer_account
    , is_voting_proxied
    , fee_schedule_id
    , fee_schedule
    , household_id
    , client_id
    , unique_identifier
    , household_name
    , orion_client_id
    , household_type
    , household_opened_date
    , household_location_id
    , household_location_code
    , household_accounting_id
    , household_lead_source
    , household_account_source
    , household_legal_firm
    , billing_street
    , billing_city
    , billing_state
    , billing_postal_code
    , billing_country
    , legal_street_address
    , legal_address_city
    , legal_address_state
    , legal_address_postal_code
    , mailing_street_address
    , mailing_street_address_2
    , mailing_street_address_3
    , mailing_city
    , mailing_state
    , mailing_postal_code
    , shipping_street
    , shipping_city
    , shipping_state
    , shipping_postal_code
    , shipping_country
    , other_street_address
    , other_street_address_2
    , other_city
    , other_state
    , other_postal_code
    , key_tags
    , owner_name
    , client_manager
    , client_manager_email
    , employee_number
    , employee_number_source
    , investment_strategy
    , partner_firm
    , trading_system
    , rn_acct_num
    , _fivetran_synced
    , _created_at
    , _source_loaded_at
    , effective_date
    , is_head
from cte_non_head_accts
order by
    effective_date::date , account_number , id
