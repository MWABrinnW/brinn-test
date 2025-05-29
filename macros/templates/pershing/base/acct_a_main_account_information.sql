{%- macro acct_a_main_account_information(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as transaction_type
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as autotitled_or_usertitled_account
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as account_type_code
, trim(nullif(substring(content, 44, 4), '0000'))::varchar(4) as registration_type
-- , trim(nullif(substring(content, 48, 1), '0'))::varchar(1) as reserved
, trim(nullif(substring(content, 49, 1), '0'))::varchar(1) as number_of_account_title_lines_in_registration_lines
, trim(nullif(substring(content, 50, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_1
, trim(nullif(substring(content, 82, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_2
, trim(nullif(substring(content, 114, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_3
, trim(nullif(substring(content, 146, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_4
, trim(nullif(substring(content, 178, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_5
, trim(nullif(substring(content, 210, 32), '00000000000000000000000000000000'))::varchar(32) as account_registration_line_6




















, try_to_date(nullif(substring(content, 263, 8), '00000000'), 'YYYYMMDD')::date as date_account_opened
, nullif(nullif(trim(substring(content, 271, 8)), '00000000'), '')::int as date_account_information_updated
, trim(nullif(substring(content, 279, 1), '0'))::varchar(1) as account_status_indicator
, try_to_date(nullif(substring(content, 280, 8), '00000000'), 'YYYYMMDD')::date as pending_closed_date
, try_to_date(nullif(substring(content, 288, 8), '00000000'), 'YYYYMMDD')::date as date_account_closed
, try_to_date(nullif(substring(content, 296, 8), '00000000'), 'YYYYMMDD')::date as closing_notice_date
, try_to_date(nullif(substring(content, 304, 8), '00000000'), 'YYYYMMDD')::date as account_reactivated_date
, try_to_date(nullif(substring(content, 312, 8), '00000000'), 'YYYYMMDD')::date as date_account_reopened
, trim(nullif(substring(content, 320, 1), '0'))::varchar(1) as proceeds
, trim(nullif(substring(content, 321, 1), '0'))::varchar(1) as transfer_instructions
, trim(nullif(substring(content, 322, 1), '0'))::varchar(1) as income_instructions
, trim(nullif(substring(content, 323, 2), '00'))::varchar(2) as number_of_confirms_for_this_account
, trim(nullif(substring(content, 325, 2), '00'))::varchar(2) as number_of_statements_for_this_account
, trim(nullif(substring(content, 327, 1), '0'))::varchar(1) as investment_objective_transaction_code
, trim(nullif(substring(content, 328, 26), '00000000000000000000000000'))::varchar(26) as comments
, trim(nullif(substring(content, 354, 15), '000000000000000'))::varchar(15) as employer_shortname
, trim(nullif(substring(content, 369, 9), '000000000'))::varchar(9) as employers_cusip
, trim(nullif(substring(content, 378, 9), '000000000'))::varchar(9) as employers_symbol
, trim(nullif(substring(content, 387, 1), '0'))::varchar(1) as margin_privileges_revoked
, try_to_date(nullif(substring(content, 388, 8), '00000000'), 'YYYYMMDD')::date as statement_review_date
, trim(nullif(substring(content, 396, 1), '0'))::varchar(1) as margin_papers_on_file
, trim(nullif(substring(content, 397, 1), '0'))::varchar(1) as option_papers_on_file
, trim(nullif(substring(content, 398, 1), '0'))::varchar(1) as for_pershing_internal_use_only
, trim(nullif(substring(content, 399, 1), '0'))::varchar(1) as good_faith_margin
, trim(nullif(substring(content, 400, 1), '0'))::varchar(1) as investment_professional_discretion_granted
, trim(nullif(substring(content, 401, 1), '0'))::varchar(1) as investment_advisor_discretion_granted
, trim(nullif(substring(content, 402, 1), '0'))::varchar(1) as third_party_discretion_granted
, trim(nullif(substring(content, 403, 15), '000000000000000'))::varchar(15) as third_party_name
, trim(nullif(substring(content, 418, 1), '0'))::varchar(1) as risk_factor_code
, trim(nullif(substring(content, 419, 4), '0000'))::varchar(4) as investment_objective_code
, trim(nullif(substring(content, 423, 1), '0'))::varchar(1) as option__equities
, trim(nullif(substring(content, 424, 1), '0'))::varchar(1) as option__index
, trim(nullif(substring(content, 425, 1), '0'))::varchar(1) as option__debt
, trim(nullif(substring(content, 426, 1), '0'))::varchar(1) as option__currency
, trim(nullif(substring(content, 427, 1), '0'))::varchar(1) as option_level_1
, trim(nullif(substring(content, 428, 1), '0'))::varchar(1) as option_level_2
, trim(nullif(substring(content, 429, 1), '0'))::varchar(1) as option_level_3
, trim(nullif(substring(content, 430, 1), '0'))::varchar(1) as option_level_4
, nullif(nullif(trim(substring(content, 431, 10)), '0000000000'), '')::int as option__call_limits
, nullif(nullif(trim(substring(content, 441, 10)), '0000000000'), '')::int as option__put_limits
, nullif(nullif(trim(substring(content, 451, 10)), '0000000000'), '')::int as option__total_limits_of_puts_and_calls
, trim(nullif(substring(content, 461, 1), '0'))::varchar(1) as nonus_dollar_trading
, trim(nullif(substring(content, 462, 3), '000'))::varchar(3) as not_used_reserved_for_future_use
, trim(nullif(substring(content, 465, 1), '0'))::varchar(1) as noncustomer_indicator
, trim(nullif(substring(content, 466, 2), '00'))::varchar(2) as third_party_fee_indicator
, try_to_date(nullif(substring(content, 468, 8), '00000000'), 'YYYYMMDD')::date as third_party_fee_approval_date
, trim(nullif(substring(content, 476, 1), '0'))::varchar(1) as intermediary_account_indicator
, trim(nullif(substring(content, 477, 2), '00'))::varchar(2) as commission_schedule
, trim(nullif(substring(content, 479, 5), '00000'))::varchar(5) as group_index
, trim(nullif(substring(content, 484, 3), '000'))::varchar(3) as money_manager_id
, trim(nullif(substring(content, 487, 3), '000'))::varchar(3) as money_manager_objective_id
, trim(nullif(substring(content, 490, 5), '00000'))::varchar(5) as dtc_id_confirm_number_for_noncod_account
, trim(nullif(substring(content, 495, 9), '000000000'))::varchar(9) as caps_master_mnemonic
, trim(nullif(substring(content, 504, 8), '00000000'))::varchar(8) as employee_id
, trim(nullif(substring(content, 512, 1), '0'))::varchar(1) as prime_brokerfree_fund_indicator
, trim(nullif(substring(content, 513, 1), '0'))::varchar(1) as fee_based_account_indicator
, trim(nullif(substring(content, 514, 3), '000'))::varchar(3) as pershing_internal_use_only
, try_to_date(nullif(substring(content, 517, 8), '00000000'), 'YYYYMMDD')::date as fee_based_termination_date
-- , trim(nullif(substring(content, 525, 1), '0'))::varchar(1) as not_used_7
, trim(nullif(substring(content, 526, 32), '00000000000000000000000000000000'))::varchar(32) as plan_name
, trim(nullif(substring(content, 558, 32), '00000000000000000000000000000000'))::varchar(32) as selfdirected_401k_account_type
, trim(nullif(substring(content, 590, 2), '00'))::varchar(2) as plan_type
, trim(nullif(substring(content, 592, 10), '0000000000'))::varchar(10) as plan_number
, trim(nullif(substring(content, 602, 4), '0000'))::varchar(4) as employeeemployee_relative_indicator
, to_number(nullif(nullif(trim(substring(content, 606, 18)), '000000000000000000'), '')) / power(10, 09)::number as commission_percent_discount
, trim(nullif(substring(content, 624, 1), '0'))::varchar(1) as block_mutual_fund_fees
, trim(nullif(substring(content, 625, 15), '000000000000000'))::varchar(15) as name_of_investment_professional_who_signed_new
, try_to_date(nullif(substring(content, 640, 8), '00000000'), 'YYYYMMDD')::date as date_investment_professional_signed_new_account_form
, trim(nullif(substring(content, 648, 15), '000000000000000'))::varchar(15) as name_of_principal_who_signed_new_account_form
, try_to_date(nullif(substring(content, 663, 8), '00000000'), 'YYYYMMDD')::date as date_principal_signed_new_account_form
, trim(nullif(substring(content, 671, 1), '0'))::varchar(1) as politically_exposed_person_indicator
, trim(nullif(substring(content, 672, 1), '0'))::varchar(1) as private_banking_account_indicator
, trim(nullif(substring(content, 673, 1), '0'))::varchar(1) as foreign_bank_account_indicator
, trim(nullif(substring(content, 674, 4), '0000'))::varchar(4) as initial_source_of_funds
, trim(nullif(substring(content, 678, 4), '0000'))::varchar(4) as usa_patriot_act_exempt_reason
, trim(nullif(substring(content, 682, 2), '00'))::varchar(2) as primary_country_of_citizenship
, trim(nullif(substring(content, 684, 2), '00'))::varchar(2) as country_of_residence
, try_to_date(nullif(substring(content, 686, 8), '00000000'), 'YYYYMMDD')::date as birth_date
, trim(nullif(substring(content, 694, 1), '0'))::varchar(1) as agebased_fund_roll_exempt_indicator
, trim(nullif(substring(content, 695, 1), '0'))::varchar(1) as money_fund_reform__retail
, trim(nullif(substring(content, 696, 1), '0'))::varchar(1) as trusted_contact_status
, trim(nullif(substring(content, 697, 4), '0000'))::varchar(4) as regulatory_account_type_category
, trim(nullif(substring(content, 701, 1), '0'))::varchar(1) as account_managed_by_trust_company_indicator
, trim(nullif(substring(content, 702, 2), '00'))::varchar(2) as voting_authority
, trim(nullif(substring(content, 704, 6), '000000'))::varchar(6) as internal_use
, trim(nullif(substring(content, 710, 2), '00'))::varchar(2) as internal_use_2
, trim(nullif(substring(content, 712, 3), '000'))::varchar(3) as internal_use_3
, trim(nullif(substring(content, 715, 4), '0000'))::varchar(4) as internal_use_4
, trim(nullif(substring(content, 719, 4), '0000'))::varchar(4) as customer_type
, trim(nullif(substring(content, 723, 4), '0000'))::varchar(4) as internal_use_5
, trim(nullif(substring(content, 727, 4), '0000'))::varchar(4) as internal_use_6
, trim(nullif(substring(content, 731, 4), '0000'))::varchar(4) as internal_use_7
, trim(nullif(substring(content, 735, 4), '0000'))::varchar(4) as internal_use_8
, trim(nullif(substring(content, 739, 4), '0000'))::varchar(4) as internal_use_9
, trim(nullif(substring(content, 743, 4), '0000'))::varchar(4) as fulfillment_method
, trim(nullif(substring(content, 747, 1), '0'))::varchar(1) as credit_interest_indicator
, trim(nullif(substring(content, 748, 1), '0'))::varchar(1) as ama_indicator
, trim(nullif(substring(content, 749, 1), '0'))::varchar(1) as for_pershing_internal_use_only_2
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _created_at
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
