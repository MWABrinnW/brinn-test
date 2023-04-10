{%- macro mftd_b_comments(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 10, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 20, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 29, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as comments
, trim(nullif(substring(content, 89, 1), '0'))::varchar(1) as order_status
, try_to_date(nullif(substring(content, 90, 8), '00000000'), 'YYYYMMDD')::date as status_date
, try_to_time(nullif(substring(content, 98, 6), '000000'), 'HH24MISSFF6')::time as status_time
, trim(nullif(substring(content, 104, 1), '0'))::varchar(1) as systematic_reinvestment_system_srs_indicator
, trim(nullif(substring(content, 105, 4), '0000'))::varchar(4) as ip_1_split_id
, trim(nullif(substring(content, 109, 3), '000'))::varchar(3) as ip_1_split_percentage
, trim(nullif(substring(content, 112, 4), '0000'))::varchar(4) as ip_2_split_id
, trim(nullif(substring(content, 116, 3), '000'))::varchar(3) as ip_2_split_percentage
, trim(nullif(substring(content, 119, 8), '00000000'))::varchar(8) as status_operatoruser_id
, trim(nullif(substring(content, 127, 1), '0'))::varchar(1) as nav_indicator
, trim(nullif(substring(content, 128, 1), '0'))::varchar(1) as cdsc_waiver_indicator
, trim(nullif(substring(content, 129, 1), '0'))::varchar(1) as loiroa_indicator
, iff(substring(content, 148, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 130, 18)), '000000000000000000'), '')) / power(10, 09)::number as loiroa_cfrm_amount
, trim(nullif(substring(content, 148, 1), '0'))::varchar(1) as loiroa_cfrm_amount_sign
, trim(nullif(substring(content, 149, 20), '00000000000000000000'))::varchar(20) as roa_link_account
, try_to_date(nullif(substring(content, 169, 8), '00000000'), 'YYYYMMDD')::date as loi_date
, iff(substring(content, 195, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 177, 18)), '000000000000000000'), '')) / power(10, 10)::number as concession_amount
, trim(nullif(substring(content, 195, 1), '0'))::varchar(1) as concession_amount_sign
, trim(nullif(substring(content, 196, 1), '0'))::varchar(1) as ntf_indicator
, trim(nullif(substring(content, 197, 1), '0'))::varchar(1) as exchange_indicator
, trim(nullif(substring(content, 198, 1), '0'))::varchar(1) as grossnet_indicator
, trim(nullif(substring(content, 199, 1), '0'))::varchar(1) as full_indicator
, try_to_date(nullif(substring(content, 200, 8), '00000000'), 'YYYYMMDD')::date as trade_date
, try_to_date(nullif(substring(content, 208, 8), '00000000'), 'YYYYMMDD')::date as settlement_date
, trim(nullif(substring(content, 216, 1), '0'))::varchar(1) as fund_serv_indicator
, try_to_date(nullif(substring(content, 217, 8), '00000000'), 'YYYYMMDD')::date as confirm_date
, trim(nullif(substring(content, 225, 1), '0'))::varchar(1) as load_indicator
, iff(substring(content, 244, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 226, 18)), '000000000000000000'), '')) / power(10, 09)::number as deferred_sales_charge
, trim(nullif(substring(content, 244, 1), '0'))::varchar(1) as deferred_sales_charge_sign
, trim(nullif(substring(content, 245, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'B'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
