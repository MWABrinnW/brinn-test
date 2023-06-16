{%- macro capt_4(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 4, 1), '0'))::varchar(1) as record_id
, trim(nullif(substring(content, 5, 3), '000'))::varchar(3) as currency_code
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 8, 18)), '000000000000000000'), '')) / power(10, 03)::number as currency_amount_of_revenue
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 26, 18)), '000000000000000000'), '')) / power(10, 10)::number as foreign_exchange_rate
, trim(nullif(substring(content, 44, 1), '0'))::varchar(1) as currency_multidiv_indicator
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 45, 18)), '000000000000000000'), '')) / power(10, 03)::number as ibd_settlement_fee
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 63, 18)), '000000000000000000'), '')) / power(10, 03)::number as customer_settlement_fee
, trim(nullif(substring(content, 81, 20), '00000000000000000000'))::varchar(20) as gloss_reference_number
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 101, 11)), '00000000000'), '')) / power(10, 02)::number as currency_amount_of_pershing_charge
-- , trim(nullif(substring(content, 112, 22), '0000000000000000000000'))::varchar(22) as not_used
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 4, 1) = '4'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
