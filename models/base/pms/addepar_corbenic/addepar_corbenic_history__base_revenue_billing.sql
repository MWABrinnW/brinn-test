SELECT 
       entity_id::varchar(100)                                                     as entity_id
     , name::varchar(100)                                                          as name
     , grouping::varchar(100)                                                      as grouping
     , effective_date::date                                                        as effective_date
     , children::varchar(10000)                                                    as children
     , replace(COLUMNS:_custom_cwm_strategy_264181, '"', '')::varchar(100)         as _custom_cwm_strategy_264181
     , replace(COLUMNS:billing_fee_exclusion, '"', '')::boolean                    as billing_fee_exclusion
     , replace(COLUMNS:top_level_owner_id, '"', '')::varchar(100)                  as top_level_owner_id
     , replace(COLUMNS:billing_bill_to_account_number, '"', '')::varchar(100)      as billing_bill_to_account_number
     , replace(COLUMNS:billing_schedule_v2, '"', '')::varchar(100)                 as billing_schedule_v2
     , replace(COLUMNS:uncounted_exempt_asset, '"', '')::varchar(100)              as uncounted_exempt_asset
     , replace(COLUMNS:_custom_cwm_closed_date_796810, '"', '')::date              as _custom_cwm_closed_date_796810
     , replace(COLUMNS:billing_effective_rate, '"', '')::decimal(15, 13)           as billing_effective_rate
     , replace(COLUMNS:_custom_cwm_mcd_owner_136712, '"', '')::boolean             as _custom_cwm_mcd_owner_136712
     , replace(COLUMNS:_custom_cwm_lead_advisor_136710, '"', '')::varchar(100)     as _custom_cwm_lead_advisor_136710
     , replace(COLUMNS:value, '"', '')::decimal(20, 5)                             as value
     , replace(COLUMNS:addebill_exempt_asset_reason, '"', '')::varchar(100)        as addebill_exempt_asset_reason
     , replace(COLUMNS:_custom_cwm_closed_account_166737, '"', '')::boolean        as _custom_cwm_closed_account_166737
     , replace(COLUMNS:direct_owner, '"', '')::varchar(1000)                       as direct_owner
     , replace(COLUMNS:billing_fee_type_v2, '"', '')::varchar(100)                 as billing_fee_type_v2
     , replace(COLUMNS:direct_owner_id, '"', '')::varchar(100)                     as direct_owner_id
     , replace(COLUMNS:addebill_exempt_asset, '"', '')::varchar(100)               as addebill_exempt_asset
     , replace(COLUMNS:source_unique_node_id_namespace_id, '"', '')::varchar(100)  as source_unique_node_id_namespace_id
     , replace(COLUMNS:top_level_holding_account, '"', '')::varchar(100)           as top_level_holding_account
     , replace(COLUMNS:_custom_cwm_custodian_126441, '"', '')::varchar(100)        as _custom_cwm_custodian_126441
     , replace(COLUMNS:billing_date, '"', '')::date                                as billing_date
     , replace(COLUMNS:top_level_account_number, '"', '')::varchar(100)            as top_level_account_number
     , replace(COLUMNS:billing_assets_billed_on_v2, '"', '')::number               as billing_assets_billed_on_v2
     , replace(COLUMNS:_custom_cwm_service_advisor_136711, '"', '')::varchar(100)  as _custom_cwm_service_advisor_136711
     , replace(COLUMNS:top_level_owner, '"', '')::varchar(1000)                    as top_level_owner
     , replace(COLUMNS:billing_aum, '"', '')::decimal(20, 5)                       as billing_aum
     , replace(COLUMNS:billing_fee_value_v2, '"', '')::number                      as billing_fee_value_v2
     , replace(COLUMNS:bottom_level_holding_account_number, '"', '')::varchar(100) as bottom_level_holding_account_number
     , replace(COLUMNS:billing_fees_v2, '"', '')::varchar(100)                     as billing_fees_v2
     , replace(COLUMNS:billing_gross_fee_v2, '"', '')::number                      as billing_gross_fee_v2
     , replace(COLUMNS:position, '"', '')::varchar(100)                            as position
     , replace(COLUMNS:billing_schedule, '"', '')::varchar(100)                    as billing_schedule
    , {{ col_is_head(reference=source('addepar_corbenic', 'revenue_billing')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _source_file as _source_file
    , _created_at as _source_loaded_at
FROM {{ source('addepar_corbenic', 'revenue_billing') }}
