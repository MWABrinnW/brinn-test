{%- macro accf_7_account_holder_participant_level_information_for_bank_custody_trust_and_cdd_accounts(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 25, 3), '000'))::varchar(3) as investment_professional_ip_number
-- , trim(nullif(substring(content, 28, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as record_transaction_code
, trim(nullif(substring(content, 42, 3), '000'))::varchar(3) as sequence_number
, trim(nullif(substring(content, 45, 3), '000'))::varchar(3) as account_holder_type
, trim(nullif(substring(content, 48, 4), '0000'))::varchar(4) as account_holderparticipant_1_role
, trim(nullif(substring(content, 52, 1), '0'))::varchar(1) as type_of_trust
, try_to_date(nullif(substring(content, 53, 8), '00000000'), 'YYYYMMDD')::date as date_trust_established
, try_to_date(nullif(substring(content, 61, 8), '00000000'), 'YYYYMMDD')::date as trust_amendment_date
, trim(nullif(substring(content, 69, 1), '0'))::varchar(1) as trustee_independent_action
, trim(nullif(substring(content, 70, 2), '00'))::varchar(2) as country_governing_trust_administration
, trim(nullif(substring(content, 72, 2), '00'))::varchar(2) as state_governing_trust_administration
, trim(nullif(substring(content, 74, 1), '0'))::varchar(1) as crummey_power_provision_applied_to_this_trust
, trim(nullif(substring(content, 75, 1), '0'))::varchar(1) as employee_benefit_account_flag
, trim(nullif(substring(content, 76, 4), '0000'))::varchar(4) as creator_of_trust_a_resident_of_new_york_city_or_yonkers
, trim(nullif(substring(content, 80, 4), '0000'))::varchar(4) as creator_of_trust_a_resident_of_new_york_city_or_yonkers_2
, trim(nullif(substring(content, 84, 1), '0'))::varchar(1) as blind_trust_indicator
, trim(nullif(substring(content, 85, 1), '0'))::varchar(1) as revocability_of_trust
, nullif(nullif(trim(substring(content, 86, 2)), '00'), '')::int as minimum_number_of_trustees_required_for_consent
, trim(nullif(substring(content, 88, 1), '0'))::varchar(1) as establish_and_maintain_asset_management_account_with_check_writing
, trim(nullif(substring(content, 89, 1), '0'))::varchar(1) as trust_allows_use_of_attorneyinfact_andor_power_of_attorney
, trim(nullif(substring(content, 90, 1), '0'))::varchar(1) as collateralization_of_trust_permitted
, trim(nullif(substring(content, 91, 1), '0'))::varchar(1) as maintain_margin_accounts
, trim(nullif(substring(content, 92, 1), '0'))::varchar(1) as sell_securities_trust_does_not_own_short_sales_and_borrow_securities_to_facilitate
, trim(nullif(substring(content, 93, 1), '0'))::varchar(1) as engage_in_purchase_of_call_options
, trim(nullif(substring(content, 94, 1), '0'))::varchar(1) as engage_in_covered_call_writing
, trim(nullif(substring(content, 95, 1), '0'))::varchar(1) as engage_in_purchase_of_put_options
, trim(nullif(substring(content, 96, 1), '0'))::varchar(1) as engage_in_option_spread_transactions
, trim(nullif(substring(content, 97, 1), '0'))::varchar(1) as purchase_securities_which_are_deemed_to_be_speculative_investments
, trim(nullif(substring(content, 98, 1), '0'))::varchar(1) as receive_on_behalf_of_trust_or_deliver_to_trust_or_third_parties_monies
, trim(nullif(substring(content, 99, 1), '0'))::varchar(1) as sell
, nullif(nullif(trim(substring(content, 100, 3)), '000'), '')::int as beneficial_owners_beow_percentage_of_ownership
, trim(nullif(substring(content, 103, 40), '0000000000000000000000000000000000000000'))::varchar(40) as position_held_of_controlling_person_cper
, trim(nullif(substring(content, 143, 20), '00000000000000000000'))::varchar(20) as legal_entity_identifier
-- , trim(nullif(substring(content, 163, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved
, trim(nullif(substring(content, 203, 20), '00000000000000000000'))::varchar(20) as employee_id
, trim(nullif(substring(content, 223, 20), '00000000000000000000'))::varchar(20) as employee_id_2
-- , trim(nullif(substring(content, 243, 507), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(507) as not_used_4
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = '7'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
