select
    'schwab'                                                           as custodian
  , cl.firm_source                                                     as firm_source
  , cf.firm                                                            as firm
  , nullif(trim(substring(content, 1, 2)), '')::text(200)              as record_type
  , nullif(trim(substring(content, 4, 8)), '')                         as custodian_id
  , right(nullif(trim(substring(content, 13, 10)), ''), 8)             as master_account_number
  , nullif(trim(substring(content, 24, 30)), '')                       as master_account_name
  , to_date(nullif(trim(substring(content, 55, 8)), ''), 'YYYYMMDD')   as business_date
  , right(nullif(trim(substring(content, 64, 10)), ''), 8)             as account_number
  , nullif(trim(substring(content, 75, 45)), '')                       as account_title_line_1
  , nullif(trim(substring(content, 121, 45)), '')                      as account_title_line_2
  , nullif(trim(substring(content, 167, 45)), '')                      as account_title_line_3
  , nullif(trim(substring(content, 213, 8)), '')                       as account_status
  , nullif(trim(substring(content, 222, 5)), '')                       as account_registration
  , nullif(trim(substring(content, 228, 5)), '')                       as account_type
  , nullif(trim(substring(content, 234, 5)), '')                       as taxpayer_title
  , nullif(trim(substring(content, 240, 30)), '')                      as taxpayer_first_name
  , nullif(trim(substring(content, 271, 30)), '')                      as taxpayer_middle_name
  , nullif(trim(substring(content, 302, 30)), '')                      as taxpayer_last_name
  , nullif(trim(substring(content, 333, 5)), '')                       as taxpayer_suffix
  , nullif(trim(substring(content, 339, 2)), '')                       as tax_withhold_code
  , nullif(trim(substring(content, 342, 104)), '')                     as primary_contact
  , nullif(trim(substring(content, 447, 62)), '')                      as alias_name
  , nullif(trim(substring(content, 510, 45)), '')                      as mailing_address_line_1
  , nullif(trim(substring(content, 556, 45)), '')                      as mailing_address_line_2
  , nullif(trim(substring(content, 602, 45)), '')                      as mailing_address_line_3
  , nullif(trim(substring(content, 648, 30)), '')                      as account_mailing_city
  , nullif(trim(substring(content, 679, 2)), '')                       as account_mailing_state
  , nullif(trim(substring(content, 682, 10)), '')                      as account_mailing_zip
  , nullif(trim(substring(content, 693, 22)), '')                      as account_mailing_country_code
  , nullif(trim(substring(content, 716, 128)), '')                     as email_address
  , nullif(trim(substring(content, 845, 12)), '')                      as phone
  , nullif(trim(substring(content, 858, 12)), '')                      as business_phone
  , to_date(nullif(trim(substring(content, 871, 8)), ''), 'YYYYMMDD')  as date_opened_established
  , nullif(trim(substring(content, 880, 8)), '')                       as schwab_branch_code
  , nullif(trim(substring(content, 889, 1)), '')                       as sweep_status_code
  , nullif(trim(substring(content, 891, 2)), '')                       as account_cash_instructions_cash_account
  , nullif(trim(substring(content, 894, 2)), '')                       as account_cash_instructions_margin_account
  , nullif(trim(substring(content, 897, 1)), '')                       as margin_account_indicator
  , nullif(trim(substring(content, 899, 1)), '')                       as account_restrictions
  , nullif(trim(substring(content, 901, 1)), '')                       as additional_mailings
  , nullif(trim(substring(content, 903, 2)), '')::int                  as number_of_additional_mailings
  , nullif(trim(substring(content, 906, 1)), '')                       as approved_option_level
  , nullif(trim(substring(content, 908, 1)), '')                       as beneficiary_on_file_yn
  , nullif(trim(substring(content, 910, 2)), '')::int                  as number_of_beneficiaries
  , nullif(trim(substring(content, 913, 1)), '')                       as payment_features_checks
  , nullif(trim(substring(content, 915, 1)), '')                       as payment_features_debit_card
  , nullif(trim(substring(content, 917, 1)), '')                       as payment_features_bill_pay
  , nullif(trim(substring(content, 919, 1)), '')                       as undeliverable_mail_flag
  , nullif(trim(substring(content, 921, 1)), '')                       as fa_fee_status
  , nullif(trim(substring(content, 923, 5)), '')                       as interest_bearing_feature_code
  , nullif(trim(substring(content, 929, 5)), '')                       as interest_bearing_features_money_market_code
  , nullif(trim(substring(content, 935, 30)), '')                      as interest_bearing_features_ticker_symbol
  , nullif(trim(substring(content, 966, 10)), '')                      as interest_bearing_features_item_issue_id
  , nullif(trim(substring(content, 977, 5)), '')                       as interest_bearing_features_rule_set_suffix
  , nullif(trim(substring(content, 983, 1)), '')                       as proxy_voting_authority
  , nullif(trim(substring(content, 985, 1)), '')                       as proxy_mailing
  , nullif(trim(substring(content, 987, 8)), '')                       as statement_preferences
  , nullif(trim(substring(content, 996, 1)), '')                       as account_taxable_indicator
  , nullif(trim(substring(content, 998, 5)), '')                       as default_lot_selection_method
  , nullif(trim(substring(content, 1004, 1)), '')                      as cost_method
  , nullif(trim(substring(content, 1006, 5)), '')                      as cost_basis_method_for_mutual_funds
  , nullif(trim(substring(content, 1012, 5)), '')                      as cost_basis_method_non_mutual_funds
  , to_date(nullif(trim(substring(content, 1018, 8)), ''), 'YYYYMMDD') as cost_basis_method_date
  , nullif(trim(substring(content, 1027, 8)), '')                      as version_marker_number_1
  , nullif(trim(substring(content, 1036, 8)), '')                      as customer_type
  , nullif(trim(substring(content, 1045, 60)), '')                     as organization_primary_name
  , nullif(trim(substring(content, 1106, 8)), '')                      as version_marker_number_2
  , nullif(trim(substring(content, 1115, 4)), '')                      as restriction_reason_code_1
  , nullif(trim(substring(content, 1120, 4)), '')                      as restriction_reason_code_2
  , nullif(trim(substring(content, 1125, 4)), '')                      as restriction_reason_code_3
  , nullif(trim(substring(content, 1130, 4)), '')                      as restriction_reason_code_4
  , nullif(trim(substring(content, 1135, 4)), '')                      as restriction_reason_code_5
  , nullif(trim(substring(content, 1140, 8)), '')                      as version_marker_number_3
  , nullif(trim(substring(content, 1149, 12)), '')                     as schwab_bank_investor_checking_account_number
  , nullif(trim(substring(content, 1162, 8)), '')                      as version_marker_number_4
  , nullif(trim(substring(content, 1171, 11)), '')                     as social_security_number_ssntax_id_number_tin
  , nullif(trim(substring(content, 1183, 8)), '')                      as version_marker_number_5
  , nullif(trim(substring(content, 1192, 1)), '')                      as prime_broker_enabled_indicator
  , nullif(trim(substring(content, 1194, 8)), '')                      as managed_account_platform_code
  , nullif(trim(substring(content, 1203, 100)), '')                    as managed_account_money_manager
  , nullif(trim(substring(content, 1304, 50)), '')                     as managed_account_investment_strategy
  , nullif(trim(substring(content, 1355, 8)), '')                      as version_marker_number_5
  , nullif(trim(substring(content, 1364, 50)), '')                     as bank_sweep_display_name
  , master_number                                                      as master_number
  , cl.is_deceased                                                     as is_deceased
  , cl.is_from_tda_migration                                           as is_from_tda_migration
  , effective_date                                                     as effective_date
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
  , {{ col_is_head(reference=source('schwab', 'acc')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                        as _source_loaded_at
  , _source_file                                                       as _source_file
from {{ source('schwab', 'acc') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'D1'
