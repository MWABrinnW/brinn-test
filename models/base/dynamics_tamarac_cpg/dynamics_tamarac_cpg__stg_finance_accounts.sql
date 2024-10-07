select
    json:CREATEDON::timestamp_ntz                                as created_at
    , effective_at::timestamp_ntz                                as effective_at
    , json:EXCHANGERATE::decimal(20 , 2)                         as exchange_rate
    , json:MODIFIEDON::timestamp_ntz                             as modified_at
    , json:TAM_ADDITIONALHOUSEHOLDSACCOUNTS::varchar(200)        as tam_additional_households_accounts
    , json:TAM_ADVISORVIEWCOLUMN::varchar(200)                   as tam_advisor_view_column
    , json:TAM_BYPASSPLUGIN::boolean                             as tam_bypass_plugin
    , json:TAM_CONTRIBUTIONRATEPREVIOUSYEAR::decimal(20 , 2)     as tam_contribution_rate_previous_year
    , json:TAM_CONTRIBUTIONSPREVIOUSYEAR::decimal(20 , 2)        as tam_contributions_previous_year
    , json:TAM_CONTRIBUTIONSPREVIOUSYEAR_BASE::decimal(20 , 2)   as tam_contributions_previous_year_base
    , json:TAM_CUSTODIAN::varchar(200)                           as tam_custodian
    , json:TAM_CUSTODIANACCTVALUE::decimal(20 , 2)               as tam_custodian_acct_value
    , json:TAM_CUSTODIANACCTVALUE_BASE::decimal(20 , 2)          as tam_custodian_acct_value_base
    , json:TAM_CUSTVALASOF_1231_PREVYEAR::decimal(20 , 2)        as tam_cust_val_as_of_1231_prev_year
    , json:TAM_CUSTVALASOF_1231_PREVYEAR_BASE::decimal(20 , 2)   as tam_cust_val_as_of_1231_prev_year_base
    , json:TAM_DEFINEDCONTRIPLAN::boolean                        as tam_defined_contrib_plan
    , json:TAM_DISCRETIONARYACCOUNT::boolean                     as tam_discretionary_account
    , json:TAM_ENABLEDFORREBALANCING::boolean                    as tam_enabled_for_rebalancing
    , json:TAM_FINANCEACCOUNTID::varchar(200)                    as tam_finance_account_id
    , json:TAM_FINANCIALACCOUNTID::varchar(200)                  as tam_financial_account_id
    , json:TAM_FINANCIALACCOUNTVALUE::decimal(20 , 2)            as tam_financial_account_value
    , json:TAM_FINANCIALACCOUNTVALUE_BASE::decimal(20 , 2)       as tam_financial_account_value_base
    , json:TAM_FINANCIALACCOUNT_TRUNC_ID::varchar(200)           as tam_financial_account_trunc_id
    , json:TAM_FINANCIALACCTTYPE::varchar(200)                   as tam_financial_acct_type
    , json:TAM_HASBENEFICIARIES::boolean                         as tam_has_beneficiaries
    , json:TAM_LASTAVUPDATE::date                                as tam_last_av_update
    , json:TAM_LASTORDERDATE::date                               as tam_last_order_date
    , json:TAM_LASTTRADEDATE::date                               as tam_last_trade_date
    , json:TAM_LASTTRADEMODIFIEDDATE::date                       as tam_last_trade_modified_date
    , json:TAM_MASTERACCOUNTID::varchar(200)                     as tam_master_account_id
    , json:TAM_MODEL::varchar(200)                               as tam_model
    , json:TAM_NAME::varchar(200)                                as tam_name
    , json:TAM_NETCONTRIBUTIONPREVIOUSYEAR::decimal(20 , 2)      as tam_net_contribution_previous_year
    , json:TAM_NETCONTRIBUTIONPREVIOUSYEAR_BASE::decimal(20 , 2) as tam_net_contribution_previous_year_base
    , json:TAM_OVERRIDERMDELIGIBILITY::boolean                   as tam_override_rmd_eligibility
    , json:TAM_REPORTINGGROUP::varchar(200)                      as tam_reporting_group
    , json:TAM_REQUIRESBENEFICIARY::boolean                      as tam_requires_beneficiary
    , json:TAM_RETURNPERIOD_1_LABEL::varchar(200)                as tam_return_period_1_label
    , json:TAM_RETURNPERIOD_1_VALUE::decimal(20 , 2)             as tam_return_period_1_value
    , json:TAM_REVENUEPREVIOUSYEAR::decimal(20 , 2)              as tam_revenue_previous_year
    , json:TAM_REVENUEPREVIOUSYEAR_BASE::decimal(20 , 2)         as tam_revenue_previous_year_base
    , json:TAM_RMDELIGIBLE::boolean                              as tam_rmd_eligible
    , json:TAM_RMDROTHIRA::boolean                               as tam_rmd_roth_ira
    , json:TAM_RMDSATISFIED::boolean                             as tam_rmd_satisfied
    , json:TAM_ROTHIRA::boolean                                  as tam_roth_ira
    , json:TAM_TAXDEFERREDEXEMPT::boolean                        as tam_tax_deferred_exempt
    , json:TAM_TAXWITHHOLDINGELECTED::boolean                    as tam_tax_withholding_elected
    , json:TAM_TAXWITHHOLDINGFEDERALOPTEDOUT::boolean            as tam_tax_withholding_federal_opted_out
    , json:TAM_TAXWITHHOLDINGSTATEOPTEDOUT::boolean              as tam_tax_withholding_state_opted_out
    , json:TAM_TERMINATIONDATE::date                             as tam_termination_date
    , json:TAM_TERMINATIONVALUE::decimal(20 , 2)                 as tam_termination_value
    , json:TAM_TERMINATIONVALUE_BASE::decimal(20 , 2)            as tam_termination_value_base
    , json:TAM_TOTALCASH::decimal(20 , 2)                        as tam_total_cash
    , json:TAM_TOTALCASHRESERVES::decimal(20 , 2)                as tam_total_cash_reserves
    , json:TAM_TOTALCASHRESERVES_BASE::decimal(20 , 2)           as tam_total_cash_reserves_base
    , json:TAM_TOTALCASH_BASE::decimal(20 , 2)                   as tam_total_cash_base
    , json:TAM_TOTALVALUE::decimal(20 , 2)                       as tam_total_value
    , json:TAM_TOTALVALUE_BASE::decimal(20 , 2)                  as tam_total_value_base
    , json:TAM_UNMANAGEDAUM::decimal(20 , 2)                     as tam_unmanaged_aum
    , json:TAM_UNMANAGEDAUM_BASE::decimal(20 , 2)                as tam_unmanaged_aum_base
    , json:TAM_UPLOADID::varchar(200)                            as tam_upload_id
    , json:TAM_WITHDRAWALSPREVIOUSYEAR::decimal(20 , 2)          as tam_withdrawals_previous_year
    , json:TAM_WITHDRAWALSPREVIOUSYEAR_BASE::decimal(20 , 2)     as tam_withdrawals_previous_year_base
    , json:TAM_WITHDRAWALSYTD::decimal(20 , 2)                   as tam_withdrawals_ytd
    , json:TAM_WITHDRAWALSYTD_BASE::decimal(20 , 2)              as tam_withdrawals_ytd_base
    , json:STATUSCODE::integer                                   as status_code
    , json:STATECODE::integer                                    as state_code
    , json:TIMEZONERULEVERSIONNUMBER::integer                    as timezone_rule_version_number
    , json:VERSIONNUMBER::integer                                as version_number
    , json:_ACCOUNTID_VALUE::varchar(200)                        as _account_id_value
    , json:_CREATEDBY_VALUE::varchar(200)                        as _created_by_value
    , json:_FIVETRAN_DELETED::integer                            as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz                       as _fivetran_synced
    , json:_MODIFIEDBY_VALUE::varchar(200)                       as _modified_by_value
    , json:_MODIFIEDONBEHALFBY_VALUE::varchar(200)               as _modified_on_behalf_by_value
    , json:_OWNERID_VALUE::varchar(200)                          as _owner_id_value
    , json:_OWNINGBUSINESSUNIT_VALUE::varchar(200)               as _owning_business_unit_value
    , json:_OWNINGUSER_VALUE::varchar(200)                       as _owning_user_value
    , json:_PRIMARYCONTACTID_VALUE::varchar(200)                 as _primary_contact_id_value
    , json:_SECONDARYCONTACTID_VALUE::varchar(200)               as _secondary_contact_id_value
    , _created_at::timestamp_ntz                                 as _created_at
    , json:_TRUSTID_VALUE::varchar(200)                          as _trust_id_value
    , json:_TRANSACTIONCURRENCYID_VALUE::varchar(200)            as _transaction_currency_id_value
    , {{ col_is_head(reference = source('dynamics_tamarac_cpg', 'tam_financeaccount'), 
            reference_date_col = 'effective_at::date', 
            source_date_col = 'effective_at::date') }}
    , case when
            dense_rank() over (partition by effective_at::date order by date_trunc('second' , _created_at) desc) = 1
            then 1
        else 0
    end::int                                                     as is_head_for_day
from {{ source('dynamics_tamarac_cpg', 'tam_financeaccount') }}
