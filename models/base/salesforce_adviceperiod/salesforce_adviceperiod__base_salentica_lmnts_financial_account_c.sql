select
    'salesforce'::text(200)                                               as system_name
  , 'adviceperiod'::text(200)                                             as system_instance
  , concat(system_name, '__', system_instance)::text(200)                 as system_key
  , 'mps'::text(200)                                                      as firm_source
  , a.json:ID:: varchar(18)                                               as id
  , a.json:IS_DELETED:: boolean                                           as is_deleted
  , a.json:NAME:: varchar(240)                                            as name
  , a.json:CREATED_DATE:: timestamp_tz(9)                                 as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                                    as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamp_tz(9)                           as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                              as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamp_tz(9)                              as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: date                                      as last_activity_date
  , a.json:LAST_VIEWED_DATE:: timestamp_tz(9)                             as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamp_tz(9)                         as last_referenced_date
  , a.json:SALENTICA_LMNTS_RELATIONSHIP_C:: varchar(18)                   as salentica_lmnts_relationship_c
  , a.json:SALENTICA_LMNTS_ACCOUNT_NOTES_C:: varchar(15000)               as salentica_lmnts_account_notes_c
  , a.json:SALENTICA_LMNTS_ACTIVE_C:: boolean                             as salentica_lmnts_active_c
  , a.json:SALENTICA_LMNTS_ALTERNATIVES_ACTUAL_MARKET_VALUE_C:: number    as salentica_lmnts_alternatives_actual_market_value_c
  , a.json:SALENTICA_LMNTS_ALTERNATIVES_ACTUAL_WEIGHT_C:: float           as salentica_lmnts_alternatives_actual_weight_c
  , a.json:SALENTICA_LMNTS_CASH_ACTUAL_MARKET_VALUE_C:: number            as salentica_lmnts_cash_actual_market_value_c
  , a.json:SALENTICA_LMNTS_CASH_ACTUAL_WEIGHT_C:: float                   as salentica_lmnts_cash_actual_weight_c
  , a.json:SALENTICA_LMNTS_CUSTODIAN_ACCOUNT_NUMBER_C:: varchar(150)      as salentica_lmnts_custodian_account_number_c
  , a.json:SALENTICA_LMNTS_CUSTODIAN_C:: varchar(18)                      as salentica_lmnts_custodian_c
  , a.json:SALENTICA_LMNTS_DATE_CLOSED_C:: date                           as salentica_lmnts_date_closed_c
  , a.json:SALENTICA_LMNTS_DATE_OPENED_C:: date                           as salentica_lmnts_date_opened_c
  , a.json:SALENTICA_LMNTS_DO_NOT_TRADE_NOTES_C:: varchar(765)            as salentica_lmnts_do_not_trade_notes_c
  , a.json:SALENTICA_LMNTS_EQUITY_ACTUAL_MARKET_VALUE_C:: number          as salentica_lmnts_equity_actual_market_value_c
  , a.json:SALENTICA_LMNTS_EQUITY_ACTUAL_WEIGHT_C:: float                 as salentica_lmnts_equity_actual_weight_c
  , a.json:SALENTICA_LMNTS_FIDELITY_ACCOUNT_SOURCE_C:: varchar(765)       as salentica_lmnts_fidelity_account_source_c
  , a.json:SALENTICA_LMNTS_FIXED_INCOME_ACTUAL_MARKET_VALUE_C:: number    as salentica_lmnts_fixed_income_actual_market_value_c
  , a.json:SALENTICA_LMNTS_FIXED_INCOME_ACTUAL_WEIGHT_C:: float           as salentica_lmnts_fixed_income_actual_weight_c
  , a.json:SALENTICA_LMNTS_FORMS_APPROVED_C:: boolean                     as salentica_lmnts_forms_approved_c
  , a.json:SALENTICA_LMNTS_FORMS_COMPLETE_C:: boolean                     as salentica_lmnts_forms_complete_c
  , a.json:SALENTICA_LMNTS_FUNDING_APPROVED_C:: boolean                   as salentica_lmnts_funding_approved_c
  , a.json:SALENTICA_LMNTS_FUNDING_METHOD_C:: varchar(765)                as salentica_lmnts_funding_method_c
  , a.json:SALENTICA_LMNTS_IS_PRIMARY_ACCOUNT_IN_RELATIONSHIP_C:: boolean as salentica_lmnts_is_primary_account_in_relationship_c
  , a.json:SALENTICA_LMNTS_OTHER_ACTUAL_MARKET_VALUE_C:: number           as salentica_lmnts_other_actual_market_value_c
  , a.json:SALENTICA_LMNTS_OTHER_ACTUAL_WEIGHT_C:: float                  as salentica_lmnts_other_actual_weight_c
  , a.json:SALENTICA_LMNTS_PMS_ACCOUNT_NUMBER_C:: varchar(150)            as salentica_lmnts_pms_account_number_c
  , a.json:SALENTICA_LMNTS_PRIMARY_ACCOUNT_OWNER_C:: varchar(18)          as salentica_lmnts_primary_account_owner_c
  , a.json:SALENTICA_LMNTS_REGISTRATION_TYPE_C:: varchar(765)             as salentica_lmnts_registration_type_c
  , a.json:SALENTICA_LMNTS_SALENTICA_DATA_BROKER_ID_C:: varchar(300)      as salentica_lmnts_salentica_data_broker_id_c
  , a.json:SALENTICA_LMNTS_SECONDARY_ACCOUNT_OWNER_C:: varchar(18)        as salentica_lmnts_secondary_account_owner_c
  , a.json:SALENTICA_LMNTS_TAX_ID_C:: varchar(60)                         as salentica_lmnts_tax_id_c
  , a.json:SALENTICA_LMNTS_TOTAL_MARKET_VALUE_C:: number                  as salentica_lmnts_total_market_value_c
  , a.json:SALENTICA_LMNTS_TOTAL_SUPERVISED_C:: number                    as salentica_lmnts_total_supervised_c
  , a.json:SALENTICA_LMNTS_TOTAL_UNSUPERVISED_C:: number                  as salentica_lmnts_total_unsupervised_c
  , a.json:SALENTICA_LMNTS_TRADING_STATUS_C:: varchar(765)                as salentica_lmnts_trading_status_c
  , a.json:SALENTICA_LMNTS_VALUATION_DATE_C:: date                        as salentica_lmnts_valuation_date_c
  , a.json:VALUATION_FREQUENCY_C:: varchar(765)                           as valuation_frequency_c
  , a.json:VALUATION_REDEMPTION_DATE_C:: date                             as valuation_redemption_date_c
  , a.json:NEXT_ALT_VALUATION_DATE_C:: date                               as next_alt_valuation_date_c
  , a.json:STATEMENT_AVAILABILITY_DAYS_C:: float                          as statement_availability_days_c
  , a.json:STATEMENT_AVAILABILITY_DATE_C:: date                           as statement_availability_date_c
  , a.json:DAYS_UNTIL_STATEMENT_AVAILABLE_C:: float                       as days_until_statement_available_c
  , a.json:DAYS_SINCE_ACCOUNT_OPEN_C:: float                              as days_since_account_open_c
  , a.json:CASH_ACTUAL_MARKET_WEIGHT_T_1_C:: number                       as cash_actual_market_weight_t_1_c
  , a.json:CASH_ACTUAL_MARKET_VALUE_DAY_CHANGE_C:: number                 as cash_actual_market_value_day_change_c
  , a.json:AP_MANAGED_C:: boolean                                         as ap_managed_c
  , a.json:IPS_ACCOUNT_C:: boolean                                        as ips_account_c
  , a.json:CASH_BUFFER_VALUE_C:: number                                   as cash_buffer_value_c
  , a.json:CASH_BUFFER_PCT_VALUE_C:: float                                as cash_buffer_pct_value_c
  , a.json:TOO_MUCH_CASH_C:: varchar(3900)                                as too_much_cash_c
  , a.json:CASH_TO_INVEST_C:: number                                      as cash_to_invest_c
  , a.json:PCT_CASH_MGMT_C:: varchar(3900)                                as pct_cash_mgmt_c
  , a.json:DOLLAR_CASH_MGMT_C:: varchar(3900)                             as dollar_cash_mgmt_c
  , a.json:VALUE_OF_CASH_ALTERNATIVES_C:: number                          as value_of_cash_alternatives_c
  , a.json:ACTUAL_CASH_PCT_C:: float                                      as actual_cash_pct_c
  , a.json:APPROVED_SMA_C:: boolean                                       as approved_sma_c
  , a.json:APPROVED_MARKET_VALUE_C:: number                               as approved_market_value_c
  , a.json:AUM_C:: number                                                 as aum_c
  , a.json:APPROVED_SMA_2_C:: boolean                                     as approved_sma_2_c
  , a.json:NOTES_C:: varchar(98304)                                       as notes_c
  , a.json:FINANCIAL_ACCOUNT_TEAM_C:: varchar(3900)                       as financial_account_team_c
  , a.json:LAST_MASS_UPDATE_C:: date                                      as last_mass_update_c
  , a.json:LASTE_STATEMENT_DATE_C:: date                                  as laste_statement_date_c
  , a.json:DATA_SOURCE_C:: varchar(765)                                   as data_source_c
  , a.json:WEBSITE_C:: varchar(765)                                       as website_c
  , a.json:USERNAME_C:: varchar(765)                                      as username_c
  , a.json:PASSWORD_C:: varchar(765)                                      as password_c
  , a.json:WEBSITE_NOTES_C:: varchar(98304)                               as website_notes_c
  , a.json:STATEMENT_CONTACT_C:: varchar(765)                             as statement_contact_c
  , a.json:STATEMENT_CONTACT_EMAIL_C:: varchar(765)                       as statement_contact_email_c
  , a.json:STATEMENT_CONTACT_PHONE_C:: varchar(120)                       as statement_contact_phone_c
  , a.json:NEXT_VALUATION_DATE_C:: date                                   as next_valuation_date_c
  , a.json:LAST_VALUATION_DATE_C:: date                                   as last_valuation_date_c
  , a.json:NEXT_STATEMENT_DATE_C:: date                                   as next_statement_date_c
  , a.json:DAYS_UNTIL_NEXT_STATEMENT_DATE_C:: float                       as days_until_next_statement_date_c
  , a.json:ACCOUNT_NOTES_C:: varchar(98304)                               as account_notes_c
  , a.json:ACCOUNT_CHOICE_SET_C:: varchar(3900)                           as account_choice_set_c
  , a.json:RELATIONSHIP_TEAM_C:: varchar(3900)                            as relationship_team_c
  , a.json:FIN_ACCOUNT_NOTES_C:: varchar(765)                             as fin_account_notes_c
  , a.json:SENIOR_ANALYST_C:: varchar(3900)                               as senior_analyst_c
  , a.json:ANALYST_C:: varchar(3900)                                      as analyst_c
  , a.json:DATE_REVIEWED_C:: date                                         as date_reviewed_c
  , a.json:ACTION_NEEDED_C:: varchar(765)                                 as action_needed_c
  , a.json:LINKED_RELATIONSHIP_NAME_C:: varchar(3900)                     as linked_relationship_name_c
  , a.json:PORTFOLIO_MANAGEMENT_GROUP_C:: varchar(3900)                   as portfolio_management_group_c
  , a.json:TEMPORARY_EXCLUDE_C:: boolean                                  as temporary_exclude_c
  , a.json:CASH_T_C:: float                                               as cash_t_c
  , a.json:ADDITIONAL_BUFFER_C:: number                                   as additional_buffer_c
  , a.json:BILLING_STATUS_C:: varchar(765)                                as billing_status_c
  , a.json:_FIVETRAN_SYNCED:: timestamp_tz(9)                             as _fivetran_synced
  , a.json:_FIVETRAN_DELETED:: boolean                                    as _fivetran_deleted

  , a.effective_at::timestamp                                             as effective_at
  , a._created_at::timestamp                                              as _created_at
  , {{ col_is_head(reference=source('salesforce_adviceperiod', 'salentica_lmnts_financial_account_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                                  as is_latest
from {{ source('salesforce_adviceperiod', 'salentica_lmnts_financial_account_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_adviceperiod', 'salentica_lmnts_financial_account_c') }}
    group by 1, 2
)                                                                                   b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at