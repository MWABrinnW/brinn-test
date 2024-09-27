select
    'salesforce'::text(200)                                       as system_name
    , 'compass'::text(200)                                        as system_instance
    , concat(system_name , '__' , system_instance)::text(200)     as system_key
    , 'mwa'::text(200)                                            as firm_source
    , json:ID::varchar(18)                                        as id
    , json:OWNER_ID::varchar(18)                                  as owner_id
    , json:IS_DELETED::boolean                                    as is_deleted
    , json:NAME::varchar(240)                                     as name
    , json:RECORD_TYPE_ID::varchar(18)                            as record_type_id
    , json:CREATED_DATE::timestamptz                              as created_date
    , json:CREATED_BY_ID::varchar(18)                             as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                        as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                       as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                           as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                               as last_activity_date
    , json:LAST_VIEWED_DATE::timestamptz                          as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                      as last_referenced_date
    , json:ALLOCATIONS_C::varchar(96000)                          as allocations_c
    , json:AS_OF_DATE_ESTIMATED_PERFORMANCE_C::date               as as_of_date_estimated_performance_c
    , json:CASH_TOLERANCE_BAND_C::double                          as cash_tolerance_band_c
    , json:COMPANY_C::varchar(765)                                as company_c
    , json:CREATED_BY_NAME_C::varchar(300)                        as created_by_name_c
    , json:DO_NOT_TRADE_MARINER_TRADING_C::boolean                as do_not_trade_mariner_trading_c
    , json:HIGH_CASH_INVEST_FREQUENCY_C::varchar(765)             as high_cash_invest_frequency_c
    , json:INITIAL_TRANSACTION_FEE_COST_FIDELITY_C::number(7 , 2) as initial_transaction_fee_cost_fidelity_c
    , json:INITIAL_TRANSACTION_FEE_COST_SCHWAB_C::number(7 , 2)   as initial_transaction_fee_cost_schwab_c
    , json:LAST_MODIFIED_BY_NAME_C::varchar(300)                  as last_modified_by_name_c
    , json:LENGTH_OF_MATURITY_C::double                           as length_of_maturity_c
    , json:LOCK_DOWN_FINAL_WARNING_C::double                      as lock_down_final_warning_c
    , json:LOCK_DOWN_REMINDER_C::double                           as lock_down_reminder_c
    , json:MH_TRADING_MODEL_NOTES_C::varchar(765)                 as mh_trading_model_notes_c
    , json:MTD_PERFORMANCE_ESTIMATED_C::double                    as mtd_performance_estimated_c
    , json:MANAGEMENT_STYLE_C::varchar(225)                       as management_style_c
    , json:MATURITY_DATE_C::date                                  as maturity_date_c
    , json:MINIMUM_INVESTMENT_TYPE_C::varchar(765)                as minimum_investment_type_c
    , json:MINIMUM_INVESTMENT_C::number(18)                       as minimum_investment_c
    , json:MODEL_CASH_TARGET_C::double                            as model_cash_target_c
    , json:MODEL_TYPE_C::varchar(765)                             as model_type_c
    , json:ORION_MODEL_ID_C::varchar(15)                          as orion_model_id_c
    , json:OWNER_NAME_C::varchar(300)                             as owner_name_c
    , json:PREVIOUS_MODEL_NAME_C::varchar(225)                    as previous_model_name_c
    , json:QTD_PERFORMANCE_ESTIMATED_C::double                    as qtd_performance_estimated_c
    , json:REQUIRE_COMMITTED_AMOUNT_C::boolean                    as require_committed_amount_c
    , json:SMA_ASSET_NAME_C::varchar(300)                         as sma_asset_name_c
    , json:SERIES_C::varchar(30)                                  as series_c
    , json:SUBADVISOR_2_RATE_C::double                            as subadvisor_2_rate_c
    , json:SUBADVISOR_RATE_C::double                              as subadvisor_rate_c
    , json:SUBADVISOR_WAS_FEE_C::double                           as subadvisor_was_fee_c
    , json:TICKER_C::varchar(75)                                  as ticker_c
    , json:TOTAL_VALUE_C::double                                  as total_value_c
    , json:TOTAL_VALUE_OF_HOLDINGS_C::double                      as total_value_of_holdings_c
    , json:VEHICLE_C::varchar(765)                                as vehicle_c
    , json:WEIGHTED_MODEL_ID_C::varchar(15)                       as weighted_model_id_c
    , json:YTD_PERFORMANCE_ESTIMATED_C::double                    as ytd_performance_estimated_c
    , json:SMA_ASSET_CATEGORY_C::varchar(765)                     as sma_asset_category_c
    , json:SMA_ASSET_CLASS_C::varchar(765)                        as sma_asset_class_c
    , json:SMA_APPROVAL_STATUS_C::varchar(765)                    as sma_approval_status_c
    , json:SYS_ADDENDUM_KEY_C::varchar(765)                       as sys_addendum_key_c
    , json:_FIVETRAN_SYNCED::timestamptz                          as _fivetran_synced
    , json:SEND_REMINDER_C::boolean                               as send_reminder_c
    , json:REMINDER_DATE_C::date                                  as reminder_date_c
    , json:FINAL_WARNING_DATE_C::date                             as final_warning_date_c

    , {{ col_is_head(
    reference=source('salesforce_compass', 'model_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                           as is_latest
from {{ source('salesforce_compass', 'model_c') }}
