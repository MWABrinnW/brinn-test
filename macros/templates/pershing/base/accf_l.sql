{%- macro accf_l(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as advisory_account_transaction_code
, try_to_date(nullif(substring(content, 42, 8), '00000000'), 'YYYYMMDD')::date as inception_date
, trim(nullif(substring(content, 50, 10), '0000000000'))::varchar(10) as advisory_program_code
, trim(nullif(substring(content, 60, 10), '0000000000'))::varchar(10) as advisory_product_type_code
, trim(nullif(substring(content, 70, 120), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(120) as advisory_programproduct_type_long_name
, trim(nullif(substring(content, 190, 10), '0000000000'))::varchar(10) as advisory_money_manager_code
, trim(nullif(substring(content, 200, 120), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(120) as advisory_money_manager_name
, trim(nullif(substring(content, 320, 10), '0000000000'))::varchar(10) as advisory_management_style_code
, trim(nullif(substring(content, 330, 120), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(120) as advisory_management_style
-- , trim(nullif(substring(content, 450, 300), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(300) as not_used_4
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'L'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
