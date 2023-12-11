-- depends_on: {{ ref('schwab__stg_accounts') }}

select
    a.custodian
  , cl.firm_source
  , cf.firm
  , a.record_type
  , a.custodian_id
  , a.master_account_number
  , a.master_account_name
  , a.business_date
  , a.account_number
  , a.account_title_line_1
  , a.account_title_line_2
  , a.account_title_line_3
  , a.account_status
  , a.account_registration
  , a.account_type
  , a.taxpayer_title
  , a.taxpayer_first_name
  , a.taxpayer_middle_name
  , a.taxpayer_last_name
  , a.taxpayer_suffix
  , a.tax_withhold_code
  , a.primary_contact
  , a.alias_name
  , a.mailing_address_line_1
  , a.mailing_address_line_2
  , a.mailing_address_line_3
  , a.account_mailing_city
  , a.account_mailing_state
  , a.account_mailing_zip
  , a.account_mailing_country_code
  , a.email_address
  , a.phone
  , a.business_phone
  , a.date_opened_established
  , a.schwab_branch_code
  , a.sweep_status_code
  , a.account_cash_instructions_cash_account
  , a.account_cash_instructions_margin_account
  , a.margin_account_indicator
  , a.account_restrictions
  , a.additional_mailings
  , a.number_of_additional_mailings
  , a.approved_option_level
  , a.beneficiary_on_file_yn
  , a.number_of_beneficiaries
  , a.payment_features_checks
  , a.payment_features_debit_card
  , a.payment_features_bill_pay
  , a.undeliverable_mail_flag
  , a.fa_fee_status
  , a.interest_bearing_feature_code
  , a.interest_bearing_features_money_market_code
  , a.interest_bearing_features_ticker_symbol
  , a.interest_bearing_features_item_issue_id
  , a.interest_bearing_features_rule_set_suffix
  , a.proxy_voting_authority
  , a.proxy_mailing
  , a.statement_preferences
  , a.account_taxable_indicator
  , a.default_lot_selection_method
  , a.cost_method
  , a.cost_basis_method_for_mutual_funds
  , a.cost_basis_method_non_mutual_funds
  , a.cost_basis_method_date
  , a.version_marker_number_1
  , a.customer_type
  , a.organization_primary_name
  , a.version_marker_number_2
  , a.restriction_reason_code_1
  , a.restriction_reason_code_2
  , a.restriction_reason_code_3
  , a.restriction_reason_code_4
  , a.restriction_reason_code_5
  , a.version_marker_number_3
  , a.schwab_bank_investor_checking_account_number
  , a.version_marker_number_4
  , a.social_security_number_ssntax_id_number_tin
  , a.version_marker_number_5
  , a.prime_broker_enabled_indicator
  , a.managed_account_platform_code
  , a.managed_account_money_manager
  , a.managed_account_investment_strategy
  , a.version_marker_number_5
  , a.bank_sweep_display_name
  , a.master_number
  , a.is_deceased
  , a.is_from_tda_migration
  , a.effective_date
  , row_number() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn
  , row_number() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn_firm_source
  , row_number() over(partition by a.effective_date, account_number
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc
                    )                                                  as rn_global
  , {{ col_is_head(reference=source('schwab', 'acc_accounts')) }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at
  , a._source_file
from {{ source('schwab', 'acc_accounts') }}     a
left join {{ ref('aux__stg_custodian_links') }} cl
          on a.master_number = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}          cf
          on cl.firm_source = cf.firm_source
