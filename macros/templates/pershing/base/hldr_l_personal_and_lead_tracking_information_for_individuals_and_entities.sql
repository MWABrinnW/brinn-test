{%- macro hldr_l_personal_and_lead_tracking_information_for_individuals_and_entities(src) -%}

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
, trim(nullif(substring(content, 132, 2), '00'))::varchar(2) as country_of_primary_citizenship
, trim(nullif(substring(content, 134, 2), '00'))::varchar(2) as country_of_incorporation_or_organization
, trim(nullif(substring(content, 136, 2), '00'))::varchar(2) as country_of_headquarters
, trim(nullif(substring(content, 138, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_1
, trim(nullif(substring(content, 140, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_2
, trim(nullif(substring(content, 142, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_3
, trim(nullif(substring(content, 144, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_4
, trim(nullif(substring(content, 146, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_5
, trim(nullif(substring(content, 148, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_6
, trim(nullif(substring(content, 150, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_7
, trim(nullif(substring(content, 152, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_8
, trim(nullif(substring(content, 154, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_9
, trim(nullif(substring(content, 156, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_10
, trim(nullif(substring(content, 158, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_11
, trim(nullif(substring(content, 160, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_12
, trim(nullif(substring(content, 162, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_13
, trim(nullif(substring(content, 164, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_14
, trim(nullif(substring(content, 166, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_15
, trim(nullif(substring(content, 168, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_16
, trim(nullif(substring(content, 170, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_17
, trim(nullif(substring(content, 172, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_18
, trim(nullif(substring(content, 174, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_19
, trim(nullif(substring(content, 176, 2), '00'))::varchar(2) as country_of_ongoing_business_activities_20
-- , trim(nullif(substring(content, 178, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_3
, trim(nullif(substring(content, 218, 2), '00'))::varchar(2) as additional_country_of_citizenship_1
, trim(nullif(substring(content, 220, 2), '00'))::varchar(2) as additional_country_of_citizenship_2
, trim(nullif(substring(content, 222, 2), '00'))::varchar(2) as additional_country_of_citizenship_3
, trim(nullif(substring(content, 224, 2), '00'))::varchar(2) as additional_country_of_citizenship_4
, trim(nullif(substring(content, 226, 2), '00'))::varchar(2) as additional_country_of_citizenship_5
, trim(nullif(substring(content, 228, 2), '00'))::varchar(2) as country_of_residence
, trim(nullif(substring(content, 230, 1), '0'))::varchar(1) as disregarded_entity
, trim(nullif(substring(content, 231, 10), '0000000000'))::varchar(10) as participant_short_name_for_regarded_entity_only
, trim(nullif(substring(content, 241, 1), '0'))::varchar(1) as u
, trim(nullif(substring(content, 242, 2), '00'))::varchar(2) as country_of_birth
, trim(nullif(substring(content, 244, 1), '0'))::varchar(1) as tax_id_type
, trim(nullif(substring(content, 245, 20), '00000000000000000000'))::varchar(20) as tax_idforeign_tin
, trim(nullif(substring(content, 265, 2), '00'))::varchar(2) as tax_id_of_issuing_country
, trim(nullif(substring(content, 267, 1), '0'))::varchar(1) as discretion_exercised
-- , trim(nullif(substring(content, 268, 1), '0'))::varchar(1) as reserved_4
, trim(nullif(substring(content, 269, 4), '0000'))::varchar(4) as identity_verification_method
, trim(nullif(substring(content, 273, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as id_verification_comments_1
, trim(nullif(substring(content, 323, 4), '0000'))::varchar(4) as type_of_unexpired_id_1
, trim(nullif(substring(content, 327, 32), '00000000000000000000000000000000'))::varchar(32) as unexpired_id_number_1_or_corporate_business_id_number
, trim(nullif(substring(content, 359, 80), '00000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(80) as issuer_1
, trim(nullif(substring(content, 439, 2), '00'))::varchar(2) as country_of_unexpired_id_1_or_country_of_incorporation
, trim(nullif(substring(content, 441, 2), '00'))::varchar(2) as stateprovince_of_unexpired_id_1_or_stateprovince_of
, try_to_date(nullif(substring(content, 443, 8), '00000000'), 'YYYYMMDD')::date as issue_date_of_unexpired_id_1_or_formed_on_date
, try_to_date(nullif(substring(content, 451, 8), '00000000'), 'YYYYMMDD')::date as expiration_date_of_unexpired_id_1
, trim(nullif(substring(content, 459, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as id_verification_comments_2
, trim(nullif(substring(content, 509, 4), '0000'))::varchar(4) as type_of_unexpired_id_2
, trim(nullif(substring(content, 513, 32), '00000000000000000000000000000000'))::varchar(32) as unexpired_id_number_2
, trim(nullif(substring(content, 545, 80), '00000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(80) as issuer_2
, trim(nullif(substring(content, 625, 2), '00'))::varchar(2) as country_of_unexpired_id_2
, trim(nullif(substring(content, 627, 2), '00'))::varchar(2) as stateprovince_of_unexpired_id_2
, try_to_date(nullif(substring(content, 629, 8), '00000000'), 'YYYYMMDD')::date as issue_date_of_unexpired_id_2
, try_to_date(nullif(substring(content, 637, 8), '00000000'), 'YYYYMMDD')::date as expiration_date_of_unexpired_id_2
, try_to_date(nullif(substring(content, 645, 8), '00000000'), 'YYYYMMDD')::date as date_of_birth
, try_to_date(nullif(substring(content, 653, 8), '00000000'), 'YYYYMMDD')::date as date_of_death
-- , trim(nullif(substring(content, 661, 1), '0'))::varchar(1) as reserved_5
, trim(nullif(substring(content, 662, 2), '00'))::varchar(2) as primary_holder_relationship_to_decedent_beneficiary
, trim(nullif(substring(content, 664, 2), '00'))::varchar(2) as relation_to_primary_holder_code
, to_number(nullif(nullif(trim(substring(content, 666, 8)), '00000000'), '')) / power(10, 03)::number as beneficiary_percent_allocation
, trim(nullif(substring(content, 674, 1), '0'))::varchar(1) as per_stirpes_beneficiary_designation
, trim(nullif(substring(content, 675, 1), '0'))::varchar(1) as specified_adult_indicator
, trim(nullif(substring(content, 676, 1), '0'))::varchar(1) as gender
, trim(nullif(substring(content, 677, 1), '0'))::varchar(1) as marital_status
, nullif(nullif(trim(substring(content, 678, 6)), '000000'), '')::int as since_when_have_you_known_the_client
, nullif(nullif(trim(substring(content, 684, 2)), '00'), '')::int as number_of_dependents
, trim(nullif(substring(content, 686, 1), '0'))::varchar(1) as has_investment_professional_met_with_the_client
, try_to_date(nullif(substring(content, 687, 8), '00000000'), 'YYYYMMDD')::date as reserved_for_client_meeting_date
, trim(nullif(substring(content, 695, 30), '000000000000000000000000000000'))::varchar(30) as reserved_for_client_meeting_location
, trim(nullif(substring(content, 725, 32), '00000000000000000000000000000000'))::varchar(32) as mothers_maiden_name
, trim(nullif(substring(content, 757, 4), '0000'))::varchar(4) as security_question_code
, trim(nullif(substring(content, 761, 30), '000000000000000000000000000000'))::varchar(30) as security_question_answer
, trim(nullif(substring(content, 791, 8), '00000000'))::varchar(8) as large_trader_id_prefix
-- , trim(nullif(substring(content, 799, 2), '00'))::varchar(2) as reserved_6
, trim(nullif(substring(content, 801, 4), '0000'))::varchar(4) as large_trader_id_suffix
-- , trim(nullif(substring(content, 805, 10), '0000000000'))::varchar(10) as reserved_7
, trim(nullif(substring(content, 815, 4), '0000'))::varchar(4) as education_level
, trim(nullif(substring(content, 819, 30), '000000000000000000000000000000'))::varchar(30) as education_level_2
, trim(nullif(substring(content, 849, 254), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(254) as client_long_name
, trim(nullif(substring(content, 1103, 4), '0000'))::varchar(4) as lead_tracking_source
, trim(nullif(substring(content, 1107, 30), '000000000000000000000000000000'))::varchar(30) as lead_tracking_source_2
, trim(nullif(substring(content, 1137, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_company_name
, trim(nullif(substring(content, 1169, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_entity_name
, trim(nullif(substring(content, 1201, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_first_name
, trim(nullif(substring(content, 1233, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_middle_name
, trim(nullif(substring(content, 1265, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_last_name
, trim(nullif(substring(content, 1297, 2), '00'))::varchar(2) as lead_tracking_family_relationship_code
-- , trim(nullif(substring(content, 1299, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 1301, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_relationship
, trim(nullif(substring(content, 1333, 32), '00000000000000000000000000000000'))::varchar(32) as lead_tracking_business_group
, trim(nullif(substring(content, 1365, 18), '000000000000000000'))::varchar(18) as lead_tracking_account_number
, trim(nullif(substring(content, 1383, 70), '0000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(70) as lead_tracking_telephone_number
, nullif(nullif(trim(substring(content, 1453, 4)), '0000'), '')::int as since_when_have_you_known_the_referring_party
-- , trim(nullif(substring(content, 1457, 4), '0000'))::varchar(4) as not_used_4
, trim(nullif(substring(content, 1461, 30), '000000000000000000000000000000'))::varchar(30) as name_of_individual
, trim(nullif(substring(content, 1550, 20), '0' * 20))::varchar(20) as foreign_tax_identification_number
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'L'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
