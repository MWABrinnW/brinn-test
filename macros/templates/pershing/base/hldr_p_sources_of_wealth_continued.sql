{%- macro hldr_p_sources_of_wealth_continued(src) -%}

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
, trim(nullif(substring(content, 132, 4), '0000'))::varchar(4) as source_of_wealth
, trim(nullif(substring(content, 136, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as name_of_business
, trim(nullif(substring(content, 196, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 200, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 228, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1
, trim(nullif(substring(content, 260, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2
, trim(nullif(substring(content, 292, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3
, trim(nullif(substring(content, 324, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4
, trim(nullif(substring(content, 356, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 371, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 373, 15), '000000000000000'))::varchar(15) as zippostal_code
-- , trim(nullif(substring(content, 388, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_3
, trim(nullif(substring(content, 420, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 422, 20), '00000000000000000000'))::varchar(20) as not_used_3
, trim(nullif(substring(content, 442, 4), '0000'))::varchar(4) as occupational_category
, trim(nullif(substring(content, 446, 15), '000000000000000'))::varchar(15) as occupation_text
, trim(nullif(substring(content, 461, 4), '0000'))::varchar(4) as nature_of_business_code
, trim(nullif(substring(content, 465, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text
, try_to_date(nullif(substring(content, 515, 6), '000000'), 'YYYYMM')::date as date_of_ownership_in_ccyymm_format
-- , trim(nullif(substring(content, 521, 2), '00'))::varchar(2) as reserved_4
, try_to_date(nullif(substring(content, 523, 6), '000000'), 'YYYYMM')::date as date_of_sale
-- , trim(nullif(substring(content, 529, 2), '00'))::varchar(2) as reserved_5
, to_number(nullif(nullif(trim(substring(content, 531, 8)), '00000000'), '')) / power(10, 03)::number as percent_ownership_in_business
, to_number(nullif(nullif(trim(substring(content, 539, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_sales
, to_number(nullif(nullif(trim(substring(content, 557, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_sales
, nullif(nullif(trim(substring(content, 575, 8)), '00000000'), '')::int as approximate_number_of_employees
, to_number(nullif(nullif(trim(substring(content, 583, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_current_valuation_of_business
, to_number(nullif(nullif(trim(substring(content, 601, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_current_valuation_of_business
-- , trim(nullif(substring(content, 619, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_6
, trim(nullif(substring(content, 659, 4), '0000'))::varchar(4) as source_of_wealth_2
, trim(nullif(substring(content, 663, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as name_of_business_2
, trim(nullif(substring(content, 723, 4), '0000'))::varchar(4) as attention_line_prefix_2
, trim(nullif(substring(content, 727, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_2
, trim(nullif(substring(content, 755, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_2
, trim(nullif(substring(content, 787, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_2
, trim(nullif(substring(content, 819, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_2
, trim(nullif(substring(content, 851, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_2
, trim(nullif(substring(content, 883, 15), '000000000000000'))::varchar(15) as city_2
, trim(nullif(substring(content, 898, 2), '00'))::varchar(2) as state_2
, trim(nullif(substring(content, 900, 15), '000000000000000'))::varchar(15) as zippostal_code_2
-- , trim(nullif(substring(content, 915, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_7
, trim(nullif(substring(content, 947, 2), '00'))::varchar(2) as country_code_2
-- , trim(nullif(substring(content, 949, 20), '00000000000000000000'))::varchar(20) as not_used_4
, trim(nullif(substring(content, 969, 4), '0000'))::varchar(4) as occupational_category_2
, trim(nullif(substring(content, 973, 15), '000000000000000'))::varchar(15) as occupation_text_2
, trim(nullif(substring(content, 988, 4), '0000'))::varchar(4) as nature_of_business_code_2
, trim(nullif(substring(content, 992, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text_2
, try_to_date(nullif(substring(content, 1042, 6), '000000'), 'YYYYMM')::date as date_of_ownership_in_ccyymm_format_2
-- , trim(nullif(substring(content, 1048, 2), '00'))::varchar(2) as reserved_8
, try_to_date(nullif(substring(content, 1050, 6), '000000'), 'YYYYMM')::date as date_of_sale_2
-- , trim(nullif(substring(content, 1056, 2), '00'))::varchar(2) as reserved_9
, to_number(nullif(nullif(trim(substring(content, 1058, 8)), '00000000'), '')) / power(10, 03)::number as percent_ownership_in_business_2
, to_number(nullif(nullif(trim(substring(content, 1066, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_sales_2
, to_number(nullif(nullif(trim(substring(content, 1084, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_sales_2
, nullif(nullif(trim(substring(content, 1102, 8)), '00000000'), '')::int as approximate_number_of_employees_2
, to_number(nullif(nullif(trim(substring(content, 1110, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_current_valuation_of_business_2
, to_number(nullif(nullif(trim(substring(content, 1128, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_current_valuation_of_business_2
-- , trim(nullif(substring(content, 1146, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_10
, trim(nullif(substring(content, 1186, 4), '0000'))::varchar(4) as source_of_wealth_3
, trim(nullif(substring(content, 1190, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as name_of_business_3
, trim(nullif(substring(content, 1250, 4), '0000'))::varchar(4) as attention_line_prefix_3
, trim(nullif(substring(content, 1254, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_3
, trim(nullif(substring(content, 1282, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1_3
, trim(nullif(substring(content, 1314, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2_3
, trim(nullif(substring(content, 1346, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3_3
, trim(nullif(substring(content, 1378, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4_3
, trim(nullif(substring(content, 1410, 15), '000000000000000'))::varchar(15) as city_3
, trim(nullif(substring(content, 1425, 2), '00'))::varchar(2) as state_3
, trim(nullif(substring(content, 1427, 15), '000000000000000'))::varchar(15) as zippostal_code_3
-- , trim(nullif(substring(content, 1442, 32), '00000000000000000000000000000000'))::varchar(32) as reserved_11
, trim(nullif(substring(content, 1474, 2), '00'))::varchar(2) as country_code_3
-- , trim(nullif(substring(content, 1476, 20), '00000000000000000000'))::varchar(20) as not_used_5
, trim(nullif(substring(content, 1496, 4), '0000'))::varchar(4) as occupational_category_3
, trim(nullif(substring(content, 1500, 15), '000000000000000'))::varchar(15) as occupation_text_3
, trim(nullif(substring(content, 1515, 4), '0000'))::varchar(4) as nature_of_business_code_3
, trim(nullif(substring(content, 1519, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as nature_of_business_text_3
, try_to_date(nullif(substring(content, 1569, 6), '000000'), 'YYYYMM')::date as date_of_ownership_in_ccyymm_format_3
-- , trim(nullif(substring(content, 1575, 2), '00'))::varchar(2) as reserved_12
, try_to_date(nullif(substring(content, 1577, 6), '000000'), 'YYYYMM')::date as date_of_sale_3
-- , trim(nullif(substring(content, 1583, 2), '00'))::varchar(2) as reserved_13
, to_number(nullif(nullif(trim(substring(content, 1585, 8)), '00000000'), '')) / power(10, 03)::number as percent_ownership_in_business_3
, to_number(nullif(nullif(trim(substring(content, 1593, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_sales_3
, to_number(nullif(nullif(trim(substring(content, 1611, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_sales_3
, nullif(nullif(trim(substring(content, 1629, 8)), '00000000'), '')::int as approximate_number_of_employees_3
, to_number(nullif(nullif(trim(substring(content, 1637, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_miminum_current_valuation_of_business
, to_number(nullif(nullif(trim(substring(content, 1655, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maxinum_current_valuation_of_business
-- , trim(nullif(substring(content, 1673, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_14
, trim(nullif(substring(content, 1713, 4), '0000'))::varchar(4) as source_of_wealth_4
, trim(nullif(substring(content, 1717, 2), '00'))::varchar(2) as country_where_other_wealth_iswas_created
, trim(nullif(substring(content, 1719, 4), '0000'))::varchar(4) as nature_of_business_code_4
, trim(nullif(substring(content, 1723, 30), '000000000000000000000000000000'))::varchar(30) as nature_of_business_text_4
-- , trim(nullif(substring(content, 1753, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_15
-- , trim(nullif(substring(content, 1793, 707), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(707) as not_used_6
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'P'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
