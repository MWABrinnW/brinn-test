{%- macro hldr_q_risk_assessments_affiliations_peps_and_high_profile_client(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_codes
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
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as securitized_product_risk_awareness
, trim(nullif(substring(content, 133, 1), '0'))::varchar(1) as kyc_review_status
, try_to_date(nullif(substring(content, 134, 8), '00000000'), 'YYYYMMDD')::date as kyc_risk_rating_date
, trim(nullif(substring(content, 142, 1), '0'))::varchar(1) as employee_of_this_ibd
, trim(nullif(substring(content, 143, 20), '00000000000000000000'))::varchar(20) as employee_id
, trim(nullif(substring(content, 163, 4), '0000'))::varchar(4) as division_values_tba
-- , trim(nullif(substring(content, 167, 20), '00000000000000000000'))::varchar(20) as reserved_3
, trim(nullif(substring(content, 187, 1), '0'))::varchar(1) as related_to_employee_of_this_ibd
, trim(nullif(substring(content, 188, 32), '00000000000000000000000000000000'))::varchar(32) as employee_first_name
, trim(nullif(substring(content, 220, 32), '00000000000000000000000000000000'))::varchar(32) as employee_last_name
, trim(nullif(substring(content, 252, 4), '0000'))::varchar(4) as employee_suffix
, trim(nullif(substring(content, 256, 2), '00'))::varchar(2) as relationship_to_employee
-- , trim(nullif(substring(content, 258, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 260, 32), '00000000000000000000000000000000'))::varchar(32) as relationship
, trim(nullif(substring(content, 292, 4), '0000'))::varchar(4) as related_to_employee_of_this_ibd_division_code_values_tba
, trim(nullif(substring(content, 296, 20), '00000000000000000000'))::varchar(20) as employee_id_2
-- , trim(nullif(substring(content, 316, 1), '0'))::varchar(1) as reserved_4
, trim(nullif(substring(content, 317, 9), '000000000'))::varchar(9) as related_to_employee_of_this_ibd_employee_tax_id_number
-- , trim(nullif(substring(content, 326, 11), '00000000000'))::varchar(11) as reserved_5
, trim(nullif(substring(content, 337, 1), '0'))::varchar(1) as employee_of_another_ibd
, trim(nullif(substring(content, 338, 20), '00000000000000000000'))::varchar(20) as ibd_name
, trim(nullif(substring(content, 358, 20), '00000000000000000000'))::varchar(20) as employee_id_3
, trim(nullif(substring(content, 378, 1), '0'))::varchar(1) as related_to_employee_of_another_ibd
, trim(nullif(substring(content, 379, 4), '0000'))::varchar(4) as title_of_client_related_to_employee_of_another_ibd
, trim(nullif(substring(content, 383, 30), '000000000000000000000000000000'))::varchar(30) as clients_title
, trim(nullif(substring(content, 413, 20), '00000000000000000000'))::varchar(20) as ibd_name_2
, trim(nullif(substring(content, 433, 20), '00000000000000000000'))::varchar(20) as employee_id_4
, trim(nullif(substring(content, 453, 32), '00000000000000000000000000000000'))::varchar(32) as employee_first_name_2
, trim(nullif(substring(content, 485, 32), '00000000000000000000000000000000'))::varchar(32) as employee_last_name_2
, trim(nullif(substring(content, 517, 4), '0000'))::varchar(4) as employee_suffix_2
, trim(nullif(substring(content, 521, 2), '00'))::varchar(2) as relationship_to_employee_2
-- , trim(nullif(substring(content, 523, 2), '00'))::varchar(2) as not_used_4
, trim(nullif(substring(content, 525, 1), '0'))::varchar(1) as client_maintains_other_brokerage_accounts
, trim(nullif(substring(content, 526, 20), '00000000000000000000'))::varchar(20) as name_of_other_brokerage_firm_where_account_held
, nullif(nullif(trim(substring(content, 546, 2)), '00'), '')::int as years_of_investment_experience
, trim(nullif(substring(content, 548, 30), '000000000000000000000000000000'))::varchar(30) as other_brokerage_account_number
, trim(nullif(substring(content, 578, 1), '0'))::varchar(1) as memberemployee_or_related_to_memberemployee_of
, trim(nullif(substring(content, 579, 2), '00'))::varchar(2) as country_location_of_affiliate
, trim(nullif(substring(content, 581, 2), '00'))::varchar(2) as state_of_affiliate
, trim(nullif(substring(content, 583, 45), '000000000000000000000000000000000000000000000'))::varchar(45) as name_of_affiliation
, trim(nullif(substring(content, 628, 30), '000000000000000000000000000000'))::varchar(30) as name_of_approved_regulator_or_stock_exchange
, trim(nullif(substring(content, 658, 1), '0'))::varchar(1) as client_or_member_of_immediate_family_director
, trim(nullif(substring(content, 659, 4), '0000'))::varchar(4) as clients_title_2
, trim(nullif(substring(content, 663, 30), '000000000000000000000000000000'))::varchar(30) as clientss_title
, trim(nullif(substring(content, 693, 45), '000000000000000000000000000000000000000000000'))::varchar(45) as name_of_public_company
, trim(nullif(substring(content, 738, 16), '0000000000000000'))::varchar(16) as company_ticker_symbol
, trim(nullif(substring(content, 754, 1), '0'))::varchar(1) as client_is_senior_officer_of_a_financial_institution
, trim(nullif(substring(content, 755, 1), '0'))::varchar(1) as financial_institution_is_publicly_traded_indicator
, trim(nullif(substring(content, 756, 45), '000000000000000000000000000000000000000000000'))::varchar(45) as name_of_company
, trim(nullif(substring(content, 801, 1), '0'))::varchar(1) as employee_of_an_affiliate_of_this_brokerdealer
, trim(nullif(substring(content, 802, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as affiliation
, trim(nullif(substring(content, 852, 1), '0'))::varchar(1) as subsidiary_of
-- , trim(nullif(substring(content, 853, 20), '00000000000000000000'))::varchar(20) as reserved_6
, trim(nullif(substring(content, 873, 32), '00000000000000000000000000000000'))::varchar(32) as bank_name
, trim(nullif(substring(content, 905, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 906, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 910, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 938, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_1
, trim(nullif(substring(content, 970, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_2
, trim(nullif(substring(content, 1002, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_3
, trim(nullif(substring(content, 1034, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_4
, trim(nullif(substring(content, 1066, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 1081, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 1083, 15), '000000000000000'))::varchar(15) as zippostal_code
, trim(nullif(substring(content, 1098, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city
, trim(nullif(substring(content, 1130, 2), '00'))::varchar(2) as country_code
, trim(nullif(substring(content, 1132, 1), '0'))::varchar(1) as foreign_financial_institution
, trim(nullif(substring(content, 1133, 1), '0'))::varchar(1) as customer_a_subsidiary_of_financial_institution
, trim(nullif(substring(content, 1134, 1), '0'))::varchar(1) as private_banking_account
, trim(nullif(substring(content, 1135, 1), '0'))::varchar(1) as foreign_bank
, trim(nullif(substring(content, 1136, 1), '0'))::varchar(1) as central_bank
, trim(nullif(substring(content, 1137, 1), '0'))::varchar(1) as foreign_bank_operating_under_an_offshore_banking
, trim(nullif(substring(content, 1138, 1), '0'))::varchar(1) as foreign_bank_operating_under_banking_license_issued_by
, trim(nullif(substring(content, 1139, 1), '0'))::varchar(1) as foreign_bank_operating_under_banking_license_issued_by_2
, nullif(nullif(trim(substring(content, 1140, 2)), '00'), '')::int as how_many_peopleentities_own_10
, trim(nullif(substring(content, 1142, 1), '0'))::varchar(1) as politically_exposed_person
, trim(nullif(substring(content, 1143, 32), '00000000000000000000000000000000'))::varchar(32) as politically_exposed_person_first_name
, trim(nullif(substring(content, 1175, 32), '00000000000000000000000000000000'))::varchar(32) as politically_exposed_person_last_name
, trim(nullif(substring(content, 1207, 4), '0000'))::varchar(4) as politically_exposed_person_suffix
, trim(nullif(substring(content, 1211, 2), '00'))::varchar(2) as relationship_to_politically_exposed_person
-- , trim(nullif(substring(content, 1213, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 1215, 30), '000000000000000000000000000000'))::varchar(30) as relationship_to_politically_exposed_person_2
, trim(nullif(substring(content, 1245, 4), '0000'))::varchar(4) as reserved_for_office_held_code
, trim(nullif(substring(content, 1249, 30), '000000000000000000000000000000'))::varchar(30) as office_held
, trim(nullif(substring(content, 1279, 2), '00'))::varchar(2) as country_of_office
-- , trim(nullif(substring(content, 1281, 2), '00'))::varchar(2) as reserved_7
, trim(nullif(substring(content, 1283, 1), '0'))::varchar(1) as elected_or_appointed
, try_to_date(nullif(substring(content, 1284, 6), '000000'), 'YYYYMM')::date as term_start_date
-- , trim(nullif(substring(content, 1290, 2), '00'))::varchar(2) as reserved_8
, try_to_date(nullif(substring(content, 1292, 6), '000000'), 'YYYYMM')::date as term_end_date
-- , trim(nullif(substring(content, 1298, 2), '00'))::varchar(2) as reserved_9
, to_number(nullif(nullif(trim(substring(content, 1300, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_income_amount_derived
, to_number(nullif(nullif(trim(substring(content, 1318, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_income_amount_derived
, trim(nullif(substring(content, 1336, 1), '0'))::varchar(1) as income_derived_from_government_license_or_contracts
, trim(nullif(substring(content, 1337, 1), '0'))::varchar(1) as client_is_high_profile_individual_or_entity
, trim(nullif(substring(content, 1338, 2), '00'))::varchar(2) as relationship_to_high_profile_individual_or_entity_client
-- , trim(nullif(substring(content, 1340, 2), '00'))::varchar(2) as not_used_6
, trim(nullif(substring(content, 1342, 30), '000000000000000000000000000000'))::varchar(30) as relationship_2
, trim(nullif(substring(content, 1372, 32), '00000000000000000000000000000000'))::varchar(32) as first_name_of_high_profile_person
, trim(nullif(substring(content, 1404, 32), '00000000000000000000000000000000'))::varchar(32) as last_name_high_profile_person
, trim(nullif(substring(content, 1436, 4), '0000'))::varchar(4) as suffix_of_highprofile_person_member
, trim(nullif(substring(content, 1440, 35), '00000000000000000000000000000000000'))::varchar(35) as office_held_2
, trim(nullif(substring(content, 1475, 2), '00'))::varchar(2) as country
-- , trim(nullif(substring(content, 1477, 2), '00'))::varchar(2) as reserved_10
, to_number(nullif(nullif(trim(substring(content, 1479, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_income_amount_derived_2
, to_number(nullif(nullif(trim(substring(content, 1497, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_income_amount_derived_2
, try_to_date(nullif(substring(content, 1515, 6), '000000'), 'YYYYMM')::date as relationship_with_high_profile_person_start_date
-- , trim(nullif(substring(content, 1521, 2), '00'))::varchar(2) as reserved_11
, try_to_date(nullif(substring(content, 1523, 6), '000000'), 'YYYYMM')::date as relationship_with_high_profile_person_end_date
-- , trim(nullif(substring(content, 1529, 2), '00'))::varchar(2) as reserved_12
-- , trim(nullif(substring(content, 1531, 14), '00000000000000'))::varchar(14) as not_used_7
, trim(nullif(substring(content, 1545, 1), '0'))::varchar(1) as has_client_ever_been_accused_or_convicted_of_a_serious
, trim(nullif(substring(content, 1546, 151), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(151) as reserved_3pa
-- , trim(nullif(substring(content, 1697, 803), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(803) as not_used_8
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'Q'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
