
select 
     lower(custodianid)                         as custodian
    ,'mwa'                                      as firm_source
    ,null::text(200)                            as firm
    ,right(masteraccountnumber::varchar(25), 8) as master_account_number
    ,masteraccountname                          as master_account_name
    ,businessdate::date                         as business_date
    ,accountid                                  as account_number
    ,accounttitleline1                          as account_title_line_1
    ,accounttitleline2                          as account_title_line_2
    ,accounttitleline3                          as account_title_line_3
    ,accountstatus                              as account_status
    ,accountregistration                        as account_registration
    ,accounttype                                as account_type
    ,taxpayertitle                              as tax_payer_title
    ,taxpayerfirstname                          as tax_payer_first_name
    ,taxpayermiddlename                         as tax_payer_middle_name
    ,taxpayerlastname                           as tax_payer_last_name
    ,taxpayersuffix                             as tax_payer_suffix
    ,taxwithholdcode                            as tax_withhold_code
    ,primarycontact                             as primary_contact
    ,aliasname                                  as alias_name
    ,mailingaddressline1                        as mailing_address_line_1
    ,mailingaddressline2                        as mailing_address_line_2
    ,mailingaddressline3                        as mailing_address_line_3
    ,accountmailingcity                         as account_mailing_city
    ,accountmailingstate                        as account_mailing_state
    ,accountmailingzip                          as account_mailing_zip
    ,accountmailingcountrycode                  as account_mailing_country_code
    ,emailaddress                               as email_address
    ,phone                                      as phone
    ,businessphone                              as business_phone
    ,dateopened::date                           as date_opened
    ,schwabbranchcode                           as schwab_branch_code
    ,sweepstatuscode                            as sweep_status_code
    ,accountcashinstructionscash                as account_cash_instructions_cash
    ,accountcashinstructionsmargin              as account_cash_instructions_margin
    ,marginaccountindicator                     as margin_account_indicator
    ,accountrestrictions                        as account_restrictions
    ,additionalmailings                         as additional_mailing
    ,numberofadditionalmailings                 as number_of_additional_mailings
    ,approvedoptionlevel::int                   as approved_option_level
    ,beneficiaryonfile                          as beneficiary_on_file
    ,numberofbeneficiaries::int                 as number_of_beneficiaries
    ,paymentfeatureschecks                      as payment_features_checks
    ,paymentfeaturedebitcard                    as payment_feature_debit_card
    ,paymentfeaturesbillpay                     as payment_features_bill_pay
    ,undeliverablemailflag                      as undeliverable_mail_flag
    ,fafeestatus                                as fa_fee_status
    ,interestbearingfeaturecode                 as interest_bearing_feature_code
    ,interestbearingfeaturemoneymarketcode      as interest_Beraing_feature_money_market_code
    ,interestbearingfeaturetickersymbol         as interest_bearing_feature_ticker_symbol
    ,interestbearingfeatureitemissueid          as interest_bearing_feature_item_issue_id
    ,interestbearingfeaturerulesetsuffix        as interest_bearing_feature_rule_set_suffix
    ,proxyvotingauthority                       as proxy_voting_authority
    ,proxymailing                               as proxy_mailing
    ,statementpreferences                       as statement_preferences
    ,accounttaxableindicator                    as account_taxable_indicator
    ,defaultlotselectionmethod                  as default_lot_selection_method
    ,costmethod                                 as cost_method
    ,costbasismethodformutualfunds              as cost_basis_method_for_mutual_funds
    ,costbasismethodnonmutualfunds              as cost_basis_method_non_mutual_funds
    ,costbasismethoddate::date                  as cost_basis_method_date
    --,versionmarkernumber                        as version_marker_number
    ,customertype                               as customer_type
    ,organizationprimaryname                    as organization_primary_name
    ,restrictionreasoncode1                     as restriction_reason_code_1
    ,restrictionreasoncode2                     as restriction_reason_code_2
    ,restrictionreasoncode3                     as restriction_reason_code_3
    ,restrictionreasoncode4                     as restriction_reason_code_4
    ,restrictionreasoncode5                     as restriction_reason_code_5
    --,versionmarkernumber2                       as version_marker_number_2
    ,schwabbankinvestorcheckingaccountnumber    as schcwab_bank_investor_checking_account_number
    --,versionmarkernumber3                       as version_marker_number_3
    ,ssn_tin                                    as ssn_tin
    --,versionmarkernumber4                       as version_marker_number_4
    ,primebrokerenabledindicator                as prime_broker_enabled_indicator
    ,managedaccountplatformcode                 as managed_account_platform_code
    ,managedaccountmoneymanager                 as managed_account_money_manager
    ,managedaccountinvestmentstrategy           as managed_account_investment_strategy
    --,versionmarkernumber5                       as version_marker_number_5
    ,banksweepdisplayname                       as bank_sweep_display_name
    ,right(masteraccountnumber::varchar(25), 8) as master_number
    ,null::int                                  as is_deceased
    ,null::int                                  as is_from_tda_migration
    ,effective_date::date                       as effective_date
    ,{{ col_is_head(reference=source('schwab_mwa', 'accounts')) }}
    ,{{ col_is_current(date_col='effective_date') }}
    ,record_datetime::timestamp                 as _source_loaded_at
    ,null::text(200)                            as _source_file
from {{ source('schwab_mwa', 'accounts') }}
where 1=1
    and effective_date < (select min(effective_date) from {{ ref('schwab__base_accounts') }})

union all

select
      custodian
    , firm_source
    , firm
    , master_account_number
    , master_account_name
    , business_date
    , account_number
    , account_title_line_1
    , account_title_line_2
    , account_title_line_3
    , account_status
    , account_registration
    , account_type
    , taxpayer_title
    , taxpayer_first_name
    , taxpayer_middle_name
    , taxpayer_last_name
    , taxpayer_suffix
    , tax_withhold_code
    , primary_contact
    , alias_name
    , mailing_address_line_1
    , mailing_address_line_2
    , mailing_address_line_3
    , account_mailing_city
    , account_mailing_state
    , account_mailing_zip
    , account_mailing_country_code
    , email_address
    , phone
    , business_phone
    , date_opened_established
    , schwab_branch_code
    , sweep_status_code
    , account_cash_instructions_cash_account
    , account_cash_instructions_margin_account
    , margin_account_indicator
    , account_restrictions
    , additional_mailings
    , number_of_additional_mailings
    , approved_option_level
    , beneficiary_on_file_yn
    , number_of_beneficiaries
    , payment_features_checks
    , payment_features_debit_card
    , payment_features_bill_pay
    , undeliverable_mail_flag
    , fa_fee_status
    , interest_bearing_feature_code
    , interest_bearing_features_money_market_code
    , interest_bearing_features_ticker_symbol
    , interest_bearing_features_item_issue_id
    , interest_bearing_features_rule_set_suffix
    , proxy_voting_authority
    , proxy_mailing
    , statement_preferences
    , account_taxable_indicator
    , default_lot_selection_method
    , cost_method
    , cost_basis_method_for_mutual_funds
    , cost_basis_method_non_mutual_funds
    , cost_basis_method_date
    --, version_marker_number_1
    , customer_type
    , organization_primary_name
    --, version_marker_number_2
    , restriction_reason_code_1
    , restriction_reason_code_2
    , restriction_reason_code_3
    , restriction_reason_code_4
    , restriction_reason_code_5
    --, version_marker_number_3
    , schwab_bank_investor_checking_account_number
    --, version_marker_number_4
    , social_security_number_ssntax_id_number_tin
    --, version_marker_number_5
    , prime_broker_enabled_indicator
    , managed_account_platform_code
    , managed_account_money_manager
    , managed_account_investment_strategy
    --, version_marker_number_5
    , bank_sweep_display_name
    , master_number
    , is_deceased
    , is_from_tda_migration
    , effective_date
    , is_head
    , is_current
    , _source_loaded_at
    , _source_file
from {{ ref('schwab__base_accounts') }}
where 1=1
    and firm_source = 'mwa'
    and rn = 1
    and (
        (nvl(is_from_tda_migration,0) in (0,1) and effective_date >= '9/1/2023')
        or
        (nvl(is_from_tda_migration,0) = 0 and effective_date < '9/1/2023')
    )
