{%- macro accf_f(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as address_7_transaction_code
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as special_handling_indicator_7
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as delivery_identifier_7
, trim(nullif(substring(content, 44, 4), '0000'))::varchar(4) as attention_line_prefix_7
, trim(nullif(substring(content, 48, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_7
, trim(nullif(substring(content, 76, 32), '00000000000000000000000000000000'))::varchar(32) as address_7_line_1
, trim(nullif(substring(content, 108, 32), '00000000000000000000000000000000'))::varchar(32) as address_7_line_2
, trim(nullif(substring(content, 140, 32), '00000000000000000000000000000000'))::varchar(32) as address_7_line_3
, trim(nullif(substring(content, 172, 32), '00000000000000000000000000000000'))::varchar(32) as address_7_line_4
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 204, 15), '000000000000000')), '')::varchar(15) as city
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 219, 2), '00')), '')::varchar(2) as state
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 221, 15), '000000000000000')), '')::varchar(15) as zip
, iff(substring(content, 236, 2) not in ('US', 'CA'), trim(nullif(substring(content, 204, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city
, trim(nullif(substring(content, 236, 2), '00'))::varchar(2) as country_code_7
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as set_as_mailing_address_indicator_7
-- , trim(nullif(substring(content, 239, 511), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(511) as not_used_4
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'F'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
