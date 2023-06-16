{%- macro actv_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 17, 3), '000'))::varchar(3) as investment_professional_ip_number
, trim(nullif(substring(content, 20, 4), '0000'))::varchar(4) as fund_mnemonic
, trim(nullif(substring(content, 24, 8), '00000000'))::varchar(8) as fund_manager
, trim(nullif(substring(content, 32, 15), '000000000000000'))::varchar(15) as account_number_at_fund
, try_to_date(nullif(substring(content, 47, 8), '00000000'), 'YYYYMMDD')::date as date_received
, try_to_date(nullif(substring(content, 55, 8), '00000000'), 'YYYYMMDD')::date as as_of_date
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 63, 12)), '000000000000'), '')) / power(10, 02)::number as amount_of_transaction
-- , trim(nullif(substring(content, 75, 5), '00000'))::varchar(5) as not_used
, trim(nullif(substring(content, 80, 4), '0000'))::varchar(4) as activity_codes
, trim(nullif(substring(content, 84, 30), '000000000000000000000000000000'))::varchar(30) as description
, trim(nullif(substring(content, 114, 9), '000000000'))::varchar(9) as cusip
-- , trim(nullif(substring(content, 123, 5), '00000'))::varchar(5) as not_used_2
, trim(nullif(substring(content, 128, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as reserved
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
