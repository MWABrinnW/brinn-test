{%- macro acct_4_kyc_investment_knowledge_bank_custody_information_aml_risk_ratings(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as record_transaction_code
, trim(nullif(substring(content, 42, 4), '0000'))::varchar(4) as account_suitability_obligation
, trim(nullif(substring(content, 46, 1), '0'))::varchar(1) as equities
, trim(nullif(substring(content, 47, 1), '0'))::varchar(1) as options
, trim(nullif(substring(content, 48, 1), '0'))::varchar(1) as fixed_income
, trim(nullif(substring(content, 49, 1), '0'))::varchar(1) as mutual_funds
, trim(nullif(substring(content, 50, 1), '0'))::varchar(1) as unit_investment_trusts
, trim(nullif(substring(content, 51, 1), '0'))::varchar(1) as exchange_traded_funds
, trim(nullif(substring(content, 52, 30), '000000000000000000000000000000'))::varchar(30) as other_investment_type
, trim(nullif(substring(content, 82, 1), '0'))::varchar(1) as other_investment_type_value
, to_number(nullif(nullif(trim(substring(content, 83, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_equity_investments_value
, to_number(nullif(nullif(trim(substring(content, 101, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_option_investments_value
, to_number(nullif(nullif(trim(substring(content, 119, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_fixed_income_investments_value
, to_number(nullif(nullif(trim(substring(content, 137, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_mutual_funds_investments_value
, to_number(nullif(nullif(trim(substring(content, 155, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_unit_investment_trust_investments_value
, to_number(nullif(nullif(trim(substring(content, 173, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_exchange_traded_fund_investments_value
, to_number(nullif(nullif(trim(substring(content, 191, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_real_estate_investments_value
, to_number(nullif(nullif(trim(substring(content, 209, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_insurance_investments_value
, to_number(nullif(nullif(trim(substring(content, 227, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_annuities_variable_investments_value
, to_number(nullif(nullif(trim(substring(content, 245, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_annuities_fixed_investments_value
, to_number(nullif(nullif(trim(substring(content, 263, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_precious_metals_investments_value
, to_number(nullif(nullif(trim(substring(content, 281, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_commodities_and_futures_investments_value
, trim(nullif(substring(content, 299, 30), '000000000000000000000000000000'))::varchar(30) as other_not_listed_type_one
, to_number(nullif(nullif(trim(substring(content, 329, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_not_listed_type_one_investments_value
, trim(nullif(substring(content, 347, 30), '000000000000000000000000000000'))::varchar(30) as other_not_listed_type_two
, to_number(nullif(nullif(trim(substring(content, 377, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_not_listed_type_two_investments_value
, trim(nullif(substring(content, 395, 30), '000000000000000000000000000000'))::varchar(30) as other_not_listed_type_three
, to_number(nullif(nullif(trim(substring(content, 425, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_not_listed_type_three_investments_value
, trim(nullif(substring(content, 443, 30), '000000000000000000000000000000'))::varchar(30) as other_not_listed_type_four
, to_number(nullif(nullif(trim(substring(content, 473, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_not_listed_type_four_investments_value
, trim(nullif(substring(content, 491, 30), '000000000000000000000000000000'))::varchar(30) as other_not_listed_type_five
, to_number(nullif(nullif(trim(substring(content, 521, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_not_listed_type_five_investments_value
, try_to_date(nullif(substring(content, 539, 8), '00000000'), '')::date as investment_time_horizon
, trim(nullif(substring(content, 547, 1), '0'))::varchar(1) as liquidity_needs
, trim(nullif(substring(content, 548, 2), '00'))::varchar(2) as time_horizon_range
-- , trim(nullif(substring(content, 550, 6), '000000'))::varchar(6) as not_used_4
, trim(nullif(substring(content, 556, 1), '0'))::varchar(1) as are_there_other_investments
, trim(nullif(substring(content, 557, 1), '0'))::varchar(1) as securitized_product_approval_level
, try_to_date(nullif(substring(content, 558, 6), '000000'), 'YYYYMM')::date as securitized_product_disclosure_mailing_date
-- , trim(nullif(substring(content, 564, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 566, 1), '0'))::varchar(1) as speculation
, trim(nullif(substring(content, 567, 8), '00000000'))::varchar(8) as for_pershing_internal_use_only
, trim(nullif(substring(content, 575, 36), '000000000000000000000000000000000000'))::varchar(36) as assets_of_the_plan
, nullif(nullif(trim(substring(content, 611, 2)), '00'), '')::int as exempt_payee_code
, trim(nullif(substring(content, 613, 1), '0'))::varchar(1) as exemption_from_fatca_reporting_code
, trim(nullif(substring(content, 614, 1), '0'))::varchar(1) as principalincome_accounting_indicator
, trim(nullif(substring(content, 615, 4), '0000'))::varchar(4) as bnym_capacity
, trim(nullif(substring(content, 619, 4), '0000'))::varchar(4) as firmclient_capacity
, trim(nullif(substring(content, 623, 4), '0000'))::varchar(4) as investment_authority
, nullif(nullif(trim(substring(content, 627, 4)), '0000'), '')::int as fiscal_year_end_date
-- , trim(nullif(substring(content, 631, 3), '000'))::varchar(3) as reserved
, trim(nullif(substring(content, 634, 1), '0'))::varchar(1) as skip_tax_reclaim_processing
, try_to_date(nullif(substring(content, 635, 8), '00000000'), 'YYYYMMDD')::date as last_investment_review_date
, try_to_date(nullif(substring(content, 643, 8), '00000000'), 'YYYYMMDD')::date as last_administrative_review_date
, trim(nullif(substring(content, 651, 1), '0'))::varchar(1) as overdrafts_allowed
, trim(nullif(substring(content, 652, 9), '000000000'))::varchar(9) as reserved_for_introducing_firm
, trim(nullif(substring(content, 661, 4), '0000'))::varchar(4) as reserved_for_booking_entity
, trim(nullif(substring(content, 665, 4), '0000'))::varchar(4) as reserved_for_booking_entity_business_code
, trim(nullif(substring(content, 669, 1), '0'))::varchar(1) as high_number_of_anticipated_transactions
, trim(nullif(substring(content, 670, 1), '0'))::varchar(1) as account_requires_special_services
, trim(nullif(substring(content, 671, 4), '0000'))::varchar(4) as special_service_required
, trim(nullif(substring(content, 675, 4), '0000'))::varchar(4) as special_service_required_2
, trim(nullif(substring(content, 679, 4), '0000'))::varchar(4) as special_service_required_3
, trim(nullif(substring(content, 683, 4), '0000'))::varchar(4) as special_service_required_4
, trim(nullif(substring(content, 687, 4), '0000'))::varchar(4) as special_service_required_5
, trim(nullif(substring(content, 691, 4), '0000'))::varchar(4) as special_service_required_6
, trim(nullif(substring(content, 695, 4), '0000'))::varchar(4) as special_service_required_7
-- , trim(nullif(substring(content, 699, 20), '00000000000000000000'))::varchar(20) as reserved_2
, trim(nullif(substring(content, 719, 9), '000000000'))::varchar(9) as pershing_plan_number
, trim(nullif(substring(content, 728, 1), '0'))::varchar(1) as _exempt_status
, trim(nullif(substring(content, 729, 1), '0'))::varchar(1) as msfta_received
, nullif(nullif(trim(substring(content, 730, 10)), '0000000000'), '')::int as covered_securities_limit
, trim(nullif(substring(content, 740, 1), '0'))::varchar(1) as account_is_high_risk
, nullif(nullif(trim(substring(content, 741, 6)), '000000'), '')::int as mtm_limit
, trim(nullif(substring(content, 747, 3), '000'))::varchar(3) as reserved_for_future_expansion
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = '4'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
