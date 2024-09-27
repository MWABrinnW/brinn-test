{{ config(
  grants = {'+select': ['ops_mwa']}
) }}

select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::varchar(240)                                 as name
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                           as last_activity_date
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:IMPORT_NAME_C::varchar(90)                         as import_name_c
    , json:ACTION_C::varchar(765)                             as action_c
    , json:ADJUSTMENT_TYPE_C::varchar(75)                     as adjustment_type_c
    , json:ADVISOR_CONSENT_C::boolean                         as advisor_consent_c
    , json:AMOUNT_C::number(10 , 2)                           as amount_c
    , json:APPROVED_ON_C::timestamptz                         as approved_on_c
    , json:APPROVED_BY_IC_UNAPPROVED_PURCHASE_C::boolean      as approved_by_ic_unapproved_purchase_c
    , json:APPROVER_C::varchar(18)                            as approver_c
    , json:CALL_PUT_C::varchar(765)                           as call_put_c
    , json:CASH_RAISED_FOLLOW_UP_C::boolean                   as cash_raised_follow_up_c
    , json:CATEGORY_C::varchar(765)                           as category_c
    , json:CLIENT_DIRECTED_ATTACHMENT_NOTES_C::varchar(765)   as client_directed_attachment_notes_c
    , json:CLIENT_DIRECTED_TYPE_C::varchar(765)               as client_directed_type_c
    , json:CLIENT_DIRECTED_C::boolean                         as client_directed_c
    , json:CLIENT_C::varchar(18)                              as client_c
    , json:COMMENTS_IC_C::varchar(6000)                       as comments_ic_c
    , json:COMMENTS_C::varchar(96000)                         as comments_c
    , json:COMPLETED_BY_C::varchar(150)                       as completed_by_c
    , json:COVER_UNCOVER_C::varchar(765)                      as cover_uncover_c
    , json:CREATED_BY_NAME_C::varchar(300)                    as created_by_name_c
    , json:DATE_OF_CONTACT_C::date                            as date_of_contact_c
    , json:DATE_OF_TRADE_C::date                              as date_of_trade_c
    , json:EXPORTED_C::boolean                                as exported_c
    , json:IMPORT_ID_C::varchar(90)                           as import_id_c
    , json:JOURNAL_DATE_C::date                               as journal_date_c
    , json:LAST_MODIFIED_BY_NAME_C::varchar(300)              as last_modified_by_name_c
    , json:LIMIT_AMOUNT_C::number(12 , 2)                     as limit_amount_c
    , json:LIMIT_STOP_AMOUNT_C::number(10 , 2)                as limit_stop_amount_c
    , json:MATURITY_DATE_BEGIN_C::date                        as maturity_date_begin_c
    , json:MATURITY_DATE_END_C::date                          as maturity_date_end_c
    , json:MAXIMUM_DOLLAR_PRICE_C::varchar(765)               as maximum_dollar_price_c
    , json:MINIMUM_CREDIT_RATING_C::varchar(765)              as minimum_credit_rating_c
    , json:MODEL_C::varchar(18)                               as model_c
    , json:MONTH_C::varchar(765)                              as month_c
    , json:MOXY_ORDER_ID_C::varchar(36)                       as moxy_order_id_c
    , json:NON_DISCRETIONARY_ACCOUNT_AT_TRADE_TIME_C::boolean as non_discretionary_account_at_trade_time_c
    , json:NOTES_FIXED_INCOME_TRADER_C::varchar(765)          as notes_fixed_income_trader_c
    , json:ORDER_TYPE_C::varchar(765)                         as order_type_c
    , json:OVERRIDE_TRADE_BLOCK_MODEL_C::boolean              as override_trade_block_model_c
    , json:OWNER_NAME_C::varchar(300)                         as owner_name_c
    , json:PRICE_C::number(9 , 2)                             as price_c
    , json:PRIORITY_LEVEL_C::varchar(765)                     as priority_level_c
    , json:PRODUCT_STATUS_AS_OF_TRADE_C::varchar(225)         as product_status_as_of_trade_c
    , json:QUANTITY_C::double                                 as quantity_c
    , json:RECOMMENDER_NAME_C::varchar(300)                   as recommender_name_c
    , json:RECOMMENDER_C::varchar(18)                         as recommender_c
    , json:RECURRENCES_C::double                              as recurrences_c
    , json:REMAINING_RECURRENCES_C::double                    as remaining_recurrences_c
    , json:REQUESTOR_NAME_C::varchar(300)                     as requestor_name_c
    , json:REQUESTOR_C::varchar(18)                           as requestor_c
    , json:SECURITY_NAME_C::varchar(300)                      as security_name_c
    , json:SECURITY_TYPE_C::varchar(765)                      as security_type_c
    , json:SECURITY_C::varchar(18)                            as security_c
    , json:SELL_ALL_C::boolean                                as sell_all_c
    , json:SELL_ENTIRE_POSITION_C::boolean                    as sell_entire_position_c
    , json:SEND_NOTIFICATION_TRANSACTION_COMPLETED_C::boolean as send_notification_transaction_completed_c
    , json:SHARE_QUANTITY_C::double                           as share_quantity_c
    , json:STATE_FLEXIBILITY_C::varchar(765)                  as state_flexibility_c
    , json:STATE_C::varchar(18)                               as state_c
    , json:STRIKE_C::varchar(765)                             as strike_c
    , json:TICKER_SYMBOL_C::varchar(75)                       as ticker_symbol_c
    , json:TRADE_FREQUENCY_C::varchar(765)                    as trade_frequency_c
    , json:TRADE_STATUS_C::varchar(765)                       as trade_status_c
    , json:TRADE_TYPE_C::varchar(765)                         as trade_type_c
    , json:TRADING_NOTES_C::varchar(24000)                    as trading_notes_c
    , json:TRANSACTION_BLOCK_C::varchar(150)                  as transaction_block_c
    , json:WORKED_BY_C::varchar(150)                          as worked_by_c
    , json:YEAR_C::varchar(12)                                as year_c
    , json:ESTATE_ITEM_C::varchar(18)                         as estate_item_c
    , json:PREVIOUSLY_APPROVED_BY_IC_C::boolean               as previously_approved_by_ic_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:ACCOUNT_NAME_C::varchar(3900)                      as account_name_c
    , json:CUSTODIAL_FIRM_C::varchar(3900)                    as custodial_firm_c
    , json:CLIENT_OWNER_C::varchar(3900)                      as client_owner_c
    , json:ACCOUNT_CASH_BALANCE_C::number(18 , 2)             as account_cash_balance_c
    , json:ACCOUNT_C::varchar(3900)                           as account_c
    , json:COURTESY_ACCOUNT_FORM_C::boolean                   as courtesy_account_form_c
    , json:TRADING_SYSTEM_C::varchar(3900)                    as trading_system_c
    , json:BOSTALE_DATE_C::date                               as bostale_date_c
    , json:CURRENT_MODEL_ON_ACCOUNT_C::varchar(3900)          as current_model_on_account_c
    , json:ACCOUNT_ID_C::varchar(3900)                        as account_id_c
    , json:CURRENT_CASH_PERCENTAGE_C::double                  as current_cash_percentage_c
    , json:PRIME_BROKER_ENABLED_C::boolean                    as prime_broker_enabled_c
    , json:MARGIN_ON_ACCOUNT_C::boolean                       as margin_on_account_c
    , json:RECOMMENDER_NAME_2_C::varchar(3900)                as recommender_name_2_c
    , json:IMA_C::boolean                                     as ima_c
    , json:RISK_OBJECTIVE_C::boolean                          as risk_objective_c
    , json:REQUESTER_NAME_2_DEL_C::varchar(3900)              as requester_name_2_del_c
    , json:NON_DISCRETIONARY_ACCOUNT_C::boolean               as non_discretionary_account_c
    , json:ACCOUNT_CLOSED_DATE_C::date                        as account_closed_date_c
    , json:CURRENT_ACCOUNT_VALUE_C::number(18 , 2)            as current_account_value_c
    , json:BLOCK_ON_ACCOUNT_C::boolean                        as block_on_account_c
    , json:VALID_PAPERWORK_C::boolean                         as valid_paperwork_c
    , json:BRANCH_C::varchar(3900)                            as branch_c
    , json:CUSTODIAN_RESTRICTION_NOTES_C::varchar(3900)       as custodian_restriction_notes_c
    , json:RISK_TOLERANCE_C::boolean                          as risk_tolerance_c
    , json:LOCATION_C::varchar(3900)                          as location_c
    , json:AS_OF_DATE_C::date                                 as as_of_date_c
    , json:SYS_COMPLETE_NOTIFICATION_CC_C::varchar(765)       as sys_complete_notification_cc_c
    , json:SYS_OPS_LAST_NOTIFIED_ATTN_REQ_C::timestamptz      as sys_ops_last_notified_attn_req_c
    , json:REQUIRED_OPERATIONS_ATTENTION_C::boolean           as required_operations_attention_c
    , json:CLIENT_AGREEMENT_VERSION_C::varchar(3900)          as client_agreement_version_c
    , json:ACCOUNT_PAPERWORK_TYPE_ON_FILE_C_C::varchar(3900)  as account_paperwork_type_on_file_c_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'trade_instruction_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'trade_instruction_c') }}
