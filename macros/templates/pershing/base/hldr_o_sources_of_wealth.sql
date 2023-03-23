{%- macro hldr_o_sources_of_wealth(src) -%}

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
, trim(nullif(substring(content, 132, 4), '0000'))::varchar(4) as primary_source_of_income
, trim(nullif(substring(content, 136, 30), '000000000000000000000000000000'))::varchar(30) as primary_source_of_income_text
-- , trim(nullif(substring(content, 166, 4), '0000'))::varchar(4) as not_used_3
, trim(nullif(substring(content, 170, 4), '0000'))::varchar(4) as source_of_wealth
-- , trim(nullif(substring(content, 174, 20), '00000000000000000000'))::varchar(20) as reserved_3
, trim(nullif(substring(content, 194, 4), '0000'))::varchar(4) as source_of_wealth_2
, trim(nullif(substring(content, 198, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as name_of_person_who_gifted
, trim(nullif(substring(content, 258, 2), '00'))::varchar(2) as relationship_to_client_code
-- , trim(nullif(substring(content, 260, 2), '00'))::varchar(2) as not_used_4
, trim(nullif(substring(content, 262, 30), '000000000000000000000000000000'))::varchar(30) as relationship_to_client
, trim(nullif(substring(content, 292, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as creator_of_wealth
, try_to_date(nullif(substring(content, 352, 6), '000000'), 'YYYYMM')::date as date_of_gift
-- , trim(nullif(substring(content, 358, 2), '00'))::varchar(2) as reserved_4
, to_number(nullif(nullif(trim(substring(content, 360, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_minimum_value_of_gift
, to_number(nullif(nullif(trim(substring(content, 378, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_maximum_value_of_gift
, to_number(nullif(nullif(trim(substring(content, 396, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_income_derived_from_gift
, to_number(nullif(nullif(trim(substring(content, 414, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_income_derived_from_gift
, trim(nullif(substring(content, 432, 2), '00'))::varchar(2) as gift_country
, trim(nullif(substring(content, 434, 4), '0000'))::varchar(4) as nature_of_business_associated_with_gift_sow_code
, trim(nullif(substring(content, 438, 30), '000000000000000000000000000000'))::varchar(30) as nature_of_business_associated_with_gift_sow_text
-- , trim(nullif(substring(content, 468, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_5
, trim(nullif(substring(content, 508, 4), '0000'))::varchar(4) as source_of_wealth_3
, trim(nullif(substring(content, 512, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as name_of_person_who_gifted_2
, trim(nullif(substring(content, 572, 2), '00'))::varchar(2) as relationship_to_client_code_2
-- , trim(nullif(substring(content, 574, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 576, 30), '000000000000000000000000000000'))::varchar(30) as relationship_to_client_2
, trim(nullif(substring(content, 606, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as creator_of_wealth_2
, try_to_date(nullif(substring(content, 666, 6), '000000'), 'YYYYMM')::date as date_of_inheritance
-- , trim(nullif(substring(content, 672, 2), '00'))::varchar(2) as reserved_6
, to_number(nullif(nullif(trim(substring(content, 674, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_minimum_value_of_inheritance
, to_number(nullif(nullif(trim(substring(content, 692, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_maximum_value_of_inheritance
, to_number(nullif(nullif(trim(substring(content, 710, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_annual_income_derived_from
, to_number(nullif(nullif(trim(substring(content, 728, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_annual_income_derived_from
, trim(nullif(substring(content, 746, 2), '00'))::varchar(2) as country_where_wealth_iswas_created
, trim(nullif(substring(content, 748, 4), '0000'))::varchar(4) as nature_of_business_associated_with_inheritance_sow
, trim(nullif(substring(content, 752, 30), '000000000000000000000000000000'))::varchar(30) as nature_of_business_associated_with_inheritance_sow_2
-- , trim(nullif(substring(content, 782, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_7
, trim(nullif(substring(content, 822, 4), '0000'))::varchar(4) as source_of_wealth_4
, trim(nullif(substring(content, 826, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as name_of_person_responsible_for_dependents_wealth
, trim(nullif(substring(content, 886, 2), '00'))::varchar(2) as relationship_to_client_code_3
-- , trim(nullif(substring(content, 888, 2), '00'))::varchar(2) as not_used_6
, trim(nullif(substring(content, 890, 30), '000000000000000000000000000000'))::varchar(30) as relationship_to_client_3
, trim(nullif(substring(content, 920, 2), '00'))::varchar(2) as country_where_wealth_iswas_created_2
, trim(nullif(substring(content, 922, 4), '0000'))::varchar(4) as nature_of_business_associated_with_dependent_sow_code
, trim(nullif(substring(content, 926, 30), '000000000000000000000000000000'))::varchar(30) as nature_of_business_associated_with_dependent_sow_text
-- , trim(nullif(substring(content, 956, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_8
, trim(nullif(substring(content, 996, 4), '0000'))::varchar(4) as source_of_wealth_5
, to_number(nullif(nullif(trim(substring(content, 1000, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_value_of_portfolio
, to_number(nullif(nullif(trim(substring(content, 1018, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_value_of_portfolio
, to_number(nullif(nullif(trim(substring(content, 1036, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_income_derived_from_portfolio
, to_number(nullif(nullif(trim(substring(content, 1054, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_income_derived_from_portfolio
, trim(nullif(substring(content, 1072, 2), '00'))::varchar(2) as country_where_wealth_iswas_created_3
, trim(nullif(substring(content, 1074, 4), '0000'))::varchar(4) as nature_of_business_associated_with_private_investments
, trim(nullif(substring(content, 1078, 30), '000000000000000000000000000000'))::varchar(30) as nature_of_business_associated_with_private_investments_2
-- , trim(nullif(substring(content, 1108, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_9
, trim(nullif(substring(content, 1148, 4), '0000'))::varchar(4) as source_of_wealth_6
, to_number(nullif(nullif(trim(substring(content, 1152, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_value_of_portfolio_2
, to_number(nullif(nullif(trim(substring(content, 1170, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_value_of_portfolio_2
, to_number(nullif(nullif(trim(substring(content, 1188, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_minimum_income_derived_from_portfolio_2
, to_number(nullif(nullif(trim(substring(content, 1206, 18)), '000000000000000000'), '')) / power(10, 02)::number as approximate_maximum_income_derived_from_portfolio_2
, trim(nullif(substring(content, 1224, 2), '00'))::varchar(2) as country_where_wealth_iswas_created_4
, trim(nullif(substring(content, 1226, 4), '0000'))::varchar(4) as nature_of_business_associated_with_security_investments
, trim(nullif(substring(content, 1230, 30), '000000000000000000000000000000'))::varchar(30) as nature_of_business_associated_with_security_investments_2
-- , trim(nullif(substring(content, 1260, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_10
, trim(nullif(substring(content, 1300, 4), '0000'))::varchar(4) as source_of_wealth_7
, trim(nullif(substring(content, 1304, 2), '00'))::varchar(2) as country_1
, trim(nullif(substring(content, 1306, 2), '00'))::varchar(2) as country_2
, trim(nullif(substring(content, 1308, 2), '00'))::varchar(2) as country_3
, trim(nullif(substring(content, 1310, 2), '00'))::varchar(2) as country_4
, trim(nullif(substring(content, 1312, 2), '00'))::varchar(2) as country_5
-- , trim(nullif(substring(content, 1314, 20), '00000000000000000000'))::varchar(20) as reserved_11
, trim(nullif(substring(content, 1334, 4), '0000'))::varchar(4) as nature_of_real_estate_investment_1
, trim(nullif(substring(content, 1338, 4), '0000'))::varchar(4) as nature_of_real_estate_investment_2
, trim(nullif(substring(content, 1342, 4), '0000'))::varchar(4) as nature_of_real_estate_investment_3
, trim(nullif(substring(content, 1346, 4), '0000'))::varchar(4) as nature_of_real_estate_investment_4
, trim(nullif(substring(content, 1350, 4), '0000'))::varchar(4) as nature_of_real_estate_investment_5
-- , trim(nullif(substring(content, 1354, 20), '00000000000000000000'))::varchar(20) as reserved_12
, trim(nullif(substring(content, 1374, 4), '0000'))::varchar(4) as nature_of_real_estate_income_1
, trim(nullif(substring(content, 1378, 4), '0000'))::varchar(4) as nature_of_real_estate_income_2
, trim(nullif(substring(content, 1382, 4), '0000'))::varchar(4) as nature_of_real_estate_income_3
, trim(nullif(substring(content, 1386, 4), '0000'))::varchar(4) as nature_of_real_estate_income_4
, trim(nullif(substring(content, 1390, 4), '0000'))::varchar(4) as nature_of_real_estate_income_5
-- , trim(nullif(substring(content, 1394, 20), '00000000000000000000'))::varchar(20) as reserved_13
-- , trim(nullif(substring(content, 1414, 1086), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(1086) as not_used_7
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'O'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
