{%- macro hldr_k_entity_and_role_registration_specific_client_information(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_codes
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 25, 4), '0000'))::varchar(4) as investment_professional_ip_number
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_2
, trim(nullif(substring(content, 41, 9), '000000000'))::varchar(9) as introducing_firm
, trim(nullif(substring(content, 50, 20), '00000000000000000000'))::varchar(20) as reserved_for_additional_hierarchical_levels
, trim(nullif(substring(content, 70, 1), '0'))::varchar(1) as record_transaction_code
, trim(nullif(substring(content, 71, 3), '000'))::varchar(3) as secondary_sequence_number
-- , trim(nullif(substring(content, 74, 2), '00'))::varchar(2) as reserved
, trim(nullif(substring(content, 76, 3), '000'))::varchar(3) as client_type
, trim(nullif(substring(content, 79, 4), '0000'))::varchar(4) as client_role
, trim(nullif(substring(content, 83, 20), '00000000000000000000'))::varchar(20) as external_client_id_supplied_by_customer
, trim(nullif(substring(content, 103, 9), '000000000'))::varchar(9) as internal_pershing_assigned_client_id
-- , trim(nullif(substring(content, 112, 20), '00000000000000000000'))::varchar(20) as reserved_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as client_an_entity_organized_outside_the_us
, trim(nullif(substring(content, 133, 1), '0'))::varchar(1) as offshore_entity
, trim(nullif(substring(content, 134, 4), '0000'))::varchar(4) as type_of_offshore_entity
, trim(nullif(substring(content, 138, 4), '0000'))::varchar(4) as customer_bank_code
, trim(nullif(substring(content, 142, 6), '000000'))::varchar(6) as north_american_industry_classification_system_naics
, trim(nullif(substring(content, 148, 128), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(128) as naics_code_description
, trim(nullif(substring(content, 276, 1), '0'))::varchar(1) as aware_of_any_information_that_this_customer_poses_a
, to_number(nullif(nullif(trim(substring(content, 277, 18)), '000000000000000000'), '')) / power(10, 02)::number as current_minimum_valuation_of_business
, to_number(nullif(nullif(trim(substring(content, 295, 18)), '000000000000000000'), '')) / power(10, 02)::number as current_maximum_valuation_of_business
, to_number(nullif(nullif(trim(substring(content, 313, 8)), '00000000'), '')) / power(10, 03)::number as percentage_ownership
, trim(nullif(substring(content, 321, 4), '0000'))::varchar(4) as nature_of_business_code
, trim(nullif(substring(content, 325, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text
, nullif(nullif(trim(substring(content, 375, 8)), '00000000'), '')::int as number_of_employees
, nullif(nullif(trim(substring(content, 383, 8)), '00000000'), '')::int as number_of_clients
, to_number(nullif(nullif(trim(substring(content, 391, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_assets_under_management
, to_number(nullif(nullif(trim(substring(content, 409, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_assets_under_management
, trim(nullif(substring(content, 427, 1), '0'))::varchar(1) as does_customer_derive_substantial_income_from_a_high
, trim(nullif(substring(content, 428, 2), '00'))::varchar(2) as high_risk_jurisdiction_1
, trim(nullif(substring(content, 430, 2), '00'))::varchar(2) as high_risk_jurisdiction_2
, trim(nullif(substring(content, 432, 2), '00'))::varchar(2) as high_risk_jurisdiction_3
, trim(nullif(substring(content, 434, 2), '00'))::varchar(2) as high_risk_jurisdiction_4
, trim(nullif(substring(content, 436, 2), '00'))::varchar(2) as high_risk_jurisdiction_5
, trim(nullif(substring(content, 438, 1), '0'))::varchar(1) as client_has_assets
, trim(nullif(substring(content, 439, 2), '00'))::varchar(2) as restricted_country_1
, trim(nullif(substring(content, 441, 2), '00'))::varchar(2) as restricted_country_2
, trim(nullif(substring(content, 443, 2), '00'))::varchar(2) as restricted_country_3
, trim(nullif(substring(content, 445, 2), '00'))::varchar(2) as restricted_country_4
, trim(nullif(substring(content, 447, 2), '00'))::varchar(2) as restricted_country_5
, trim(nullif(substring(content, 449, 1), '0'))::varchar(1) as subsidiary_of
, trim(nullif(substring(content, 450, 128), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(128) as name_of_approved_regulator
, trim(nullif(substring(content, 578, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as name_of_parentaffiliate
, trim(nullif(substring(content, 628, 2), '00'))::varchar(2) as country_of_parentaffiliate
, trim(nullif(substring(content, 630, 2), '00'))::varchar(2) as state_of_parentaffiliate
, trim(nullif(substring(content, 632, 1), '0'))::varchar(1) as subsidiary_of_2
, trim(nullif(substring(content, 633, 128), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(128) as name_of_approved_stock_exchange
, trim(nullif(substring(content, 761, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as name_of_parentaffiliate_2
, trim(nullif(substring(content, 811, 2), '00'))::varchar(2) as country_location_of_parentaffiliate
, trim(nullif(substring(content, 813, 2), '00'))::varchar(2) as state_location_of_parentaffiliate
, trim(nullif(substring(content, 815, 1), '0'))::varchar(1) as entity_is_listed
, trim(nullif(substring(content, 816, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as exchange
, trim(nullif(substring(content, 876, 1), '0'))::varchar(1) as entity_is_government_regulated
, trim(nullif(substring(content, 877, 4), '0000'))::varchar(4) as regulator_name_code_1
, trim(nullif(substring(content, 881, 30), '000000000000000000000000000000'))::varchar(30) as regulator_id_1
, trim(nullif(substring(content, 911, 4), '0000'))::varchar(4) as regulator_name_code_2
, trim(nullif(substring(content, 915, 30), '000000000000000000000000000000'))::varchar(30) as regulator_id_2
, trim(nullif(substring(content, 945, 4), '0000'))::varchar(4) as regulator_name_code_3
, trim(nullif(substring(content, 949, 30), '000000000000000000000000000000'))::varchar(30) as regulator_id_3
, trim(nullif(substring(content, 979, 4), '0000'))::varchar(4) as regulator_name_code_4
, trim(nullif(substring(content, 983, 30), '000000000000000000000000000000'))::varchar(30) as regulator_id_4
, trim(nullif(substring(content, 1013, 4), '0000'))::varchar(4) as document_code
, try_to_date(nullif(substring(content, 1017, 8), '00000000'), 'YYYYMMDD')::date as document_received_date
, try_to_date(nullif(substring(content, 1025, 8), '00000000'), 'YYYYMMDD')::date as document_expiration_date
, trim(nullif(substring(content, 1033, 1), '0'))::varchar(1) as type_of_trust
, try_to_date(nullif(substring(content, 1034, 8), '00000000'), 'YYYYMMDD')::date as date_trust_established
, try_to_date(nullif(substring(content, 1042, 8), '00000000'), 'YYYYMMDD')::date as trust_amendment_date
, trim(nullif(substring(content, 1050, 1), '0'))::varchar(1) as trustee_independent_action
, trim(nullif(substring(content, 1051, 2), '00'))::varchar(2) as country_governing_trust_administration
, trim(nullif(substring(content, 1053, 2), '00'))::varchar(2) as state_governing_trust_administration
, trim(nullif(substring(content, 1055, 1), '0'))::varchar(1) as crummey_power_provision_applied_to_this_trust
, trim(nullif(substring(content, 1056, 1), '0'))::varchar(1) as employee_benefit_account_flag
, trim(nullif(substring(content, 1057, 4), '0000'))::varchar(4) as creator_of_trust_a_resident_of_new_york_city_or_yonkers
, trim(nullif(substring(content, 1061, 4), '0000'))::varchar(4) as creator_of_trust_a_resident_of_new_york_city_or_yonkers_2
, trim(nullif(substring(content, 1065, 1), '0'))::varchar(1) as blind_trust_indicator
, trim(nullif(substring(content, 1066, 1), '0'))::varchar(1) as revocability_of_trust
, nullif(nullif(trim(substring(content, 1067, 2)), '00'), '')::int as minimum_number_of_trustees_required_for_consent
, trim(nullif(substring(content, 1069, 1), '0'))::varchar(1) as establish_and_maintain_an_asset_management_account_with_check_writing
, trim(nullif(substring(content, 1070, 1), '0'))::varchar(1) as trust_allows_use_of_attorneyinfact_andor_power_of_attorney
, trim(nullif(substring(content, 1071, 1), '0'))::varchar(1) as collateralization_of_trust_permitted
, trim(nullif(substring(content, 1072, 1), '0'))::varchar(1) as maintain_margin_accounts_and_borrows_money_to_purchase_securities_on_margin
, trim(nullif(substring(content, 1073, 1), '0'))::varchar(1) as sell_securities_that_trust_does_not_own_short_sales_and_borrow_securities_to
, trim(nullif(substring(content, 1074, 1), '0'))::varchar(1) as engage_in_purchase_of_call_options
, trim(nullif(substring(content, 1075, 1), '0'))::varchar(1) as engage_in_covered_call_writing
, trim(nullif(substring(content, 1076, 1), '0'))::varchar(1) as engage_in_purchase_of_put_options
, trim(nullif(substring(content, 1077, 1), '0'))::varchar(1) as engage_in_option_spread_transactions
, trim(nullif(substring(content, 1078, 1), '0'))::varchar(1) as purchase_securities_which_are_deemed_to_be_speculative_investments
, trim(nullif(substring(content, 1079, 1), '0'))::varchar(1) as receive_on_behalf_of_trust_or_deliver_to_trust_or_thirdparty_monies
, trim(nullif(substring(content, 1080, 1), '0'))::varchar(1) as sell
, to_number(nullif(nullif(trim(substring(content, 1081, 5)), '00000'), '')) / power(10, 02)::number as beneficial_owners_beow_percentage_of_ownership
, trim(nullif(substring(content, 1086, 40), '0000000000000000000000000000000000000000'))::varchar(40) as position_held_of_controlling_person_cper
-- , trim(nullif(substring(content, 1126, 4), '0000'))::varchar(4) as reserved_3
, trim(nullif(substring(content, 1130, 20), '00000000000000000000'))::varchar(20) as legal_entity_identifier
, trim(nullif(substring(content, 1150, 1), '0'))::varchar(1) as articles_of_incorporation_allow_issuance_of_bearer
, trim(nullif(substring(content, 1151, 1), '0'))::varchar(1) as jurisdiction_in_which_customer_is_legally_created
, trim(nullif(substring(content, 1152, 1), '0'))::varchar(1) as customer_has_issued_bearer_shares
, to_number(nullif(nullif(trim(substring(content, 1153, 8)), '00000000'), '')) / power(10, 03)::number as percentage_of_ownership_in_bearer_shares
, trim(nullif(substring(content, 1161, 1), '0'))::varchar(1) as shares_held_at_a_custodian
, trim(nullif(substring(content, 1162, 1), '0'))::varchar(1) as custodian_agrees_to_notify_ibd_if_shares_change
, trim(nullif(substring(content, 1163, 20), '00000000000000000000'))::varchar(20) as iardcrd_number
, trim(nullif(substring(content, 1183, 16), '0000000000000000'))::varchar(16) as sec_file_number
, try_to_date(nullif(substring(content, 1199, 8), '00000000'), 'YYYYMMDD')::date as _education_plan_anticipated_enrollment_date
-- , trim(nullif(substring(content, 1207, 1293), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(1293) as not_used_3
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'K'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
