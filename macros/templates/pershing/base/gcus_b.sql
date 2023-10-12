{%- macro gcus_b(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 22, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 31, 3), '000'))::varchar(3) as portfolio_currency
-- , trim(nullif(substring(content, 34, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 35, 9), '000000000'))::varchar(9) as underlying_cusip_number
, trim(nullif(substring(content, 44, 2), '00'))::varchar(2) as country_code
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 48, 3), '000'))
  else trim(nullif(substring(content, 47, 4), '0000'))
  end::varchar(4) as investment_professional_ip_of_record_number
, trim(nullif(substring(content, 51, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, iff(substring(content, 72, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 54, 18)), '000000000000000000'), '')) / power(10, 05)::number as fully_paid_lending_quantity
, trim(nullif(substring(content, 72, 1), '0'))::varchar(1) as fully_paid_lending_quantity_sign
, iff(substring(content, 91, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 73, 18)), '000000000000000000'), '')) / power(10, 03)::number as fully_paid_lending_quantity_collateral_amount
, trim(nullif(substring(content, 91, 1), '0'))::varchar(1) as fully_paid_lending_quantity_collateral_amount_sign
, trim(nullif(substring(content, 92, 6), '000000'))::varchar(6) as option_root_id
, try_to_date(nullif(substring(content, 98, 6), '000000'), 'YYMMDD')::date as expiration_date
, trim(nullif(substring(content, 104, 1), '0'))::varchar(1) as callput_indicator
, to_number(nullif(nullif(trim(substring(content, 105, 8)), '00000000'), '')) / power(10, 03)::number as strike_price
, iff(substring(content, 131, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 113, 18)), '000000000000000000'), '')) / power(10, 05)::number as trade_date_repo_quantity
, trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as trade_date_repo_quantity_sign
, iff(substring(content, 150, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 132, 18)), '000000000000000000'), '')) / power(10, 05)::number as settlement_date_repo_quantity
, trim(nullif(substring(content, 150, 1), '0'))::varchar(1) as settlement_date_repo_quantity_sign
, iff(substring(content, 169, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 151, 18)), '000000000000000000'), '')) / power(10, 05)::number as trade_date_reverse_repo_quantity
, trim(nullif(substring(content, 169, 1), '0'))::varchar(1) as trade_date_reverse_repo_quantity_sign
, iff(substring(content, 188, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 170, 18)), '000000000000000000'), '')) / power(10, 05)::number as settlement_date_reverse_repo_quantity
, trim(nullif(substring(content, 188, 1), '0'))::varchar(1) as settlement_date_reverse_repo_quantity_sign
, iff(substring(content, 207, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 189, 18)), '000000000000000000'), '')) / power(10, 05)::number as collateral_pledge_quantity
, trim(nullif(substring(content, 207, 1), '0'))::varchar(1) as collateral_pledge_quantity_sign
, to_number(nullif(nullif(trim(substring(content, 208, 18)), '000000000000000000'), '')) / power(10, 05)::number as corporate_executive_services_collateral_pledge
, trim(nullif(substring(content, 226, 1), '0'))::varchar(1) as corporate_executive_services_collateral_pledge_2
, iff(substring(content, 245, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 227, 18)), '000000000000000000'), '')) / power(10, 03)::number as trade_date_repo_liquidating_value
, trim(nullif(substring(content, 245, 1), '0'))::varchar(1) as trade_date_repo_liquidating_value_sign
, iff(substring(content, 264, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 246, 18)), '000000000000000000'), '')) / power(10, 03)::number as settlement_date_repo_liquidating_value
, trim(nullif(substring(content, 264, 1), '0'))::varchar(1) as settlement_date_repo_liquidating_value_sign
, iff(substring(content, 283, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 265, 18)), '000000000000000000'), '')) / power(10, 03)::number as trade_date_reverse_repo_liquidating_value
, trim(nullif(substring(content, 283, 1), '0'))::varchar(1) as trade_date_reverse_repo_liquidating_value_sign
, iff(substring(content, 302, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 284, 18)), '000000000000000000'), '')) / power(10, 03)::number as settlement_date_reverse_repo_liquidating_value
, trim(nullif(substring(content, 302, 1), '0'))::varchar(1) as settlement_date_reverse_repo_liquidating_value_sign
, iff(substring(content, 321, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 303, 18)), '000000000000000000'), '')) / power(10, 03)::number as collateral_pledge_liquidating_value
, trim(nullif(substring(content, 321, 1), '0'))::varchar(1) as collateral_pledge_liquidating_value_sign
, to_number(nullif(nullif(trim(substring(content, 322, 18)), '000000000000000000'), '')) / power(10, 03)::number as corporate_executive_services_collateral_pledge_3
, trim(nullif(substring(content, 340, 1), '0'))::varchar(1) as corporate_executive_services_collateral_pledge_4
, iff(substring(content, 359, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 341, 18)), '000000000000000000'), '')) / power(10, 03)::number as trade_date_repo_loan_amount
, trim(nullif(substring(content, 359, 1), '0'))::varchar(1) as trade_date_repo_loan_amount_sign
, iff(substring(content, 378, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 360, 18)), '000000000000000000'), '')) / power(10, 03)::number as settlement_date_repo_loan_amount
, trim(nullif(substring(content, 378, 1), '0'))::varchar(1) as settlement_date_repo_loan_amount_sign
, iff(substring(content, 397, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 379, 18)), '000000000000000000'), '')) / power(10, 03)::number as trade_date_reverse_repo_loan_amount
, trim(nullif(substring(content, 397, 1), '0'))::varchar(1) as trade_date_reverse_repo_loan_amount_sign
, iff(substring(content, 416, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 398, 18)), '000000000000000000'), '')) / power(10, 03)::number as settlement_date_reverse_repo_loan_amount
, trim(nullif(substring(content, 416, 1), '0'))::varchar(1) as settlement_date_reverse_repo_loan_amount_sign
, iff(substring(content, 435, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 417, 18)), '000000000000000000'), '')) / power(10, 03)::number as accrued_interest_value_from_last_payable_date
, trim(nullif(substring(content, 435, 1), '0'))::varchar(1) as accrued_interest_value_sign
, to_number(nullif(nullif(trim(substring(content, 436, 18)), '000000000000000000'), '')) / power(10, 09)::number as dividend_or_coupon_rate
, iff(substring(content, 472, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 454, 18)), '000000000000000000'), '')) / power(10, 03)::number as pending_split_quantity_liquidating_value
, trim(nullif(substring(content, 472, 1), '0'))::varchar(1) as pending_split_quantity_liquidating_value_sign
, trim(nullif(substring(content, 473, 38), '00000000000000000000000000000000000000'))::varchar(38) as for_pershing_internal_use_only
, trim(nullif(substring(content, 511, 16), '0000000000000000'))::varchar(16) as international_nondollar_symbol
, iff(substring(content, 545, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 527, 18)), '000000000000000000'), '')) / power(10, 05)::number as pledged_quantity_memo
, trim(nullif(substring(content, 545, 1), '0'))::varchar(1) as pledged_quantity_sign
-- , trim(nullif(substring(content, 546, 204), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(204) as not_used_3
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
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
