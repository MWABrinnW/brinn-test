{%- macro hldr_n_employment_restrictions_and_ofac_information(src) -%}

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
, trim(nullif(substring(content, 132, 4), '0000'))::varchar(4) as employment_status_code
, nullif(nullif(trim(substring(content, 136, 2)), '00'), '')::int as years_employed
, trim(nullif(substring(content, 138, 35), '00000000000000000000000000000000000'))::varchar(35) as business_type
, trim(nullif(substring(content, 173, 15), '000000000000000'))::varchar(15) as employer_shortname
, trim(nullif(substring(content, 188, 9), '000000000'))::varchar(9) as employer_cusip
, trim(nullif(substring(content, 197, 9), '000000000'))::varchar(9) as employer_symbol
-- , trim(nullif(substring(content, 206, 7), '0000000'))::varchar(7) as not_used_3
, trim(nullif(substring(content, 213, 32), '00000000000000000000000000000000'))::varchar(32) as employer_name
-- , trim(nullif(substring(content, 245, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 246, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 250, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 278, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1
, trim(nullif(substring(content, 310, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2
, trim(nullif(substring(content, 342, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3
, trim(nullif(substring(content, 374, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4
, trim(nullif(substring(content, 406, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 421, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 423, 15), '000000000000000'))::varchar(15) as zippostal_code
-- , trim(nullif(substring(content, 438, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_3
, trim(nullif(substring(content, 470, 2), '00'))::varchar(2) as country_code
, trim(nullif(substring(content, 472, 1), '0'))::varchar(1) as usinternational_indicator
, trim(nullif(substring(content, 473, 5), '00000'))::varchar(5) as country_calling_code
, trim(nullif(substring(content, 478, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number
, trim(nullif(substring(content, 538, 7), '0000000'))::varchar(7) as telephone_extension
, trim(nullif(substring(content, 545, 2), '00'))::varchar(2) as associated_country_code
-- , trim(nullif(substring(content, 547, 7), '0000000'))::varchar(7) as reserved_4
, trim(nullif(substring(content, 554, 30), '000000000000000000000000000000'))::varchar(30) as title
, trim(nullif(substring(content, 584, 4), '0000'))::varchar(4) as occupational_category
, trim(nullif(substring(content, 588, 15), '000000000000000'))::varchar(15) as occupation
, trim(nullif(substring(content, 603, 4), '0000'))::varchar(4) as nature_of_business_code
, trim(nullif(substring(content, 607, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text
, try_to_date(nullif(substring(content, 657, 6), '000000'), 'YYYYMM')::date as employment_start_date
-- , trim(nullif(substring(content, 663, 2), '00'))::varchar(2) as reserved_5
, try_to_date(nullif(substring(content, 665, 6), '000000'), 'YYYYMM')::date as employment_end_date
-- , trim(nullif(substring(content, 671, 2), '00'))::varchar(2) as reserved_6
, to_number(nullif(nullif(trim(substring(content, 673, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_value_of_any_accumulated_equity
, to_number(nullif(nullif(trim(substring(content, 691, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_value_of_any_accumulated_equity
, trim(nullif(substring(content, 709, 9), '000000000'))::varchar(9) as employer_tin
-- , trim(nullif(substring(content, 718, 11), '00000000000'))::varchar(11) as reserved_7
, trim(nullif(substring(content, 729, 32), '00000000000000000000000000000000'))::varchar(32) as employer_name_2
-- , trim(nullif(substring(content, 761, 1), '0'))::varchar(1) as not_used_5
, trim(nullif(substring(content, 762, 4), '0000'))::varchar(4) as attention_line_prefix_2
, trim(nullif(substring(content, 766, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_2
, trim(nullif(substring(content, 794, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_2
, trim(nullif(substring(content, 826, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_2
, trim(nullif(substring(content, 858, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_2
, trim(nullif(substring(content, 890, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_2
, trim(nullif(substring(content, 922, 15), '000000000000000'))::varchar(15) as city_2
, trim(nullif(substring(content, 937, 2), '00'))::varchar(2) as state_2
, trim(nullif(substring(content, 939, 15), '000000000000000'))::varchar(15) as zippostal_code_2
-- , trim(nullif(substring(content, 954, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_8
, trim(nullif(substring(content, 986, 2), '00'))::varchar(2) as country_code_2
, trim(nullif(substring(content, 988, 1), '0'))::varchar(1) as usinternational_indicator_2
, trim(nullif(substring(content, 989, 5), '00000'))::varchar(5) as country_calling_code_2
, trim(nullif(substring(content, 994, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_2
, trim(nullif(substring(content, 1054, 7), '0000000'))::varchar(7) as telephone_extension_2
, trim(nullif(substring(content, 1061, 2), '00'))::varchar(2) as associated_country_code_2
-- , trim(nullif(substring(content, 1063, 7), '0000000'))::varchar(7) as reserved_9
, trim(nullif(substring(content, 1070, 30), '000000000000000000000000000000'))::varchar(30) as title_2
, trim(nullif(substring(content, 1100, 4), '0000'))::varchar(4) as occupational_category_2
, trim(nullif(substring(content, 1104, 15), '000000000000000'))::varchar(15) as occupation_text
, trim(nullif(substring(content, 1119, 4), '0000'))::varchar(4) as nature_of_business_code_2
, trim(nullif(substring(content, 1123, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text_2
, try_to_date(nullif(substring(content, 1173, 6), '000000'), 'YYYYMM')::date as employment_start_date_2
-- , trim(nullif(substring(content, 1179, 2), '00'))::varchar(2) as reserved_10
, try_to_date(nullif(substring(content, 1181, 6), '000000'), 'YYYYMM')::date as employment_end_date_2
-- , trim(nullif(substring(content, 1187, 2), '00'))::varchar(2) as reserved_11
, to_number(nullif(nullif(trim(substring(content, 1189, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_value_of_any_accumulated_equity_2
, to_number(nullif(nullif(trim(substring(content, 1207, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_value_of_any_accumulated_equity_2
, trim(nullif(substring(content, 1225, 9), '000000000'))::varchar(9) as employer_tin_2
-- , trim(nullif(substring(content, 1234, 11), '00000000000'))::varchar(11) as reserved_12
, trim(nullif(substring(content, 1245, 32), '00000000000000000000000000000000'))::varchar(32) as employer_name_3
-- , trim(nullif(substring(content, 1277, 1), '0'))::varchar(1) as not_used_6
, trim(nullif(substring(content, 1278, 4), '0000'))::varchar(4) as attention_line_prefix_3
, trim(nullif(substring(content, 1282, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_3
, trim(nullif(substring(content, 1310, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_3
, trim(nullif(substring(content, 1342, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_3
, trim(nullif(substring(content, 1374, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_3
, trim(nullif(substring(content, 1406, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_3
, trim(nullif(substring(content, 1438, 15), '000000000000000'))::varchar(15) as city_3
, trim(nullif(substring(content, 1453, 2), '00'))::varchar(2) as state_3
, trim(nullif(substring(content, 1455, 15), '000000000000000'))::varchar(15) as zippostal_code_3
-- , trim(nullif(substring(content, 1470, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_13
, trim(nullif(substring(content, 1502, 2), '00'))::varchar(2) as country_code_3
, trim(nullif(substring(content, 1504, 1), '0'))::varchar(1) as usinternational_indicator_3
, trim(nullif(substring(content, 1505, 5), '00000'))::varchar(5) as country_calling_code_3
, trim(nullif(substring(content, 1510, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_3
, trim(nullif(substring(content, 1570, 7), '0000000'))::varchar(7) as telephone_extension_3
, trim(nullif(substring(content, 1577, 2), '00'))::varchar(2) as associated_country_code_3
-- , trim(nullif(substring(content, 1579, 7), '0000000'))::varchar(7) as reserved_14
, trim(nullif(substring(content, 1586, 30), '000000000000000000000000000000'))::varchar(30) as title_3
, trim(nullif(substring(content, 1616, 4), '0000'))::varchar(4) as occupational_category_3
, trim(nullif(substring(content, 1620, 15), '000000000000000'))::varchar(15) as occupation_text_2
, trim(nullif(substring(content, 1635, 4), '0000'))::varchar(4) as nature_of_business_code_3
, trim(nullif(substring(content, 1639, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text_3
, try_to_date(nullif(substring(content, 1689, 6), '000000'), 'YYYYMM')::date as employment_start_date_3
-- , trim(nullif(substring(content, 1695, 2), '00'))::varchar(2) as reserved_15
, try_to_date(nullif(substring(content, 1697, 6), '000000'), 'YYYYMM')::date as employment_end_date_3
-- , trim(nullif(substring(content, 1703, 2), '00'))::varchar(2) as reserved_16
, to_number(nullif(nullif(trim(substring(content, 1705, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_value_of_any_accumulated_equity_3
, to_number(nullif(nullif(trim(substring(content, 1723, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_value_of_any_accumulated_equity_3
, trim(nullif(substring(content, 1741, 9), '000000000'))::varchar(9) as employer_tin_3
-- , trim(nullif(substring(content, 1750, 11), '00000000000'))::varchar(11) as reserved_17
, trim(nullif(substring(content, 1761, 32), '00000000000000000000000000000000'))::varchar(32) as employer_name_4
-- , trim(nullif(substring(content, 1793, 1), '0'))::varchar(1) as not_used_7
, trim(nullif(substring(content, 1794, 4), '0000'))::varchar(4) as attention_line_prefix_4
, trim(nullif(substring(content, 1798, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_4
, trim(nullif(substring(content, 1826, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_4
, trim(nullif(substring(content, 1858, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_4
, trim(nullif(substring(content, 1890, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_4
, trim(nullif(substring(content, 1922, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_4
, trim(nullif(substring(content, 1954, 15), '000000000000000'))::varchar(15) as city_4
, trim(nullif(substring(content, 1969, 2), '00'))::varchar(2) as state_4
, trim(nullif(substring(content, 1971, 15), '000000000000000'))::varchar(15) as zippostal_code_4
-- , trim(nullif(substring(content, 1986, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_18
, trim(nullif(substring(content, 2018, 2), '00'))::varchar(2) as country_code_4
, trim(nullif(substring(content, 2020, 1), '0'))::varchar(1) as usinternational_indicator_4
, trim(nullif(substring(content, 2021, 5), '00000'))::varchar(5) as country_calling_code_4
, trim(nullif(substring(content, 2026, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_4
, trim(nullif(substring(content, 2086, 7), '0000000'))::varchar(7) as telephone_extension_4
, trim(nullif(substring(content, 2093, 2), '00'))::varchar(2) as associated_country_code_4
-- , trim(nullif(substring(content, 2095, 7), '0000000'))::varchar(7) as reserved_19
, trim(nullif(substring(content, 2102, 30), '000000000000000000000000000000'))::varchar(30) as title_4
, trim(nullif(substring(content, 2132, 4), '0000'))::varchar(4) as occupational_category_4
, trim(nullif(substring(content, 2136, 15), '000000000000000'))::varchar(15) as occupation_text_3
, trim(nullif(substring(content, 2151, 4), '0000'))::varchar(4) as nature_of_business_code_4
, trim(nullif(substring(content, 2155, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text_4
, try_to_date(nullif(substring(content, 2205, 6), '000000'), 'YYYYMM')::date as employment_start_date_4
-- , trim(nullif(substring(content, 2211, 2), '00'))::varchar(2) as reserved_20
, try_to_date(nullif(substring(content, 2213, 6), '000000'), 'YYYYMM')::date as employment_end_date_4
-- , trim(nullif(substring(content, 2219, 2), '00'))::varchar(2) as reserved_21
, to_number(nullif(nullif(trim(substring(content, 2221, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_value_of_any_accumulated_equity_4
, to_number(nullif(nullif(trim(substring(content, 2239, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_value_of_any_accumulated_equity_4
, trim(nullif(substring(content, 2257, 9), '000000000'))::varchar(9) as employer_tin_4
-- , trim(nullif(substring(content, 2266, 11), '00000000000'))::varchar(11) as reserved_22
-- , trim(nullif(substring(content, 2277, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_23
-- , trim(nullif(substring(content, 2309, 191), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(191) as not_used_8
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'N'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
