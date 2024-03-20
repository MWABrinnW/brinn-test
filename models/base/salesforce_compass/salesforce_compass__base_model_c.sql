select
    'salesforce'::text(200)                                       as system_name
  , 'compass'::text(200)                                          as system_instance
  , concat(system_name, '__', system_instance)::text(200)         as system_key
  , 'mwa'::text(200)                                              as firm_source
  , a.json:ID:: varchar(18)                                       as id
  , a.json:OWNER_ID:: varchar(18)                                 as owner_id
  , a.json:IS_DELETED:: boolean                                   as is_deleted
  , a.json:NAME:: varchar(240)                                    as name
  , a.json:RECORD_TYPE_ID:: varchar(18)                           as record_type_id
  , a.json:CREATED_DATE:: timestamptz                             as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                            as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamptz                       as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                      as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamptz                          as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: date                              as last_activity_date
  , a.json:LAST_VIEWED_DATE:: timestamptz                         as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamptz                     as last_referenced_date
  , a.json:ALLOCATIONS_C:: varchar(96000)                         as allocations_c
  , a.json:AS_OF_DATE_ESTIMATED_PERFORMANCE_C:: date              as as_of_date_estimated_performance_c
  , a.json:CASH_TOLERANCE_BAND_C:: double                         as cash_tolerance_band_c
  , a.json:COMPANY_C:: varchar(765)                               as company_c
  , a.json:CREATED_BY_NAME_C:: varchar(300)                       as created_by_name_c
  , a.json:DO_NOT_TRADE_MARINER_TRADING_C:: boolean               as do_not_trade_mariner_trading_c
  , a.json:HIGH_CASH_INVEST_FREQUENCY_C:: varchar(765)            as high_cash_invest_frequency_c
  , a.json:INITIAL_TRANSACTION_FEE_COST_FIDELITY_C:: number(7, 2) as initial_transaction_fee_cost_fidelity_c
  , a.json:INITIAL_TRANSACTION_FEE_COST_SCHWAB_C:: number(7, 2)   as initial_transaction_fee_cost_schwab_c
  , a.json:LAST_MODIFIED_BY_NAME_C:: varchar(300)                 as last_modified_by_name_c
  , a.json:LENGTH_OF_MATURITY_C:: double                          as length_of_maturity_c
  , a.json:LOCK_DOWN_FINAL_WARNING_C:: double                     as lock_down_final_warning_c
  , a.json:LOCK_DOWN_REMINDER_C:: double                          as lock_down_reminder_c
  , a.json:MH_TRADING_MODEL_NOTES_C:: varchar(765)                as mh_trading_model_notes_c
  , a.json:MTD_PERFORMANCE_ESTIMATED_C:: double                   as mtd_performance_estimated_c
  , a.json:MANAGEMENT_STYLE_C:: varchar(225)                      as management_style_c
  , a.json:MATURITY_DATE_C:: date                                 as maturity_date_c
  , a.json:MINIMUM_INVESTMENT_TYPE_C:: varchar(765)               as minimum_investment_type_c
  , a.json:MINIMUM_INVESTMENT_C:: number(18)                      as minimum_investment_c
  , a.json:MODEL_CASH_TARGET_C:: double                           as model_cash_target_c
  , a.json:MODEL_TYPE_C:: varchar(765)                            as model_type_c
  , a.json:ORION_MODEL_ID_C:: varchar(15)                         as orion_model_id_c
  , a.json:OWNER_NAME_C:: varchar(300)                            as owner_name_c
  , a.json:PREVIOUS_MODEL_NAME_C:: varchar(225)                   as previous_model_name_c
  , a.json:QTD_PERFORMANCE_ESTIMATED_C:: double                   as qtd_performance_estimated_c
  , a.json:REQUIRE_COMMITTED_AMOUNT_C:: boolean                   as require_committed_amount_c
  , a.json:SMA_ASSET_NAME_C:: varchar(300)                        as sma_asset_name_c
  , a.json:SERIES_C:: varchar(30)                                 as series_c
  , a.json:SUBADVISOR_2_RATE_C:: double                           as subadvisor_2_rate_c
  , a.json:SUBADVISOR_RATE_C:: double                             as subadvisor_rate_c
  , a.json:SUBADVISOR_WAS_FEE_C:: double                          as subadvisor_was_fee_c
  , a.json:TICKER_C:: varchar(75)                                 as ticker_c
  , a.json:TOTAL_VALUE_C:: double                                 as total_value_c
  , a.json:TOTAL_VALUE_OF_HOLDINGS_C:: double                     as total_value_of_holdings_c
  , a.json:VEHICLE_C:: varchar(765)                               as vehicle_c
  , a.json:WEIGHTED_MODEL_ID_C:: varchar(15)                      as weighted_model_id_c
  , a.json:YTD_PERFORMANCE_ESTIMATED_C:: double                   as ytd_performance_estimated_c
  , a.json:SMA_ASSET_CATEGORY_C:: varchar(765)                    as sma_asset_category_c
  , a.json:SMA_ASSET_CLASS_C:: varchar(765)                       as sma_asset_class_c
  , a.json:SMA_APPROVAL_STATUS_C:: varchar(765)                   as sma_approval_status_c
  , a.json:SYS_ADDENDUM_KEY_C:: varchar(765)                      as sys_addendum_key_c
  , a.json:_FIVETRAN_SYNCED:: timestamptz                         as _fivetran_synced
  , a.json:SEND_REMINDER_C:: boolean                              as send_reminder_c
  , a.json:REMINDER_DATE_C:: date                                 as reminder_date_c
  , a.json:FINAL_WARNING_DATE_C:: date                            as final_warning_date_c

  , a.effective_at::timestamp                                     as effective_at
  , a._created_at::timestamp                                      as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'model_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                          as is_latest
from {{ source('salesforce_compass', 'model_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'model_c') }}
    group by 1, 2
)                                                  b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at