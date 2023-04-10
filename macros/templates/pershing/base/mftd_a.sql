{%- macro mftd_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 10, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 20, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 29, 20), '00000000000000000000'))::varchar(20) as cusip_description
, trim(nullif(substring(content, 49, 32), '00000000000000000000000000000000'))::varchar(32) as account_name
, trim(nullif(substring(content, 81, 3), '000'))::varchar(3) as investment_professional_ip_number
, nullif(nullif(trim(substring(content, 84, 10)), '0000000000'), '')::int as ip_home_phone_number
, nullif(nullif(trim(substring(content, 94, 10)), '0000000000'), '')::int as ip_business_phone_number
, trim(nullif(substring(content, 104, 1), '0'))::varchar(1) as trade_status
, trim(nullif(substring(content, 105, 6), '000000'))::varchar(6) as reference_number
, trim(nullif(substring(content, 111, 1), '0'))::varchar(1) as mutual_fund_transaction_type
, iff(substring(content, 123, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 112, 11)), '00000000000'), '')) / power(10, 04)::number as share_quantity
, trim(nullif(substring(content, 123, 1), '0'))::varchar(1) as share_quantity_sign
, to_number(nullif(nullif(trim(substring(content, 124, 15)), '000000000000000'), '')) / power(10, 06)::number as dollar_amount_payable
-- , iff(substring(content, 142, 1) = '-', -1, 1) * trim(nullif(substring(content, 139, 3), '000'))::varchar(3) as not_used
, trim(nullif(substring(content, 142, 1), '0'))::varchar(1) as dollar_amount_payable_sign
, to_number(nullif(nullif(trim(substring(content, 143, 15)), '000000000000000'), '')) / power(10, 06)::number as commission
-- , iff(substring(content, 161, 1) = '-', -1, 1) * trim(nullif(substring(content, 158, 3), '000'))::varchar(3) as not_used_2
, trim(nullif(substring(content, 161, 1), '0'))::varchar(1) as commission_sign
, trim(nullif(substring(content, 162, 1), '0'))::varchar(1) as cash_reinvest_indicator
, trim(nullif(substring(content, 163, 1), '0'))::varchar(1) as overunder_price_indicator
, try_to_date(nullif(substring(content, 164, 8), '00000000'), 'YYYYMMDD')::date as date_of_data
, try_to_time(nullif(substring(content, 172, 6), '000000'), 'HH24MISSFF6')::time as time_of_data
, trim(nullif(substring(content, 178, 8), '00000000'))::varchar(8) as user_id
, trim(nullif(substring(content, 186, 3), '000'))::varchar(3) as ibd_number
, try_to_date(nullif(substring(content, 189, 8), '00000000'), 'YYYYMMDD')::date as order_entry_date
, try_to_time(nullif(substring(content, 197, 6), '000000'), 'HH24MISSFF6')::time as order_entry_time
, iff(substring(content, 221, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 203, 18)), '000000000000000000'), '')) / power(10, 09)::number as net_amount
, trim(nullif(substring(content, 221, 1), '0'))::varchar(1) as net_amount_sign
, iff(substring(content, 240, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 222, 18)), '000000000000000000'), '')) / power(10, 10)::number as price
, trim(nullif(substring(content, 240, 1), '0'))::varchar(1) as price_sign
, trim(nullif(substring(content, 241, 1), '0'))::varchar(1) as solicit_indicator
, trim(nullif(substring(content, 242, 2), '00'))::varchar(2) as source_of_input_soi
, trim(nullif(substring(content, 244, 1), '0'))::varchar(1) as share_class_reviewed
, trim(nullif(substring(content, 245, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
