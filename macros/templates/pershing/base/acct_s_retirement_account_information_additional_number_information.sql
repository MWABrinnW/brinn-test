{%- macro acct_s_retirement_account_information_additional_number_information(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as telephone_3_transaction_code
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as usinternational_indicator_3
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as telephone_type_id_3
, trim(nullif(substring(content, 44, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_3
, trim(nullif(substring(content, 104, 7), '0000000'))::varchar(7) as telephone_extension_3
, trim(nullif(substring(content, 111, 1), '0'))::varchar(1) as telephone_4_transaction_code
, trim(nullif(substring(content, 112, 1), '0'))::varchar(1) as usinternational_indicator_4
, trim(nullif(substring(content, 113, 1), '0'))::varchar(1) as telephone_type_id_4
, trim(nullif(substring(content, 114, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_4
, trim(nullif(substring(content, 174, 7), '0000000'))::varchar(7) as telephone_extension_4
, trim(nullif(substring(content, 181, 1), '0'))::varchar(1) as telephone_5_transaction_code
, trim(nullif(substring(content, 182, 1), '0'))::varchar(1) as usinternational_indicator_5
, trim(nullif(substring(content, 183, 1), '0'))::varchar(1) as telephone_type_id_5
, trim(nullif(substring(content, 184, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_5
, trim(nullif(substring(content, 244, 7), '0000000'))::varchar(7) as telephone_extension_5
, trim(nullif(substring(content, 251, 1), '0'))::varchar(1) as telephone_6_transaction_code
, trim(nullif(substring(content, 252, 1), '0'))::varchar(1) as usinternational_indicator_6
, trim(nullif(substring(content, 253, 1), '0'))::varchar(1) as telephone_type_id_6
, trim(nullif(substring(content, 254, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_6
, trim(nullif(substring(content, 314, 7), '0000000'))::varchar(7) as telephone_extension_6
, trim(nullif(substring(content, 321, 1), '0'))::varchar(1) as telephone_7_transaction_code
, trim(nullif(substring(content, 322, 1), '0'))::varchar(1) as usinternational_indicator_7
, trim(nullif(substring(content, 323, 1), '0'))::varchar(1) as telephone_type_id_7
, trim(nullif(substring(content, 324, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_7
, trim(nullif(substring(content, 384, 7), '0000000'))::varchar(7) as telephone_extension_7
-- , trim(nullif(substring(content, 391, 22), '0000000000000000000000'))::varchar(22) as not_used_4
, try_to_date(nullif(substring(content, 413, 8), '00000000'), 'YYYYMMDD')::date as original_beneficiary_date_of_birth_for_rmd_calculation
-- , trim(nullif(substring(content, 421, 329), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(329) as not_used_5
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'S'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
