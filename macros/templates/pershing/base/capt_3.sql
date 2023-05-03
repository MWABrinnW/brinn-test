{%- macro capt_3(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 4, 1), '0'))::varchar(1) as record_id
, trim(nullif(substring(content, 5, 1), '0'))::varchar(1) as as_of_trade_indicator
, trim(nullif(substring(content, 6, 1), '0'))::varchar(1) as distribution_indicator
, trim(nullif(substring(content, 7, 1), '0'))::varchar(1) as explode_indicator
, trim(nullif(substring(content, 8, 1), '0'))::varchar(1) as revenue_type
, trim(nullif(substring(content, 9, 3), '000'))::varchar(3) as investment_professional_ip_number
, trim(nullif(substring(content, 12, 3), '000'))::varchar(3) as investment_professional_caps_revenue_center
, trim(nullif(substring(content, 15, 3), '000'))::varchar(3) as investment_professional_caps_office_number
, signed_to_numeric(nullif(nullif(trim(substring(content, 18, 6)), '000000'), '')) / power(10, 03)::number as investment_professional_split_percent
, signed_to_numeric(nullif(nullif(trim(substring(content, 24, 13)), '0000000000000'), '')) / power(10, 02)::number as total_amount_of_revenue_generated_by_the_transaction
, signed_to_numeric(nullif(nullif(trim(substring(content, 37, 11)), '00000000000'), '')) / power(10, 02)::number as pershing_charge
, trim(nullif(substring(content, 48, 3), '000'))::varchar(3) as from_investment_professional_number
, trim(nullif(substring(content, 51, 3), '000'))::varchar(3) as caps_revenue_center_associated_with_the_from
, trim(nullif(substring(content, 54, 3), '000'))::varchar(3) as caps_office_number_associated_with_the_from
, signed_to_numeric(nullif(nullif(trim(substring(content, 57, 13)), '0000000000000'), '')) / power(10, 02)::number as total_order_commission
, trim(nullif(substring(content, 70, 1), '0'))::varchar(1) as spread__straddle_mutual_fund_values
, trim(nullif(substring(content, 71, 1), '0'))::varchar(1) as correction_code
, trim(nullif(substring(content, 72, 1), '0'))::varchar(1) as security_modifier
, trim(nullif(substring(content, 73, 1), '0'))::varchar(1) as security_calculation_code
, signed_to_numeric(nullif(nullif(trim(substring(content, 74, 13)), '0000000000000'), '')) / power(10, 02)::number as principal
, trim(nullif(substring(content, 87, 7), '0000000'))::varchar(7) as crd_number
, trim(nullif(substring(content, 94, 2), '00'))::varchar(2) as source_of_input
, trim(nullif(substring(content, 96, 25), '0000000000000000000000000'))::varchar(25) as for_pershing_internal_use_only
, signed_to_numeric(nullif(nullif(trim(substring(content, 121, 13)), '0000000000000'), '')) / power(10, 02)::number as service_chargeother_fee
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 4, 1) = '3'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
