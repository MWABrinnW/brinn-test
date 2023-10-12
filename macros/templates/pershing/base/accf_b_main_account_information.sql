{%- macro accf_b_main_account_information(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(b.content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(b.content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(b.content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(b.content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(b.content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(b.content, 24, 1), '0'))::varchar(1) as not_used
, case
  when b.effective_date < '2023-10-01'
    then trim(nullif(substring(b.content, 25, 3), '000'))
  else trim(nullif(substring(b.content, 25, 4), '0000'))
  end::varchar(4) as investment_professional_ip_number
, trim(nullif(substring(b.content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(b.content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(b.content, 41, 1), '0'))::varchar(1) as tax_id_type
, trim(nullif(substring(b.content, 42, 9), '000000000'))::varchar(9) as tax_id_number
, try_to_date(nullif(substring(b.content, 51, 8), '00000000'), 'YYYYMMDD')::date as date_tax_id_applied_for
, trim(nullif(substring(b.content, 59, 2), '00'))::varchar(2) as w8w9_indicator
, try_to_date(nullif(substring(b.content, 61, 8), '00000000'), 'YYYYMMDD')::date as w8w9_date_date_signed
, try_to_date(nullif(substring(b.content, 69, 8), '00000000'), 'YYYYMMDD')::date as w8w9_effective_received_date
, trim(nullif(substring(b.content, 77, 4), '0000'))::varchar(4) as w8w9_document_type
, trim(nullif(substring(b.content, 81, 1), '0'))::varchar(1) as tax_status
, trim(nullif(substring(b.content, 82, 1), '0'))::varchar(1) as b_notice_reason_code
, trim(nullif(substring(b.content, 83, 20), '00000000000000000000'))::varchar(20) as first_b_notice_status
, try_to_date(nullif(substring(b.content, 103, 8), '00000000'), 'YYYYMMDD')::date as date_first_b_notice_status_issuedenforced
-- , trim(nullif(substring(b.content, 111, 8), '00000000'))::varchar(8) as not_used_4
, try_to_date(nullif(substring(b.content, 119, 8), '00000000'), 'YYYYMMDD')::date as date_first_b_notice_status_satisfied
, trim(nullif(substring(b.content, 127, 20), '00000000000000000000'))::varchar(20) as second_b_notice_status
, try_to_date(nullif(substring(b.content, 147, 8), '00000000'), 'YYYYMMDD')::date as date_second_b_notice_status_issuedenforced
-- , trim(nullif(substring(b.content, 155, 8), '00000000'))::varchar(8) as not_used_5
, try_to_date(nullif(substring(b.content, 163, 8), '00000000'), 'YYYYMMDD')::date as date_second_b_notice_status_satisfied
, trim(nullif(substring(b.content, 171, 20), '00000000000000000000'))::varchar(20) as c_notice_status
, try_to_date(nullif(substring(b.content, 191, 8), '00000000'), 'YYYYMMDD')::date as date_c_notice_status_issuedenforced
, try_to_date(nullif(substring(b.content, 199, 8), '00000000'), 'YYYYMMDD')::date as date_c_notice_status_satisfied
, trim(nullif(substring(b.content, 207, 20), '00000000000000000000'))::varchar(20) as old_account_number
, try_to_date(nullif(substring(b.content, 227, 8), '00000000'), 'YYYYMMDD')::date as original_account_open_date
, trim(nullif(substring(b.content, 235, 13), '0000000000000'))::varchar(13) as unidentified_large_trader_id
-- , trim(nullif(substring(b.content, 248, 2), '00'))::varchar(2) as not_used_6
, trim(nullif(substring(b.content, 250, 2), '00'))::varchar(2) as large_trader_type_code
, try_to_date(nullif(substring(b.content, 252, 8), '00000000'), 'YYYYMMDD')::date as large_trader_type_last_change_date
-- , trim(nullif(substring(b.content, 260, 13), '0000000000000'))::varchar(13) as not_used_7
, trim(nullif(substring(b.content, 273, 14), '00000000000000'))::varchar(14) as for_pershing_internal_use_only
, trim(nullif(substring(b.content, 287, 30), '000000000000000000000000000000'))::varchar(30) as initial_source_of_funds
, trim(nullif(substring(b.content, 317, 1), '0'))::varchar(1) as finance_away
, try_to_date(nullif(substring(b.content, 318, 8), '00000000'), 'YYYYMMDD')::date as account_funding_date
-- , trim(nullif(substring(b.content, 326, 7), '0000000'))::varchar(7) as not_used_8
, trim(nullif(substring(b.content, 333, 3), '000'))::varchar(3) as statement_currency_code
, trim(nullif(substring(b.content, 336, 3), '000'))::varchar(3) as future_statement_currency_code
, try_to_date(nullif(substring(b.content, 339, 8), '00000000'), 'YYYYMMDD')::date as future_statement_currency_code_date
, trim(nullif(substring(b.content, 347, 3), '000'))::varchar(3) as accountlevel_routing_code
, trim(nullif(substring(b.content, 350, 3), '000'))::varchar(3) as accountlevel_routing_code_2
, trim(nullif(substring(b.content, 353, 3), '000'))::varchar(3) as accountlevel_routing_code_3
, trim(nullif(substring(b.content, 356, 3), '000'))::varchar(3) as accountlevel_routing_code_4
, trim(nullif(substring(b.content, 359, 1), '0'))::varchar(1) as for_pershing_internal_use_only_2
, trim(nullif(substring(b.content, 360, 1), '0'))::varchar(1) as selfdirected_indicator
, trim(nullif(substring(b.content, 361, 1), '0'))::varchar(1) as digital_advice_indicator
, trim(nullif(substring(b.content, 362, 1), '0'))::varchar(1) as prohibited_transacton_exemption_pte_86128_account
-- , trim(nullif(substring(b.content, 363, 8), '00000000'))::varchar(8) as not_used_9
, coalesce(trim(nullif(substring(six.content, 41, 4), '0000')), trim(nullif(substring(b.content, 371, 3), '000')))::varchar(4) as first_investment_professional
, coalesce(trim(nullif(substring(six.content, 45, 4), '0000')), trim(nullif(substring(b.content, 374, 3), '000')))::varchar(4) as second_investment_professional
, coalesce(trim(nullif(substring(six.content, 49, 4), '0000')), trim(nullif(substring(b.content, 377, 3), '000')))::varchar(4) as third_investment_professional
, coalesce(trim(nullif(substring(six.content, 53, 4), '0000')), trim(nullif(substring(b.content, 380, 3), '000')))::varchar(4) as fourth_investment_professional
, coalesce(trim(nullif(substring(six.content, 57, 4), '0000')), trim(nullif(substring(b.content, 383, 3), '000')))::varchar(4) as fifth_investment_professional
, coalesce(trim(nullif(substring(six.content, 61, 4), '0000')), trim(nullif(substring(b.content, 386, 3), '000')))::varchar(4) as sixth_investment_professional
, coalesce(trim(nullif(substring(six.content, 65, 4), '0000')), trim(nullif(substring(b.content, 389, 3), '000')))::varchar(4) as seventh_investment_professional
, coalesce(trim(nullif(substring(six.content, 69, 4), '0000')), trim(nullif(substring(b.content, 392, 3), '000')))::varchar(4) as eighth_investment_professional
, coalesce(trim(nullif(substring(six.content, 73, 4), '0000')), trim(nullif(substring(b.content, 395, 3), '000')))::varchar(4) as ninth_investment_professional
, coalesce(trim(nullif(substring(six.content, 77, 4), '0000')), trim(nullif(substring(b.content, 398, 3), '000')))::varchar(4) as tenth_investment_professional
, trim(nullif(substring(b.content, 401, 8), '00000000'))::varchar(8) as alert_im_acronym
, trim(nullif(substring(b.content, 409, 16), '0000000000000000'))::varchar(16) as alert_im_access_code
, trim(nullif(substring(b.content, 425, 8), '00000000'))::varchar(8) as broker_acronym
, trim(nullif(substring(b.content, 433, 1), '0'))::varchar(1) as crossreferenced_indicator
, trim(nullif(substring(b.content, 434, 1), '0'))::varchar(1) as bny_trust_indicator
, trim(nullif(substring(b.content, 435, 2), '00'))::varchar(2) as source_of_assets_at_account_opening
, trim(nullif(substring(b.content, 437, 1), '0'))::varchar(1) as commission_discount_code
, trim(nullif(substring(b.content, 438, 20), '00000000000000000000'))::varchar(20) as external_account_number
, trim(nullif(substring(b.content, 458, 1), '0'))::varchar(1) as confirmation_suppression_indicator
, try_to_date(nullif(substring(b.content, 459, 6), '000000'), 'YYYYMM')::date as date_last_books_and_records_mailing_sent_to_customer
, try_to_date(nullif(substring(b.content, 465, 6), '000000'), 'YYYYMM')::date as date_last_books_and_records_mailing_sent_to_customer_ccyymm
-- , trim(nullif(substring(b.content, 471, 1), '0'))::varchar(1) as not_used_10
, trim(nullif(substring(b.content, 472, 1), '0'))::varchar(1) as fully_paid_lending_agreement_indicator
, try_to_date(nullif(substring(b.content, 473, 8), '00000000'), 'YYYYMMDD')::date as fully_paid_lending_agreement_date
, trim(nullif(substring(b.content, 481, 4), '0000'))::varchar(4) as custodian_account_type
, trim(nullif(substring(b.content, 485, 4), '0000'))::varchar(4) as markets_in_financial_instruments_directive_mifid
, trim(nullif(substring(b.content, 489, 1), '0'))::varchar(1) as cash_management_transaction_code
, trim(nullif(substring(b.content, 490, 4), '0000'))::varchar(4) as sweep_status_indicator
, try_to_date(nullif(substring(b.content, 494, 8), '00000000'), 'YYYYMMDD')::date as date_sweep_activated
, try_to_date(nullif(substring(b.content, 502, 8), '00000000'), 'YYYYMMDD')::date as date_sweep_details_changed
, trim(nullif(substring(b.content, 510, 1), '0'))::varchar(1) as cover_margin_debit_indicator
-- , trim(nullif(substring(b.content, 511, 1), '0'))::varchar(1) as not_used_11
, trim(nullif(substring(b.content, 512, 7), '0000000'))::varchar(7) as first_fund_sweep_account_id
, to_number(nullif(nullif(trim(substring(b.content, 519, 18)), '000000000000000000'), '')) / power(10, 09)::number as first_fund_sweep_account_percent
, trim(nullif(substring(b.content, 537, 1), '0'))::varchar(1) as first_fund_sweep_account_redemption_priority
, trim(nullif(substring(b.content, 538, 7), '0000000'))::varchar(7) as second_fund_sweep_account_id
, to_number(nullif(nullif(trim(substring(b.content, 545, 18)), '000000000000000000'), '')) / power(10, 09)::number as second_fund_sweep_account_percent
, trim(nullif(substring(b.content, 563, 1), '0'))::varchar(1) as second_fund_sweep_account_redemption_priority
, trim(nullif(substring(b.content, 564, 1), '0'))::varchar(1) as type_of_bank_account
, trim(nullif(substring(b.content, 565, 9), '000000000'))::varchar(9) as banklink_aba_number
, trim(nullif(substring(b.content, 574, 17), '00000000000000000'))::varchar(17) as banklink_dda_number
-- , trim(nullif(substring(b.content, 591, 3), '000'))::varchar(3) as not_used_12
, trim(nullif(substring(b.content, 594, 1), '0'))::varchar(1) as fund_bank_indicator
, trim(nullif(substring(b.content, 595, 36), '000000000000000000000000000000000000'))::varchar(36) as for_pershing_internal_use_only_3
, trim(nullif(substring(b.content, 631, 4), '0000'))::varchar(4) as w9_corporation_tax_classification_code
-- , trim(nullif(substring(b.content, 635, 1), '0'))::varchar(1) as not_used_13
, trim(nullif(substring(b.content, 636, 1), '0'))::varchar(1) as combined_margin_account_indicator
, trim(nullif(substring(b.content, 637, 1), '0'))::varchar(1) as pledge_collateral_account_indicator
, trim(nullif(substring(b.content, 638, 4), '0000'))::varchar(4) as finra_institutional_account_code
, trim(nullif(substring(b.content, 642, 6), '000000'))::varchar(6) as proposed_account_reference_id
, trim(nullif(substring(b.content, 648, 12), '000000000000'))::varchar(12) as advisor_model_id
, trim(nullif(substring(b.content, 660, 6), '000000'))::varchar(6) as firm_model_style_id
, trim(nullif(substring(b.content, 666, 20), '00000000000000000000'))::varchar(20) as for_pershing_internal_use_only_4
-- , trim(nullif(substring(b.content, 686, 13), '0000000000000'))::varchar(13) as not_used_14
, trim(nullif(substring(b.content, 699, 12), '000000000000'))::varchar(12) as for_pershing_internal_use_only_5
, trim(nullif(substring(b.content, 711, 1), '0'))::varchar(1) as dvp_restriction_code
, try_to_date(nullif(substring(b.content, 712, 8), '00000000'), 'YYYYMMDD')::date as dvp_restriction_expiration_date
, trim(nullif(substring(b.content, 720, 2), '00'))::varchar(2) as escheatment_withholding_indicator
-- , trim(nullif(substring(b.content, 722, 1), '0'))::varchar(1) as not_used_15
, trim(nullif(substring(b.content, 723, 4), '0000'))::varchar(4) as source_of_origination
, trim(nullif(substring(b.content, 727, 4), '0000'))::varchar(4) as source_of_persona
, trim(nullif(substring(b.content, 731, 4), '0000'))::varchar(4) as client_onboarding_method
, trim(nullif(substring(b.content, 735, 4), '0000'))::varchar(4) as tax_filing_code
-- , trim(nullif(substring(b.content, 739, 6), '000000'))::varchar(6) as not_used_16
, trim(nullif(substring(b.content, 745, 4), '0000'))::varchar(4) as for_pershing_internal_use_only_6
, trim(nullif(substring(b.content, 749, 1), '0'))::varchar(1) as nonpurpose_collateral_account_indicator
, trim(nullif(substring(b.content, 750, 1), '0'))::varchar(1) as literally_x
, {{ col_is_head(reference=src, source_date_col='b.effective_date') }}
, {{ col_is_current(date_col='b.effective_date') }}
, b.effective_date::date as effective_date
, b._source_file as _source_file
, b._created_at::timestamp as _source_loaded_at
from {{ src }} b
left join {{ src }} six
  on trim(nullif(substring(b.content, 12, 9), '000000000')) = trim(nullif(substring(six.content, 12, 9), '000000000'))
  and substring(six.content, 3, 1) = '6'
  and substring(six.content, 1, 3) not in ('EOF', 'BOF')
where true
and substring(b.content, 3, 1) = 'B'
and substring(b.content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
