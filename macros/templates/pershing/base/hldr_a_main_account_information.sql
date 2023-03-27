{%- macro hldr_a_main_account_information(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as transaction_type
-- , trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as not_used_3
, trim(nullif(substring(content, 43, 4), '0000'))::varchar(4) as registration_type
-- , trim(nullif(substring(content, 47, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 48, 1), '0'))::varchar(1) as number_of_account_title_lines_in_registration_lines
, trim(nullif(substring(content, 49, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_1
, trim(nullif(substring(content, 81, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_2
, trim(nullif(substring(content, 113, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_3
, trim(nullif(substring(content, 145, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_4
, trim(nullif(substring(content, 177, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_5
, trim(nullif(substring(content, 209, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_6
, trim(nullif(substring(content, 241, 8), '00000000'))::varchar(8) as for_pershing_internal_use_only
-- , trim(nullif(substring(content, 249, 13), '0000000000000'))::varchar(13) as not_used_5
, try_to_date(nullif(substring(content, 262, 8), '00000000'), 'YYYYMMDD')::date as date_account_opened
, nullif(nullif(trim(substring(content, 270, 8)), '00000000'), '')::int as date_account_information_updated
, trim(nullif(substring(content, 278, 1), '0'))::varchar(1) as account_status_indicator
, try_to_date(nullif(substring(content, 279, 8), '00000000'), 'YYYYMMDD')::date as pending_closed_date
, try_to_date(nullif(substring(content, 287, 8), '00000000'), 'YYYYMMDD')::date as date_account_closed
-- , trim(nullif(substring(content, 295, 8), '00000000'))::varchar(8) as not_used_6
, try_to_date(nullif(substring(content, 303, 8), '00000000'), 'YYYYMMDD')::date as account_reactivated_date
, try_to_date(nullif(substring(content, 311, 8), '00000000'), 'YYYYMMDD')::date as date_account_reopened
, trim(nullif(substring(content, 319, 9), '000000000'))::varchar(9) as introducing_firm
, trim(nullif(substring(content, 328, 4), '0000'))::varchar(4) as reserved_for_booking_entity
, trim(nullif(substring(content, 332, 1), '0'))::varchar(1) as w9_on_file
, trim(nullif(substring(content, 333, 1), '0'))::varchar(1) as tax_status
, try_to_date(nullif(substring(content, 334, 8), '00000000'), 'YYYYMMDD')::date as date_of_disability
, try_to_date(nullif(substring(content, 342, 8), '00000000'), 'YYYYMMDD')::date as custodian_date
, trim(nullif(substring(content, 350, 800), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(800) as reserved_for_future_use
-- , trim(nullif(substring(content, 1150, 2), '00'))::varchar(2) as not_used_7
, trim(nullif(substring(content, 1152, 1), '0'))::varchar(1) as seasonal_address_identifier
, try_to_date(nullif(substring(content, 1153, 8), '00000000'), 'YYYYMMDD')::date as from_date
, try_to_date(nullif(substring(content, 1161, 8), '00000000'), 'YYYYMMDD')::date as to_date
, trim(nullif(substring(content, 1169, 1), '0'))::varchar(1) as seasonal_address_id
, try_to_date(nullif(substring(content, 1170, 8), '00000000'), 'YYYYMMDD')::date as from_date_2
, try_to_date(nullif(substring(content, 1178, 8), '00000000'), 'YYYYMMDD')::date as to_date_2
, trim(nullif(substring(content, 1186, 1), '0'))::varchar(1) as seasonal_address_id_2
, try_to_date(nullif(substring(content, 1187, 8), '00000000'), 'YYYYMMDD')::date as from_date_3
, try_to_date(nullif(substring(content, 1195, 8), '00000000'), 'YYYYMMDD')::date as to_date_3
, trim(nullif(substring(content, 1203, 1), '0'))::varchar(1) as delivery_identifier
, trim(nullif(substring(content, 1204, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 1205, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 1209, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 1237, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1
, trim(nullif(substring(content, 1269, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2
, trim(nullif(substring(content, 1301, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3
, trim(nullif(substring(content, 1333, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4
, trim(nullif(substring(content, 1365, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 1380, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 1382, 15), '000000000000000'))::varchar(15) as zippostal_code
, trim(nullif(substring(content, 1397, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city
, trim(nullif(substring(content, 1429, 2), '00'))::varchar(2) as country_code
, trim(nullif(substring(content, 1431, 1), '0'))::varchar(1) as delivery_identifier_2
, trim(nullif(substring(content, 1432, 1), '0'))::varchar(1) as special_handling_indicator_2
, trim(nullif(substring(content, 1433, 4), '0000'))::varchar(4) as attention_line_prefix_2
, trim(nullif(substring(content, 1437, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_2
, trim(nullif(substring(content, 1465, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_2
, trim(nullif(substring(content, 1497, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_2
, trim(nullif(substring(content, 1529, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_2
, trim(nullif(substring(content, 1561, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_2
, trim(nullif(substring(content, 1593, 15), '000000000000000'))::varchar(15) as city_2
, trim(nullif(substring(content, 1608, 2), '00'))::varchar(2) as state_2
, trim(nullif(substring(content, 1610, 15), '000000000000000'))::varchar(15) as zippostal_code_2
, trim(nullif(substring(content, 1625, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city_2
, trim(nullif(substring(content, 1657, 2), '00'))::varchar(2) as country_code_2
, trim(nullif(substring(content, 1659, 1), '0'))::varchar(1) as delivery_identifier_3
, trim(nullif(substring(content, 1660, 1), '0'))::varchar(1) as special_handling_indicator_3
, trim(nullif(substring(content, 1661, 4), '0000'))::varchar(4) as attention_line_prefix_3
, trim(nullif(substring(content, 1665, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_3
, trim(nullif(substring(content, 1693, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_3
, trim(nullif(substring(content, 1725, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_3
, trim(nullif(substring(content, 1757, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_3
, trim(nullif(substring(content, 1789, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_3
, trim(nullif(substring(content, 1821, 15), '000000000000000'))::varchar(15) as city_3
, trim(nullif(substring(content, 1836, 2), '00'))::varchar(2) as state_3
, trim(nullif(substring(content, 1838, 15), '000000000000000'))::varchar(15) as zippostal_code_3
, trim(nullif(substring(content, 1853, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city_3
, trim(nullif(substring(content, 1885, 2), '00'))::varchar(2) as country_code_3
, trim(nullif(substring(content, 1887, 1), '0'))::varchar(1) as delivery_identifier_4
, trim(nullif(substring(content, 1888, 1), '0'))::varchar(1) as special_handling_indicator_4
, trim(nullif(substring(content, 1889, 4), '0000'))::varchar(4) as attention_line_prefix_4
, trim(nullif(substring(content, 1893, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_4
, trim(nullif(substring(content, 1921, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_4
, trim(nullif(substring(content, 1953, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_4
, trim(nullif(substring(content, 1985, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_4
, trim(nullif(substring(content, 2017, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_4
, trim(nullif(substring(content, 2049, 15), '000000000000000'))::varchar(15) as city_4
, trim(nullif(substring(content, 2064, 2), '00'))::varchar(2) as state_4
, trim(nullif(substring(content, 2066, 15), '000000000000000'))::varchar(15) as zippostal_code_4
, trim(nullif(substring(content, 2081, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city_4
, trim(nullif(substring(content, 2113, 2), '00'))::varchar(2) as country_code_4
, trim(nullif(substring(content, 2115, 1), '0'))::varchar(1) as delivery_identifier_5
, trim(nullif(substring(content, 2116, 1), '0'))::varchar(1) as special_handling_indicator_5
, trim(nullif(substring(content, 2117, 4), '0000'))::varchar(4) as attention_line_prefix_5
, trim(nullif(substring(content, 2121, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_5
, trim(nullif(substring(content, 2149, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_5
, trim(nullif(substring(content, 2181, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_5
, trim(nullif(substring(content, 2213, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_5
, trim(nullif(substring(content, 2245, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_5
, trim(nullif(substring(content, 2277, 15), '000000000000000'))::varchar(15) as city_5
, trim(nullif(substring(content, 2292, 2), '00'))::varchar(2) as state_5
, trim(nullif(substring(content, 2294, 15), '000000000000000'))::varchar(15) as zippostal_code_5
, trim(nullif(substring(content, 2309, 32), '00000000000000000000000000000000'))::varchar(32) as nonus_city_5
, trim(nullif(substring(content, 2341, 2), '00'))::varchar(2) as country_code_5
, trim(nullif(substring(content, 2343, 32), '00000000000000000000000000000000'))::varchar(32) as account_description
-- , trim(nullif(substring(content, 2375, 125), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(125) as not_used_8
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
