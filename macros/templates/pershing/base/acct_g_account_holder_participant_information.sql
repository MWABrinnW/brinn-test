{%- macro acct_g_account_holder_participant_information(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as account_holderparticipant_transaction
, trim(nullif(substring(content, 42, 3), '000'))::varchar(3) as sequence_number
, trim(nullif(substring(content, 45, 3), '000'))::varchar(3) as account_holder_type
, trim(nullif(substring(content, 48, 4), '0000'))::varchar(4) as account_holderparticipant_1_role
, trim(nullif(substring(content, 52, 1), '0'))::varchar(1) as account_holderparticipant_1_name_type
, trim(nullif(substring(content, 53, 32), '00000000000000000000000000000000'))::varchar(32) as account_holderparticipant_1_prefixsuffix_or_entity
, trim(nullif(substring(content, 85, 32), '00000000000000000000000000000000'))::varchar(32) as account_holderparticipant_1_first_name_or_entity
, trim(nullif(substring(content, 117, 32), '00000000000000000000000000000000'))::varchar(32) as account_holderparticipant_1_middle_initialname_or
, trim(nullif(substring(content, 149, 32), '00000000000000000000000000000000'))::varchar(32) as account_holderparticipant_1_last_name_or_entity
, trim(nullif(substring(content, 181, 1), '0'))::varchar(1) as delivery_identifier
, trim(nullif(substring(content, 182, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 183, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 187, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 215, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_1_or_memo_freeform_line_5
, trim(nullif(substring(content, 247, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_2_or_memo_freeform_line_6
, trim(nullif(substring(content, 279, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_3
, trim(nullif(substring(content, 311, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_4
, iff(substring(content, 375, 2) in ('US', 'CA'), trim(nullif(substring(content, 343, 15), '000000000000000')), '')::varchar(15) as city
, iff(substring(content, 375, 2) in ('US', 'CA'), trim(nullif(substring(content, 358, 2), '00')), '')::varchar(2) as state
, iff(substring(content, 375, 2) in ('US', 'CA'), trim(nullif(substring(content, 360, 15), '000000000000000')), '')::varchar(15) as zip
, iff(substring(content, 375, 2) not in ('US', 'CA'), trim(nullif(substring(content, 343, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city
, trim(nullif(substring(content, 375, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 377, 2), '00'))::varchar(2) as not_used_4
, trim(nullif(substring(content, 379, 1), '0'))::varchar(1) as delivery_identifier_2
, trim(nullif(substring(content, 380, 1), '0'))::varchar(1) as special_handling_indicator_2
, trim(nullif(substring(content, 381, 4), '0000'))::varchar(4) as attention_line_prefix_2
, trim(nullif(substring(content, 385, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_2
, trim(nullif(substring(content, 413, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_1
, trim(nullif(substring(content, 445, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_2
, trim(nullif(substring(content, 477, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_3_2
, trim(nullif(substring(content, 509, 32), '00000000000000000000000000000000'))::varchar(32) as street_address_line_4_2
, iff(substring(content, 573, 2) in ('US', 'CA'), trim(nullif(substring(content, 541, 15), '000000000000000')), '')::varchar(15) as city_2
, iff(substring(content, 573, 2) in ('US', 'CA'), trim(nullif(substring(content, 556, 2), '00')), '')::varchar(2) as state_2
, iff(substring(content, 573, 2) in ('US', 'CA'), trim(nullif(substring(content, 558, 15), '000000000000000')), '')::varchar(15) as zip_2
, iff(substring(content, 573, 2) not in ('US', 'CA'), trim(nullif(substring(content, 541, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city_2
, trim(nullif(substring(content, 573, 2), '00'))::varchar(2) as country_code_2
-- , trim(nullif(substring(content, 575, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 577, 1), '0'))::varchar(1) as naturalnonnatural_indicator
, trim(nullif(substring(content, 578, 1), '0'))::varchar(1) as confirmation_receipt_indicator
, trim(nullif(substring(content, 579, 1), '0'))::varchar(1) as statement_receipt_indicator
, nullif(nullif(trim(substring(content, 580, 2)), '00'), '')::int as years_of_investment_experience
, trim(nullif(substring(content, 582, 1), '0'))::varchar(1) as gender
, trim(nullif(substring(content, 583, 1), '0'))::varchar(1) as proxy_indicator
, try_to_date(nullif(substring(content, 584, 8), '00000000'), 'YYYYMMDD')::date as account_holderparticipants_birth_date
, trim(nullif(substring(content, 592, 2), '00'))::varchar(2) as account_holderparticipant_primary_country_of
, trim(nullif(substring(content, 594, 2), '00'))::varchar(2) as account_holderparticipant_country_of_residence
, trim(nullif(substring(content, 596, 4), '0000'))::varchar(4) as identity_verification_method
, trim(nullif(substring(content, 600, 1), '0'))::varchar(1) as tax_id_type
, trim(nullif(substring(content, 601, 9), '000000000'))::varchar(9) as tax_id_number
, trim(nullif(substring(content, 610, 1), '0'))::varchar(1) as tax_exemption_indicator
, trim(nullif(substring(content, 611, 1), '0'))::varchar(1) as w9_on_file
, trim(nullif(substring(content, 612, 4), '0000'))::varchar(4) as customer_bank_code
, trim(nullif(substring(content, 616, 32), '00000000000000000000000000000000'))::varchar(32) as corporatebusiness_id
, trim(nullif(substring(content, 648, 2), '00'))::varchar(2) as country_of_the_formation_organization
, trim(nullif(substring(content, 650, 2), '00'))::varchar(2) as state_of_incorporationorganization
, trim(nullif(substring(content, 652, 1), '0'))::varchar(1) as employee_of_this_ibd
, trim(nullif(substring(content, 653, 1), '0'))::varchar(1) as related_to_employee_of_this_ibd
, trim(nullif(substring(content, 654, 1), '0'))::varchar(1) as employee_of_another_ibd
, trim(nullif(substring(content, 655, 1), '0'))::varchar(1) as related_to_employee_of_another_ibd
, trim(nullif(substring(content, 656, 4), '0000'))::varchar(4) as employment_status_code
, trim(nullif(substring(content, 660, 15), '000000000000000'))::varchar(15) as occupation
, trim(nullif(substring(content, 675, 4), '0000'))::varchar(4) as tax_bracket
, nullif(nullif(trim(substring(content, 679, 2)), '00'), '')::int as years_employed
, trim(nullif(substring(content, 681, 35), '00000000000000000000000000000000000'))::varchar(35) as type_of_business
, trim(nullif(substring(content, 716, 32), '00000000000000000000000000000000'))::varchar(32) as employer_name
, trim(nullif(substring(content, 748, 1), '0'))::varchar(1) as account_holderparticipant_discretion
, trim(nullif(substring(content, 749, 1), '0'))::varchar(1) as marital_status
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'G'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
