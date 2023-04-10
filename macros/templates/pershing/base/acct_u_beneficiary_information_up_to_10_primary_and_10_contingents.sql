{%- macro acct_u_beneficiary_information_up_to_10_primary_and_10_contingents(src) -%}

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
, trim(nullif(substring(content, 49, 1), '0'))::varchar(1) as beneficiary_4_telephone_transaction_code
, trim(nullif(substring(content, 50, 1), '0'))::varchar(1) as usinternational_indicator_4
, trim(nullif(substring(content, 51, 1), '0'))::varchar(1) as telephone_type_id_4
, trim(nullif(substring(content, 52, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_4
, trim(nullif(substring(content, 112, 7), '0000000'))::varchar(7) as telephone_extension_4
, trim(nullif(substring(content, 119, 1), '0'))::varchar(1) as beneficiary_5_telephone_transaction_code
, trim(nullif(substring(content, 120, 1), '0'))::varchar(1) as usinternational_indicator_5
, trim(nullif(substring(content, 121, 1), '0'))::varchar(1) as telephone_type_id_5
, trim(nullif(substring(content, 122, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_5
, trim(nullif(substring(content, 182, 7), '0000000'))::varchar(7) as telephone_extension_5
, trim(nullif(substring(content, 189, 1), '0'))::varchar(1) as beneficiary_6_telephone_transaction_code
, trim(nullif(substring(content, 190, 1), '0'))::varchar(1) as usinternational_indicator_6
, trim(nullif(substring(content, 191, 1), '0'))::varchar(1) as telephone_type_id_6
, trim(nullif(substring(content, 192, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_6
, trim(nullif(substring(content, 252, 7), '0000000'))::varchar(7) as telephone_extension_6
, trim(nullif(substring(content, 259, 1), '0'))::varchar(1) as beneficiary_7_telephone_transaction_code
, trim(nullif(substring(content, 260, 1), '0'))::varchar(1) as usinternational_indicator_7
, trim(nullif(substring(content, 261, 1), '0'))::varchar(1) as telephone_type_id_7
, trim(nullif(substring(content, 262, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_7
, trim(nullif(substring(content, 322, 7), '0000000'))::varchar(7) as telephone_extension_7
, trim(nullif(substring(content, 329, 1), '0'))::varchar(1) as beneficiary_trust_transaction_code_record_u
, trim(nullif(substring(content, 330, 1), '0'))::varchar(1) as beneficiary_trustee_1_name_type_code
, trim(nullif(substring(content, 331, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_1_prefixentity_line_1
, trim(nullif(substring(content, 363, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_1_first_nameentity_line_2
, trim(nullif(substring(content, 395, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_1_middle_initialname_entity_line_3
, trim(nullif(substring(content, 427, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_1_last_name_entity_line_4
, trim(nullif(substring(content, 459, 1), '0'))::varchar(1) as beneficiary_address_transaction_code
, trim(nullif(substring(content, 460, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 461, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 465, 28), '0000000000000000000000000000'))::varchar(28) as beneficiary_attention_line_detail
, trim(nullif(substring(content, 493, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_1
, trim(nullif(substring(content, 525, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_2
, trim(nullif(substring(content, 557, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_3
, trim(nullif(substring(content, 589, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_address_line_4
, iff(substring(content, 653, 2) in ('US', 'CA'), trim(nullif(substring(content, 621, 15), '000000000000000')), '')::varchar(15) as city
, iff(substring(content, 653, 2) in ('US', 'CA'), trim(nullif(substring(content, 636, 2), '00')), '')::varchar(2) as state
, iff(substring(content, 653, 2) in ('US', 'CA'), trim(nullif(substring(content, 638, 15), '000000000000000')), '')::varchar(15) as zip
, iff(substring(content, 653, 2) not in ('US', 'CA'), trim(nullif(substring(content, 621, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city
, trim(nullif(substring(content, 653, 2), '00'))::varchar(2) as country_code
, trim(nullif(substring(content, 655, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as beneficiary_email_address
-- , trim(nullif(substring(content, 705, 45), '000000000000000000000000000000000000000000000'))::varchar(45) as not_used_5
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'U'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
