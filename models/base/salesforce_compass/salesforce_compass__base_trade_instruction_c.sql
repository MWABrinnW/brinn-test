select
    'salesforce'::text(200)                                    as system_name
  , 'compass'::text(200)                                       as system_instance
  , concat(system_name, '__', system_instance)::text(200)      as system_key
  , 'mwa'::text(200)                                           as firm_source
  , a.json:ID:: varchar(18)                                    as id
  , a.json:OWNER_ID:: varchar(18)                              as owner_id
  , a.json:IS_DELETED:: boolean                                as is_deleted
  , a.json:NAME:: varchar(240)                                 as name
  , a.json:CREATED_DATE:: timestamptz                          as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                         as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamptz                    as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                   as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamptz                       as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: date                           as last_activity_date
  , a.json:LAST_VIEWED_DATE:: timestamptz                      as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamptz                  as last_referenced_date
  , a.json:IMPORT_NAME_C:: varchar(90)                         as import_name_c
  , a.json:ACTION_C:: varchar(765)                             as action_c
  , a.json:ADJUSTMENT_TYPE_C:: varchar(75)                     as adjustment_type_c
  , a.json:ADVISOR_CONSENT_C:: boolean                         as advisor_consent_c
  , a.json:AMOUNT_C:: number(10, 2)                            as amount_c
  , a.json:APPROVED_ON_C:: timestamptz                         as approved_on_c
  , a.json:APPROVED_BY_IC_UNAPPROVED_PURCHASE_C:: boolean      as approved_by_ic_unapproved_purchase_c
  , a.json:APPROVER_C:: varchar(18)                            as approver_c
  , a.json:CALL_PUT_C:: varchar(765)                           as call_put_c
  , a.json:CASH_RAISED_FOLLOW_UP_C:: boolean                   as cash_raised_follow_up_c
  , a.json:CATEGORY_C:: varchar(765)                           as category_c
  , a.json:CLIENT_DIRECTED_ATTACHMENT_NOTES_C:: varchar(765)   as client_directed_attachment_notes_c
  , a.json:CLIENT_DIRECTED_TYPE_C:: varchar(765)               as client_directed_type_c
  , a.json:CLIENT_DIRECTED_C:: boolean                         as client_directed_c
  , a.json:CLIENT_C:: varchar(18)                              as client_c
  , a.json:COMMENTS_IC_C:: varchar(6000)                       as comments_ic_c
  , a.json:COMMENTS_C:: varchar(96000)                         as comments_c
  , a.json:COMPLETED_BY_C:: varchar(150)                       as completed_by_c
  , a.json:COVER_UNCOVER_C:: varchar(765)                      as cover_uncover_c
  , a.json:CREATED_BY_NAME_C:: varchar(300)                    as created_by_name_c
  , a.json:DATE_OF_CONTACT_C:: date                            as date_of_contact_c
  , a.json:DATE_OF_TRADE_C:: date                              as date_of_trade_c
  , a.json:EXPORTED_C:: boolean                                as exported_c
  , a.json:IMPORT_ID_C:: varchar(90)                           as import_id_c
  , a.json:JOURNAL_DATE_C:: date                               as journal_date_c
  , a.json:LAST_MODIFIED_BY_NAME_C:: varchar(300)              as last_modified_by_name_c
  , a.json:LIMIT_AMOUNT_C:: number(12, 2)                      as limit_amount_c
  , a.json:LIMIT_STOP_AMOUNT_C:: number(10, 2)                 as limit_stop_amount_c
  , a.json:MATURITY_DATE_BEGIN_C:: date                        as maturity_date_begin_c
  , a.json:MATURITY_DATE_END_C:: date                          as maturity_date_end_c
  , a.json:MAXIMUM_DOLLAR_PRICE_C:: varchar(765)               as maximum_dollar_price_c
  , a.json:MINIMUM_CREDIT_RATING_C:: varchar(765)              as minimum_credit_rating_c
  , a.json:MODEL_C:: varchar(18)                               as model_c
  , a.json:MONTH_C:: varchar(765)                              as month_c
  , a.json:MOXY_ORDER_ID_C:: varchar(36)                       as moxy_order_id_c
  , a.json:NON_DISCRETIONARY_ACCOUNT_AT_TRADE_TIME_C:: boolean as non_discretionary_account_at_trade_time_c
  , a.json:NOTES_FIXED_INCOME_TRADER_C:: varchar(765)          as notes_fixed_income_trader_c
  , a.json:ORDER_TYPE_C:: varchar(765)                         as order_type_c
  , a.json:OVERRIDE_TRADE_BLOCK_MODEL_C:: boolean              as override_trade_block_model_c
  , a.json:OWNER_NAME_C:: varchar(300)                         as owner_name_c
  , a.json:PRICE_C:: number(9, 2)                              as price_c
  , a.json:PRIORITY_LEVEL_C:: varchar(765)                     as priority_level_c
  , a.json:PRODUCT_STATUS_AS_OF_TRADE_C:: varchar(225)         as product_status_as_of_trade_c
  , a.json:QUANTITY_C:: double                                 as quantity_c
  , a.json:RECOMMENDER_NAME_C:: varchar(300)                   as recommender_name_c
  , a.json:RECOMMENDER_C:: varchar(18)                         as recommender_c
  , a.json:RECURRENCES_C:: double                              as recurrences_c
  , a.json:REMAINING_RECURRENCES_C:: double                    as remaining_recurrences_c
  , a.json:REQUESTOR_NAME_C:: varchar(300)                     as requestor_name_c
  , a.json:REQUESTOR_C:: varchar(18)                           as requestor_c
  , a.json:SECURITY_NAME_C:: varchar(300)                      as security_name_c
  , a.json:SECURITY_TYPE_C:: varchar(765)                      as security_type_c
  , a.json:SECURITY_C:: varchar(18)                            as security_c
  , a.json:SELL_ALL_C:: boolean                                as sell_all_c
  , a.json:SELL_ENTIRE_POSITION_C:: boolean                    as sell_entire_position_c
  , a.json:SEND_NOTIFICATION_TRANSACTION_COMPLETED_C:: boolean as send_notification_transaction_completed_c
  , a.json:SHARE_QUANTITY_C:: double                           as share_quantity_c
  , a.json:STATE_FLEXIBILITY_C:: varchar(765)                  as state_flexibility_c
  , a.json:STATE_C:: varchar(18)                               as state_c
  , a.json:STRIKE_C:: varchar(765)                             as strike_c
  , a.json:TICKER_SYMBOL_C:: varchar(75)                       as ticker_symbol_c
  , a.json:TRADE_FREQUENCY_C:: varchar(765)                    as trade_frequency_c
  , a.json:TRADE_STATUS_C:: varchar(765)                       as trade_status_c
  , a.json:TRADE_TYPE_C:: varchar(765)                         as trade_type_c
  , a.json:TRADING_NOTES_C:: varchar(24000)                    as trading_notes_c
  , a.json:TRANSACTION_BLOCK_C:: varchar(150)                  as transaction_block_c
  , a.json:WORKED_BY_C:: varchar(150)                          as worked_by_c
  , a.json:YEAR_C:: varchar(12)                                as year_c
  , a.json:ESTATE_ITEM_C:: varchar(18)                         as estate_item_c
  , a.json:PREVIOUSLY_APPROVED_BY_IC_C:: boolean               as previously_approved_by_ic_c
  , a.json:_FIVETRAN_SYNCED:: timestamptz                      as _fivetran_synced
  , a.json:ACCOUNT_NAME_C:: varchar(3900)                      as account_name_c
  , a.json:CUSTODIAL_FIRM_C:: varchar(3900)                    as custodial_firm_c
  , a.json:CLIENT_OWNER_C:: varchar(3900)                      as client_owner_c
  , a.json:ACCOUNT_CASH_BALANCE_C:: number(18, 2)              as account_cash_balance_c
  , a.json:ACCOUNT_C:: varchar(3900)                           as account_c
  , a.json:COURTESY_ACCOUNT_FORM_C:: boolean                   as courtesy_account_form_c
  , a.json:TRADING_SYSTEM_C:: varchar(3900)                    as trading_system_c
  , a.json:BOSTALE_DATE_C:: date                               as bostale_date_c
  , a.json:CURRENT_MODEL_ON_ACCOUNT_C:: varchar(3900)          as current_model_on_account_c
  , a.json:ACCOUNT_ID_C:: varchar(3900)                        as account_id_c
  , a.json:CURRENT_CASH_PERCENTAGE_C:: double                  as current_cash_percentage_c
  , a.json:PRIME_BROKER_ENABLED_C:: boolean                    as prime_broker_enabled_c
  , a.json:MARGIN_ON_ACCOUNT_C:: boolean                       as margin_on_account_c
  , a.json:RECOMMENDER_NAME_2_C:: varchar(3900)                as recommender_name_2_c
  , a.json:IMA_C:: boolean                                     as ima_c
  , a.json:RISK_OBJECTIVE_C:: boolean                          as risk_objective_c
  , a.json:REQUESTER_NAME_2_DEL_C:: varchar(3900)              as requester_name_2_del_c
  , a.json:NON_DISCRETIONARY_ACCOUNT_C:: boolean               as non_discretionary_account_c
  , a.json:ACCOUNT_CLOSED_DATE_C:: date                        as account_closed_date_c
  , a.json:CURRENT_ACCOUNT_VALUE_C:: number(18, 2)             as current_account_value_c
  , a.json:BLOCK_ON_ACCOUNT_C:: boolean                        as block_on_account_c
  , a.json:VALID_PAPERWORK_C:: boolean                         as valid_paperwork_c
  , a.json:BRANCH_C:: varchar(3900)                            as branch_c
  , a.json:CUSTODIAN_RESTRICTION_NOTES_C:: varchar(3900)       as custodian_restriction_notes_c
  , a.json:RISK_TOLERANCE_C:: boolean                          as risk_tolerance_c
  , a.json:LOCATION_C:: varchar(3900)                          as location_c
  , a.json:AS_OF_DATE_C:: date                                 as as_of_date_c
  , a.json:SYS_COMPLETE_NOTIFICATION_CC_C:: varchar(765)       as sys_complete_notification_cc_c
  , a.json:SYS_OPS_LAST_NOTIFIED_ATTN_REQ_C:: timestamptz      as sys_ops_last_notified_attn_req_c
  , a.json:REQUIRED_OPERATIONS_ATTENTION_C:: boolean           as required_operations_attention_c
  , a.json:CLIENT_AGREEMENT_VERSION_C:: varchar(3900)          as client_agreement_version_c
  , a.json:ACCOUNT_PAPERWORK_TYPE_ON_FILE_C_C:: varchar(3900)  as account_paperwork_type_on_file_c_c
  , a.json:_FIVETRAN_DELETED:: boolean                         as _fivetran_deleted

  , a.effective_at::timestamp                                  as effective_at
  , a._created_at::timestamp                                   as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'trade_instruction_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                       as is_latest
from {{ source('salesforce_compass', 'trade_instruction_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'trade_instruction_c') }}
    group by 1, 2
)                                                              b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
