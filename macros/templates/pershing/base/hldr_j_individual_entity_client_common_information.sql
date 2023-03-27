{%- macro hldr_j_individual_entity_client_common_information(src) -%}

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
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as naturalnonnatural_indicator
, trim(nullif(substring(content, 133, 1), '0'))::varchar(1) as client_name_type_format
, trim(nullif(substring(content, 134, 4), '0000'))::varchar(4) as prefix
, trim(nullif(substring(content, 138, 32), '00000000000000000000000000000000'))::varchar(32) as individual_first_name
, trim(nullif(substring(content, 170, 32), '00000000000000000000000000000000'))::varchar(32) as individual_middle_name
, trim(nullif(substring(content, 202, 32), '00000000000000000000000000000000'))::varchar(32) as individual_last_name
, trim(nullif(substring(content, 234, 4), '0000'))::varchar(4) as suffix
, trim(nullif(substring(content, 238, 32), '00000000000000000000000000000000'))::varchar(32) as freeform_line_1
, trim(nullif(substring(content, 270, 32), '00000000000000000000000000000000'))::varchar(32) as freeform_line_2
, trim(nullif(substring(content, 302, 32), '00000000000000000000000000000000'))::varchar(32) as freeform_line_3
, trim(nullif(substring(content, 334, 32), '00000000000000000000000000000000'))::varchar(32) as freeform_line_4
, trim(nullif(substring(content, 366, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 367, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 371, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 399, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1
, trim(nullif(substring(content, 431, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2
, trim(nullif(substring(content, 463, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3
, trim(nullif(substring(content, 495, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4
, trim(nullif(substring(content, 527, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 542, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 544, 15), '000000000000000'))::varchar(15) as zippostal_code
, trim(nullif(substring(content, 559, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city
, trim(nullif(substring(content, 591, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 593, 8), '00000000'))::varchar(8) as reserved_3
, trim(nullif(substring(content, 601, 1), '0'))::varchar(1) as special_handling_indicator_2
, trim(nullif(substring(content, 602, 4), '0000'))::varchar(4) as attention_line_prefix_2
, trim(nullif(substring(content, 606, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_2
, trim(nullif(substring(content, 634, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_2
, trim(nullif(substring(content, 666, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_2
, trim(nullif(substring(content, 698, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_2
, trim(nullif(substring(content, 730, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_2
, trim(nullif(substring(content, 762, 15), '000000000000000'))::varchar(15) as city_2
, trim(nullif(substring(content, 777, 2), '00'))::varchar(2) as state_2
, trim(nullif(substring(content, 779, 15), '000000000000000'))::varchar(15) as zippostal_code_2
, trim(nullif(substring(content, 794, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city_2
, trim(nullif(substring(content, 826, 2), '00'))::varchar(2) as country_code_2
-- , trim(nullif(substring(content, 828, 8), '00000000'))::varchar(8) as reserved_4
, trim(nullif(substring(content, 836, 1), '0'))::varchar(1) as telephone_type_id_1
, trim(nullif(substring(content, 837, 1), '0'))::varchar(1) as usinternational_phone_indicator_1
, trim(nullif(substring(content, 838, 5), '00000'))::varchar(5) as country_calling_code_1
, trim(nullif(substring(content, 843, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_1
, trim(nullif(substring(content, 903, 7), '0000000'))::varchar(7) as telephone_extension_1
, trim(nullif(substring(content, 910, 2), '00'))::varchar(2) as associated_country_code_1
-- , trim(nullif(substring(content, 912, 7), '0000000'))::varchar(7) as reserved_5
, trim(nullif(substring(content, 919, 1), '0'))::varchar(1) as telephone_type_id_2
, trim(nullif(substring(content, 920, 1), '0'))::varchar(1) as usinternational_phone_indicator_2
, trim(nullif(substring(content, 921, 5), '00000'))::varchar(5) as country_calling_code_2
, trim(nullif(substring(content, 926, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_2
, trim(nullif(substring(content, 986, 7), '0000000'))::varchar(7) as telephone_extension_2
, trim(nullif(substring(content, 993, 2), '00'))::varchar(2) as associated_country_code_2
-- , trim(nullif(substring(content, 995, 7), '0000000'))::varchar(7) as reserved_6
, trim(nullif(substring(content, 1002, 1), '0'))::varchar(1) as telephone_type_id_3
, trim(nullif(substring(content, 1003, 1), '0'))::varchar(1) as usinternational_phone_indicator_3
, trim(nullif(substring(content, 1004, 5), '00000'))::varchar(5) as country_calling_code_3
, trim(nullif(substring(content, 1009, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_3
, trim(nullif(substring(content, 1069, 7), '0000000'))::varchar(7) as telephone_extension_3
, trim(nullif(substring(content, 1076, 2), '00'))::varchar(2) as associated_country_code_3
-- , trim(nullif(substring(content, 1078, 7), '0000000'))::varchar(7) as reserved_7
, trim(nullif(substring(content, 1085, 1), '0'))::varchar(1) as telephone_type_id_4
, trim(nullif(substring(content, 1086, 1), '0'))::varchar(1) as usinternational_phone_indicator_4
, trim(nullif(substring(content, 1087, 5), '00000'))::varchar(5) as country_calling_code_4
, trim(nullif(substring(content, 1092, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_4
, trim(nullif(substring(content, 1152, 7), '0000000'))::varchar(7) as telephone_extension_4
, trim(nullif(substring(content, 1159, 2), '00'))::varchar(2) as associated_country_code_4
-- , trim(nullif(substring(content, 1161, 7), '0000000'))::varchar(7) as reserved_8
, trim(nullif(substring(content, 1168, 1), '0'))::varchar(1) as telephone_type_id_5
, trim(nullif(substring(content, 1169, 1), '0'))::varchar(1) as usinternational_phone_indicator_5
, trim(nullif(substring(content, 1170, 5), '00000'))::varchar(5) as country_calling_code_5
, trim(nullif(substring(content, 1175, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_5
, trim(nullif(substring(content, 1235, 7), '0000000'))::varchar(7) as telephone_extension_5
, trim(nullif(substring(content, 1242, 2), '00'))::varchar(2) as associated_country_code_5
-- , trim(nullif(substring(content, 1244, 7), '0000000'))::varchar(7) as reserved_9
, trim(nullif(substring(content, 1251, 1), '0'))::varchar(1) as telephone_type_id_6
, trim(nullif(substring(content, 1252, 1), '0'))::varchar(1) as usinternational_phone_indicator_6
, trim(nullif(substring(content, 1253, 5), '00000'))::varchar(5) as country_calling_code_6
, trim(nullif(substring(content, 1258, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_6
, trim(nullif(substring(content, 1318, 7), '0000000'))::varchar(7) as telephone_extension_6
, trim(nullif(substring(content, 1325, 2), '00'))::varchar(2) as associated_country_code_6
-- , trim(nullif(substring(content, 1327, 7), '0000000'))::varchar(7) as reserved_10
, trim(nullif(substring(content, 1334, 1), '0'))::varchar(1) as telephone_type_id_7
, trim(nullif(substring(content, 1335, 1), '0'))::varchar(1) as usinternational_phone_indicator_7
, trim(nullif(substring(content, 1336, 5), '00000'))::varchar(5) as country_calling_code_7
, trim(nullif(substring(content, 1341, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_7
, trim(nullif(substring(content, 1401, 7), '0000000'))::varchar(7) as telephone_extension_7
, trim(nullif(substring(content, 1408, 2), '00'))::varchar(2) as associated_country_code_7
-- , trim(nullif(substring(content, 1410, 7), '0000000'))::varchar(7) as reserved_11
, trim(nullif(substring(content, 1417, 1), '0'))::varchar(1) as telephone_type_id_8
, trim(nullif(substring(content, 1418, 1), '0'))::varchar(1) as usinternational_phone_indicator_8
, trim(nullif(substring(content, 1419, 5), '00000'))::varchar(5) as country_calling_code_8
, trim(nullif(substring(content, 1424, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_8
, trim(nullif(substring(content, 1484, 7), '0000000'))::varchar(7) as telephone_extension_8
, trim(nullif(substring(content, 1491, 2), '00'))::varchar(2) as associated_country_code_8
-- , trim(nullif(substring(content, 1493, 7), '0000000'))::varchar(7) as reserved_12
, trim(nullif(substring(content, 1500, 170), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(170) as reserved_for_additional_phone_numbers
-- , trim(nullif(substring(content, 1670, 2), '00'))::varchar(2) as reserved_13
, trim(nullif(substring(content, 1672, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as email_address_1
-- , trim(nullif(substring(content, 1722, 208), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(208) as reserved_14
, trim(nullif(substring(content, 1930, 1), '0'))::varchar(1) as confirmation_receipt_indicator
, trim(nullif(substring(content, 1931, 1), '0'))::varchar(1) as statement_receipt_indicator
, trim(nullif(substring(content, 1932, 1), '0'))::varchar(1) as proxy_indicator
, trim(nullif(substring(content, 1933, 1), '0'))::varchar(1) as joint_account_incomenet_worth_indicator
, to_number(nullif(nullif(trim(substring(content, 1934, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_annual_income_amount
, to_number(nullif(nullif(trim(substring(content, 1952, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_annual_income_amount
, to_number(nullif(nullif(trim(substring(content, 1970, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_net_worth_amount
, to_number(nullif(nullif(trim(substring(content, 1988, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_net_worth_amount
, trim(nullif(substring(content, 2006, 1), '0'))::varchar(1) as consolidated_liquid_net_worth_indicator
, to_number(nullif(nullif(trim(substring(content, 2007, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_liquid_net_worth_amount
, to_number(nullif(nullif(trim(substring(content, 2025, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_liquid_net_worth_amount
, trim(nullif(substring(content, 2043, 4), '0000'))::varchar(4) as tax_bracket
, to_number(nullif(nullif(trim(substring(content, 2047, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_retirement_assets
, to_number(nullif(nullif(trim(substring(content, 2065, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_retirement_assets
, nullif(nullif(trim(substring(content, 2083, 4)), '0000'), '')::int as retirement_year
-- , trim(nullif(substring(content, 2087, 4), '0000'))::varchar(4) as not_used_3
, to_number(nullif(nullif(trim(substring(content, 2091, 18)), '000000000000000000'), '')) / power(10, 02)::number as annual_compensation_low
, to_number(nullif(nullif(trim(substring(content, 2109, 18)), '000000000000000000'), '')) / power(10, 02)::number as annual_compensation_high
, trim(nullif(substring(content, 2127, 1), '0'))::varchar(1) as primary_mail_recipient_indicator
-- , trim(nullif(substring(content, 2128, 372), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(372) as not_used_4
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'J'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
