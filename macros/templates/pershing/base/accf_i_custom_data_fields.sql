{%- macro accf_i_custom_data_fields(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 25, 3), '000'))
  else trim(nullif(substring(content, 25, 4), '0000'))
  end::varchar(4) as investment_professional_ip_number
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as custom_field_1_transaction_code
, trim(nullif(substring(content, 42, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_1_label
, trim(nullif(substring(content, 74, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_1_detail_text
, trim(nullif(substring(content, 106, 1), '0'))::varchar(1) as custom_field_1_status_indicator
-- , trim(nullif(substring(content, 107, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 108, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_2_label
, trim(nullif(substring(content, 140, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_2_detail_text
, trim(nullif(substring(content, 172, 1), '0'))::varchar(1) as custom_field_2_status_indicator
-- , trim(nullif(substring(content, 173, 1), '0'))::varchar(1) as not_used_5
, trim(nullif(substring(content, 174, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_3_label
, trim(nullif(substring(content, 206, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_3_detail_text
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as custom_field_3_status_indicator
-- , trim(nullif(substring(content, 239, 1), '0'))::varchar(1) as not_used_6
, trim(nullif(substring(content, 240, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_4_label
, trim(nullif(substring(content, 272, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_4_detail_text
, trim(nullif(substring(content, 304, 1), '0'))::varchar(1) as custom_field_4_status_indicator
-- , trim(nullif(substring(content, 305, 1), '0'))::varchar(1) as not_used_7
, trim(nullif(substring(content, 306, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_5_label
, trim(nullif(substring(content, 338, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_5_detail_text
, trim(nullif(substring(content, 370, 1), '0'))::varchar(1) as custom_field_5_status_indicator
-- , trim(nullif(substring(content, 371, 1), '0'))::varchar(1) as not_used_8
, trim(nullif(substring(content, 372, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_6_label
, trim(nullif(substring(content, 404, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_6_detail_text
, trim(nullif(substring(content, 436, 1), '0'))::varchar(1) as custom_field_6_status_indicator
-- , trim(nullif(substring(content, 437, 1), '0'))::varchar(1) as not_used_9
, trim(nullif(substring(content, 438, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_7_label
, trim(nullif(substring(content, 470, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_7_detail_text
, trim(nullif(substring(content, 502, 1), '0'))::varchar(1) as custom_field_7_status_indicator
-- , trim(nullif(substring(content, 503, 1), '0'))::varchar(1) as not_used_10
, trim(nullif(substring(content, 504, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_8_label
, trim(nullif(substring(content, 536, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_8_detail_text
, trim(nullif(substring(content, 568, 1), '0'))::varchar(1) as custom_field_8_status_indicator
-- , trim(nullif(substring(content, 569, 1), '0'))::varchar(1) as not_used_11
, trim(nullif(substring(content, 570, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_9_label
, trim(nullif(substring(content, 602, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_9_detail_text
, trim(nullif(substring(content, 634, 1), '0'))::varchar(1) as custom_field_9_status_indicator
-- , trim(nullif(substring(content, 635, 1), '0'))::varchar(1) as not_used_12
, trim(nullif(substring(content, 636, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_10_label
, trim(nullif(substring(content, 668, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_10_detail_text
, trim(nullif(substring(content, 700, 1), '0'))::varchar(1) as custom_field_10_status_indicator
-- , trim(nullif(substring(content, 701, 49), '0000000000000000000000000000000000000000000000000'))::varchar(49) as not_used_13
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'I'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
