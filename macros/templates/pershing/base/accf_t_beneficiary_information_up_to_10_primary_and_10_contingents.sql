{%- macro accf_t_beneficiary_information_up_to_10_primary_and_10_contingents(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 25, 3), '000'))::varchar(3) as investment_professional_ip_number
-- , trim(nullif(substring(content, 28, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as beneficiary_transaction_code
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as beneficiary_type
, trim(nullif(substring(content, 43, 3), '000'))::varchar(3) as sequence_number
-- , trim(nullif(substring(content, 46, 3), '000'))::varchar(3) as not_used_4
, trim(nullif(substring(content, 49, 2), '00'))::varchar(2) as beneficiary_relationship_indicator
, trim(nullif(substring(content, 51, 2), '00'))::varchar(2) as primary_country_of_citizenship
-- , trim(nullif(substring(content, 53, 6), '000000'))::varchar(6) as not_used_5
, trim(nullif(substring(content, 59, 1), '0'))::varchar(1) as sex_of_beneficiary
, try_to_date(nullif(substring(content, 60, 8), '00000000'), 'YYYYMMDD')::date as beneficiary_birth_date
, trim(nullif(substring(content, 68, 1), '0'))::varchar(1) as tax_id_type
, trim(nullif(substring(content, 69, 9), '000000000'))::varchar(9) as beneficiary_tax_id_number
, to_number(nullif(nullif(trim(substring(content, 78, 18)), '000000000000000000'), '')) / power(10, 09)::number as percent_allocation
, trim(nullif(substring(content, 96, 1), '0'))::varchar(1) as beneficiary_name_type
, trim(nullif(substring(content, 97, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_prefixentity_line_1
, trim(nullif(substring(content, 129, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_first_nameentity_line_2
, trim(nullif(substring(content, 161, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_middle_initialname_entity_line_3
, trim(nullif(substring(content, 193, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_last_nameentity_line_4
-- , trim(nullif(substring(content, 225, 3), '000'))::varchar(3) as not_used_6
, trim(nullif(substring(content, 228, 1), '0'))::varchar(1) as beneficiary_address_transaction_code
, trim(nullif(substring(content, 229, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 230, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 234, 28), '0000000000000000000000000000'))::varchar(28) as beneficiary_attention_line_detail
, trim(nullif(substring(content, 262, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_1
, trim(nullif(substring(content, 294, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_2
, trim(nullif(substring(content, 326, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_3
, trim(nullif(substring(content, 358, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_4
, iff(substring(content, 422, 2) in ('US', 'CA'), trim(nullif(substring(content, 390, 15), '000000000000000')), '')::varchar(15) as city
, iff(substring(content, 422, 2) in ('US', 'CA'), trim(nullif(substring(content, 405, 2), '00')), '')::varchar(2) as state
, iff(substring(content, 422, 2) in ('US', 'CA'), trim(nullif(substring(content, 407, 15), '000000000000000')), '')::varchar(15) as zip
, iff(substring(content, 422, 2) not in ('US', 'CA'), trim(nullif(substring(content, 390, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city
, trim(nullif(substring(content, 422, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 424, 1), '0'))::varchar(1) as not_used_7
, trim(nullif(substring(content, 425, 1), '0'))::varchar(1) as beneficiary_1_phone_transaction_code
, trim(nullif(substring(content, 426, 1), '0'))::varchar(1) as usinternational_indicator_1
, trim(nullif(substring(content, 427, 1), '0'))::varchar(1) as telephone_type_id_1
, trim(nullif(substring(content, 428, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_1
, trim(nullif(substring(content, 488, 7), '0000000'))::varchar(7) as telephone_extension_1
, trim(nullif(substring(content, 495, 1), '0'))::varchar(1) as beneficiary_2_telephone_transaction_code
, trim(nullif(substring(content, 496, 1), '0'))::varchar(1) as usinternational_indicator_2
, trim(nullif(substring(content, 497, 1), '0'))::varchar(1) as telephone_type_id_2
, trim(nullif(substring(content, 498, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_2
, trim(nullif(substring(content, 558, 7), '0000000'))::varchar(7) as telephone_extension_2
, trim(nullif(substring(content, 565, 1), '0'))::varchar(1) as beneficiary_3_telephone_transaction_code
, trim(nullif(substring(content, 566, 1), '0'))::varchar(1) as usinternational_indicator_3
, trim(nullif(substring(content, 567, 1), '0'))::varchar(1) as telephone_type_id_3
, trim(nullif(substring(content, 568, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_3
, trim(nullif(substring(content, 628, 7), '0000000'))::varchar(7) as telephone_extension_3
, to_number(nullif(nullif(trim(substring(content, 635, 18)), '000000000000000000'), '')) / power(10, 02)::number as beneficiary_payment_amount
, trim(nullif(substring(content, 653, 1), '0'))::varchar(1) as per_stirpes_beneficiary_designation
, trim(nullif(substring(content, 654, 20), '00000000000000000000'))::varchar(20) as external_client_id_supplied_by_customer
, trim(nullif(substring(content, 674, 9), '000000000'))::varchar(9) as internal_pershing_assigned_client_id
, trim(nullif(substring(content, 683, 1), '0'))::varchar(1) as type_of_trust
, try_to_date(nullif(substring(content, 684, 8), '00000000'), 'YYYYMMDD')::date as date_trust_established
-- , trim(nullif(substring(content, 692, 58), '0000000000000000000000000000000000000000000000000000000000'))::varchar(58) as not_used_8
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'T'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
