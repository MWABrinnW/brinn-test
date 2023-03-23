{%- macro accf_e_main_account_information_address_5_and_6(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as address_5_transaction_code
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as special_handling_indicator_5
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as delivery_identifier_5
, trim(nullif(substring(content, 44, 4), '0000'))::varchar(4) as attention_line_prefix_5
, trim(nullif(substring(content, 48, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_5
, trim(nullif(substring(content, 76, 32), '00000000000000000000000000000000'))::varchar(32) as address_5_line_1
, trim(nullif(substring(content, 108, 32), '00000000000000000000000000000000'))::varchar(32) as address_5_line_2
, trim(nullif(substring(content, 140, 32), '00000000000000000000000000000000'))::varchar(32) as address_5_line_3
, trim(nullif(substring(content, 172, 32), '00000000000000000000000000000000'))::varchar(32) as address_5_line_4
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 204, 15), '000000000000000')), '')::varchar(15) as city
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 219, 2), '00')), '')::varchar(2) as state
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 221, 15), '000000000000000')), '')::varchar(15) as zip
, iff(substring(content, 236, 2) not in ('US', 'CA'), trim(nullif(substring(content, 204, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city
, trim(nullif(substring(content, 236, 2), '00'))::varchar(2) as country_code_5
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as set_as_mailing_address_indicator_5
-- , trim(nullif(substring(content, 239, 99), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(99) as not_used_4
, trim(nullif(substring(content, 338, 1), '0'))::varchar(1) as address_6_transaction_code
, trim(nullif(substring(content, 339, 1), '0'))::varchar(1) as special_handling_indicator_6
, trim(nullif(substring(content, 340, 1), '0'))::varchar(1) as delivery_identifier_6
, trim(nullif(substring(content, 341, 4), '0000'))::varchar(4) as attention_line_prefix_6
, trim(nullif(substring(content, 345, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_6
, trim(nullif(substring(content, 373, 32), '00000000000000000000000000000000'))::varchar(32) as address_6_line_1
, trim(nullif(substring(content, 405, 32), '00000000000000000000000000000000'))::varchar(32) as address_6_line_2
, trim(nullif(substring(content, 437, 32), '00000000000000000000000000000000'))::varchar(32) as address_6_line_3
, trim(nullif(substring(content, 469, 32), '00000000000000000000000000000000'))::varchar(32) as address_6_line_4
, iff(substring(content, 533, 2) in ('US', 'CA'), trim(nullif(substring(content, 501, 15), '000000000000000')), '')::varchar(15) as city_2
, iff(substring(content, 533, 2) in ('US', 'CA'), trim(nullif(substring(content, 516, 2), '00')), '')::varchar(2) as state_2
, iff(substring(content, 533, 2) in ('US', 'CA'), trim(nullif(substring(content, 518, 15), '000000000000000')), '')::varchar(15) as zip_2
, iff(substring(content, 533, 2) not in ('US', 'CA'), trim(nullif(substring(content, 501, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city_2
, trim(nullif(substring(content, 533, 2), '00'))::varchar(2) as country_code_6
, trim(nullif(substring(content, 535, 1), '0'))::varchar(1) as set_as_mailing_address_indicator_6
-- , trim(nullif(substring(content, 536, 214), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(214) as not_used_5
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'E'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
