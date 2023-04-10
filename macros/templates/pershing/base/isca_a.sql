{%- macro isca_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 17, 1), '0'))::varchar(1) as security_type
, trim(nullif(substring(content, 18, 1), '0'))::varchar(1) as security_modifier
, trim(nullif(substring(content, 19, 1), '0'))::varchar(1) as security_calculation_code
, trim(nullif(substring(content, 20, 1), '0'))::varchar(1) as primary_exchange
, signed_to_numeric(nullif(nullif(trim(substring(content, 21, 7)), '0000000'), '')) / power(10, 03)::number as coupon_rate_for_fixed_income_securities_or_indicated
, YYYYDDD_to_date(nullif(substring(content, 28, 7), '0000000'))::date as maturityoption_expire_date
, trim(nullif(substring(content, 35, 9), '000000000'))::varchar(9) as underlying_security_cusip
, signed_to_numeric(nullif(nullif(trim(substring(content, 44, 9)), '000000000'), '')) / power(10, 04)::number as first_call_price_for_fixed_income_or_strike_price_for_option
, signed_to_numeric(nullif(nullif(trim(substring(content, 53, 9)), '000000000'), '')) / power(10, 04)::number as first_par_call_price_for_fixed_income_or_units_for_option
, trim(nullif(substring(content, 62, 10), '0000000000'))::varchar(10) as primary_symbol
, trim(nullif(substring(content, 72, 2), '00'))::varchar(2) as interest_frequency
, trim(nullif(substring(content, 74, 1), '0'))::varchar(1) as bond_class
, trim(nullif(substring(content, 75, 2), '00'))::varchar(2) as first_coupon_day
, trim(nullif(substring(content, 77, 1), '0'))::varchar(1) as call_indicator
, trim(nullif(substring(content, 78, 1), '0'))::varchar(1) as put_indicator
, YYYYDDD_to_date(nullif(substring(content, 79, 7), '0000000'))::date as next_par_call_date
, YYYYDDD_to_date(nullif(substring(content, 86, 7), '0000000'))::date as prerefunded_date
, YYYYDDD_to_date(nullif(substring(content, 93, 7), '0000000'))::date as next_premium_call_date
, YYYYDDD_to_date(nullif(substring(content, 100, 7), '0000000'))::date as dated_date_for_fixed_income_or_ex_dividend_date_for_ccyyddd
, YYYYDDD_to_date(nullif(substring(content, 107, 7), '0000000'))::date as first_coupon_for_fixed_income_or_payable_date_for_equity
, nullif(nullif(trim(substring(content, 114, 7)), '0000000'), '')::int as for_pershing_internal_use
, trim(nullif(substring(content, 121, 1), '0'))::varchar(1) as federal_marginable_indicator
, trim(nullif(substring(content, 122, 1), '0'))::varchar(1) as continuous_net_settlement_cns_eligible_code
, trim(nullif(substring(content, 123, 1), '0'))::varchar(1) as depository_trust_and_clearing_corporation_dtcc
, trim(nullif(substring(content, 124, 1), '0'))::varchar(1) as national_securities_clearing_corporation_nscc_eligible
, trim(nullif(substring(content, 125, 1), '0'))::varchar(1) as foreign_security
, trim(nullif(substring(content, 126, 2), '00'))::varchar(2) as second_coupon_day
, trim(nullif(substring(content, 128, 1), '0'))::varchar(1) as dividendinterest_payment_method
, trim(nullif(substring(content, 129, 3), '000'))::varchar(3) as minor_product_code
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
