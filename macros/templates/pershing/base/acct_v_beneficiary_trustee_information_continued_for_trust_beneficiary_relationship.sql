{%- macro acct_v_beneficiary_trustee_information_continued_for_trust_beneficiary_relationship(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as beneficiary_trust_transaction_code_for_record_v
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as beneficiary_trustee_2_name_type_code
, trim(nullif(substring(content, 43, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_2_prefixentity_line_1
, trim(nullif(substring(content, 75, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_2_first_nameentity_line_2
, trim(nullif(substring(content, 107, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_2_middle_initialname_entity_line_3
, trim(nullif(substring(content, 139, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_2_last_nameentity_line_4
, trim(nullif(substring(content, 171, 1), '0'))::varchar(1) as beneficiary_trustee_3_name_type_code
, trim(nullif(substring(content, 172, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_3_prefixentity_line_1
, trim(nullif(substring(content, 204, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_3_first_nameentity_line_2
, trim(nullif(substring(content, 236, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_3_middle_initialname_entity_line_3
, trim(nullif(substring(content, 268, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_name_3_last_name_entity_line_4
, trim(nullif(substring(content, 300, 1), '0'))::varchar(1) as beneficiary_trustee_4_name_type_code
, trim(nullif(substring(content, 301, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_4_prefixentity_line_1
, trim(nullif(substring(content, 333, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_4_first_nameentity_line_2
, trim(nullif(substring(content, 365, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_4_middle_initialname_entity_line_3
, trim(nullif(substring(content, 397, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_4_last_nameentity_line_4
, trim(nullif(substring(content, 429, 1), '0'))::varchar(1) as beneficiary_trustee_5_name_type_code
, trim(nullif(substring(content, 430, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_5_prefixentity_line_1
, trim(nullif(substring(content, 462, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_5_first_nameentity_line_2
, trim(nullif(substring(content, 494, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_5_middle_initialname_entity_line_3
, trim(nullif(substring(content, 526, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_5_last_nameentity_line_4
, trim(nullif(substring(content, 558, 1), '0'))::varchar(1) as beneficiary_trustee_6_name_type_code
, trim(nullif(substring(content, 559, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_6_prefixentity_line_1
, trim(nullif(substring(content, 591, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_6_first_nameentity_line_2
, trim(nullif(substring(content, 623, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_6_middle_initialname_entity_line_3
, trim(nullif(substring(content, 655, 32), '00000000000000000000000000000000'))::varchar(32) as beneficiary_trustee_6_last_nameentity_line_4
-- , trim(nullif(substring(content, 687, 63), '000000000000000000000000000000000000000000000000000000000000000'))::varchar(63) as not_used_4
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'V'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
