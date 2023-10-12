{%- macro acct_j(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as custom_field_transaction_code
, trim(nullif(substring(content, 42, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_11_label
, trim(nullif(substring(content, 74, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_11_detail_text
, trim(nullif(substring(content, 106, 1), '0'))::varchar(1) as custom_field_11_status_indicator
-- , trim(nullif(substring(content, 107, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 108, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_12_label
, trim(nullif(substring(content, 140, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_12_detail_text
, trim(nullif(substring(content, 172, 1), '0'))::varchar(1) as custom_field_12_status_indicator
-- , trim(nullif(substring(content, 173, 1), '0'))::varchar(1) as not_used_5
, trim(nullif(substring(content, 174, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_13_label
, trim(nullif(substring(content, 206, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_13_detail_text
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as custom_field_13_status_indicator
-- , trim(nullif(substring(content, 239, 1), '0'))::varchar(1) as not_used_6
, trim(nullif(substring(content, 240, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_14_label
, trim(nullif(substring(content, 272, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_14_detail_text
, trim(nullif(substring(content, 304, 1), '0'))::varchar(1) as custom_field_14_status_indicator
-- , trim(nullif(substring(content, 305, 1), '0'))::varchar(1) as not_used_7
, trim(nullif(substring(content, 306, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_15_label
, trim(nullif(substring(content, 338, 32), '00000000000000000000000000000000'))::varchar(32) as custom_field_15_detail_text
, trim(nullif(substring(content, 370, 1), '0'))::varchar(1) as custom_field_15_status_indicator
-- , trim(nullif(substring(content, 371, 1), '0'))::varchar(1) as not_used_8
, trim(nullif(substring(content, 372, 85), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(85) as for_pershing_internal_use_only_psupp
-- , trim(nullif(substring(content, 457, 293), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(293) as not_used_9
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'J'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
