{%- macro acct_c_main_account_information_address_1_and_2(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as address_1_transaction_code
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as special_handling_indicator_1
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as delivery_identifier_1_address_type
, trim(nullif(substring(content, 44, 4), '0000'))::varchar(4) as attention_line_prefix_1
, trim(nullif(substring(content, 48, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_1
, trim(nullif(substring(content, 76, 32), '00000000000000000000000000000000'))::varchar(32) as address_1_line_1
, trim(nullif(substring(content, 108, 32), '00000000000000000000000000000000'))::varchar(32) as address_1_line_2
, trim(nullif(substring(content, 140, 32), '00000000000000000000000000000000'))::varchar(32) as address_1_line_3
, trim(nullif(substring(content, 172, 32), '00000000000000000000000000000000'))::varchar(32) as address_1_line_4
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 204, 15), '000000000000000')), '')::varchar(15) as city
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 219, 2), '00')), '')::varchar(2) as state
, iff(substring(content, 236, 2) in ('US', 'CA'), trim(nullif(substring(content, 221, 15), '000000000000000')), '')::varchar(15) as zip
, iff(substring(content, 236, 2) not in ('US', 'CA'), trim(nullif(substring(content, 204, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city
, trim(nullif(substring(content, 236, 2), '00'))::varchar(2) as country_code_1
-- , trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as not_used_4
, try_to_date(nullif(substring(content, 239, 8), '00000000'), 'YYYYMMDD')::date as most_recent_mail_return_date
, trim(nullif(substring(content, 247, 21), '000000000000000000000'))::varchar(21) as most_recent_return_comment
, trim(nullif(substring(content, 268, 4), '0000'))::varchar(4) as most_recent_return_mail_type
, try_to_date(nullif(substring(content, 272, 8), '00000000'), 'YYYYMMDD')::date as second_most_recent_mail_return_date
, trim(nullif(substring(content, 280, 21), '000000000000000000000'))::varchar(21) as second_most_recent_return_comment
, trim(nullif(substring(content, 301, 4), '0000'))::varchar(4) as second_most_recent_return_mail_type
, try_to_date(nullif(substring(content, 305, 8), '00000000'), 'YYYYMMDD')::date as third_most_recent_mail_return_date
, trim(nullif(substring(content, 313, 21), '000000000000000000000'))::varchar(21) as third_most_recent_return_comment
, trim(nullif(substring(content, 334, 4), '0000'))::varchar(4) as third_most_recent_return_mail_type
, trim(nullif(substring(content, 338, 1), '0'))::varchar(1) as address_2_transaction_code
, trim(nullif(substring(content, 339, 1), '0'))::varchar(1) as special_handling_indicator_2
, trim(nullif(substring(content, 340, 1), '0'))::varchar(1) as delivery_identifier_2
, trim(nullif(substring(content, 341, 4), '0000'))::varchar(4) as attention_line_prefix_2
, trim(nullif(substring(content, 345, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail_2
, trim(nullif(substring(content, 373, 32), '00000000000000000000000000000000'))::varchar(32) as address_2_line_1
, trim(nullif(substring(content, 405, 32), '00000000000000000000000000000000'))::varchar(32) as address_2_line_2
, trim(nullif(substring(content, 437, 32), '00000000000000000000000000000000'))::varchar(32) as address_2_line_3
, trim(nullif(substring(content, 469, 32), '00000000000000000000000000000000'))::varchar(32) as address_2_line_4
, iff(substring(content, 533, 2) in ('US', 'CA'), trim(nullif(substring(content, 501, 15), '000000000000000')), '')::varchar(15) as city_2
, iff(substring(content, 533, 2) in ('US', 'CA'), trim(nullif(substring(content, 516, 2), '00')), '')::varchar(2) as state_2
, iff(substring(content, 533, 2) in ('US', 'CA'), trim(nullif(substring(content, 518, 15), '000000000000000')), '')::varchar(15) as zip_2
, iff(substring(content, 533, 2) not in ('US', 'CA'), trim(nullif(substring(content, 501, 32), '00000000000000000000000000000000')), '')::varchar(32) as nonuscanada_city_2
, trim(nullif(substring(content, 533, 2), '00'))::varchar(2) as country_code_2
, trim(nullif(substring(content, 535, 32), '00000000000000000000000000000000'))::varchar(32) as account_description
, trim(nullif(substring(content, 567, 1), '0'))::varchar(1) as set_as_mailing_address_indicator_2
-- , trim(nullif(substring(content, 568, 33), '000000000000000000000000000000000'))::varchar(33) as not_used_5
, to_number(nullif(nullif(trim(substring(content, 601, 18)), '000000000000000000'), '')) / power(10, 09)::number as principal_billing_allocation_percentage
-- , trim(nullif(substring(content, 619, 16), '0000000000000000'))::varchar(16) as not_used_6
, trim(nullif(substring(content, 635, 1), '0'))::varchar(1) as seasonal_address_identifier
, try_to_date(nullif(substring(content, 636, 8), '00000000'), 'YYYYMMDD')::date as from_date
, try_to_date(nullif(substring(content, 644, 8), '00000000'), 'YYYYMMDD')::date as to_date
, trim(nullif(substring(content, 652, 1), '0'))::varchar(1) as seasonal_address_id
, try_to_date(nullif(substring(content, 653, 8), '00000000'), 'YYYYMMDD')::date as from_date_2
, try_to_date(nullif(substring(content, 661, 8), '00000000'), 'YYYYMMDD')::date as to_date_2
, trim(nullif(substring(content, 669, 1), '0'))::varchar(1) as seasonal_address_id_2
, try_to_date(nullif(substring(content, 670, 8), '00000000'), 'YYYYMMDD')::date as from_date_3
, try_to_date(nullif(substring(content, 678, 8), '00000000'), 'YYYYMMDD')::date as to_date_3
, trim(nullif(substring(content, 686, 4), '0000'))::varchar(4) as cost_basis_accounting_system
, trim(nullif(substring(content, 690, 2), '00'))::varchar(2) as disposition_method_for_mutual_funds
, trim(nullif(substring(content, 692, 2), '00'))::varchar(2) as disposition_method_for_all_other_security_types
, trim(nullif(substring(content, 694, 2), '00'))::varchar(2) as disposition_method_for_stocks_in_dividend_reinvestment
-- , trim(nullif(substring(content, 696, 1), '0'))::varchar(1) as not_used_7
, trim(nullif(substring(content, 697, 1), '0'))::varchar(1) as amortize_taxable_premium_bonds
, trim(nullif(substring(content, 698, 1), '0'))::varchar(1) as accrue_market_discount_based_on
, trim(nullif(substring(content, 699, 1), '0'))::varchar(1) as include_market_discount_in_income_annually
-- , trim(nullif(substring(content, 700, 6), '000000'))::varchar(6) as reserved
, trim(nullif(substring(content, 706, 42), '000000000000000000000000000000000000000000'))::varchar(42) as for_pershing_internal_use_only
-- , trim(nullif(substring(content, 748, 2), '00'))::varchar(2) as not_used_8
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'C'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
