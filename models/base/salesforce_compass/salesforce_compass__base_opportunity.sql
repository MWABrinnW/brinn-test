select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:ACCOUNT_ID::varchar(18)                            as account_id
    , json:RECORD_TYPE_ID::varchar(18)                        as record_type_id
    , json:IS_PRIVATE::boolean                                as is_private
    , json:NAME::varchar(360)                                 as name
    , json:DESCRIPTION::varchar(96000)                        as description
    , json:STAGE_NAME::varchar(765)                           as stage_name
    , json:AMOUNT::number(18 , 2)                             as amount
    , json:PROBABILITY::double                                as probability
    , json:EXPECTED_REVENUE::number(18 , 2)                   as expected_revenue
    , json:TOTAL_OPPORTUNITY_QUANTITY::double                 as total_opportunity_quantity
    , json:CLOSE_DATE::date                                   as close_date
    , json:TYPE::varchar(765)                                 as type
    , json:NEXT_STEP::varchar(765)                            as next_step
    , json:LEAD_SOURCE::varchar(765)                          as lead_source
    , json:IS_CLOSED::boolean                                 as is_closed
    , json:IS_WON::boolean                                    as is_won
    , json:FORECAST_CATEGORY::varchar(120)                    as forecast_category
    , json:FORECAST_CATEGORY_NAME::varchar(765)               as forecast_category_name
    , json:CAMPAIGN_ID::varchar(18)                           as campaign_id
    , json:HAS_OPPORTUNITY_LINE_ITEM::boolean                 as has_opportunity_line_item
    , json:IS_SPLIT::boolean                                  as is_split
    , json:PRICEBOOK_2_ID::varchar(18)                        as pricebook_2_id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_ACTIVITY_DATE::date                           as last_activity_date
    , json:FISCAL_QUARTER::number                             as fiscal_quarter
    , json:FISCAL_YEAR::number                                as fiscal_year
    , json:FISCAL::varchar(6)                                 as fiscal
    , json:CONTACT_ID::varchar(18)                            as contact_id
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:SYNCED_QUOTE_ID::varchar(18)                       as synced_quote_id
    , json:CONTRACT_ID::varchar(18)                           as contract_id
    , json:HAS_OPEN_ACTIVITY::boolean                         as has_open_activity
    , json:HAS_OVERDUE_TASK::boolean                          as has_overdue_task
    , json:LAST_AMOUNT_CHANGED_HISTORY_ID::varchar(18)        as last_amount_changed_history_id
    , json:LAST_CLOSE_DATE_CHANGED_HISTORY_ID::varchar(18)    as last_close_date_changed_history_id
    , json:ACTUAL_CLOSE_DATE_C::date                          as actual_close_date_c
    , json:ACTUAL_AUM_C::number(18 , 2)                       as actual_aum_c
    , json:REFERRAL_SOURCE_C::varchar(18)                     as referral_source_c
    , json:EXPECTED_MWA_REVENUE_C::number(12 , 2)             as expected_mwa_revenue_c
    , json:EXPECTED_MONTAGE_REVENUE_C::number(12 , 2)         as expected_montage_revenue_c
    , json:PRODUCT_LINE_C::varchar(765)                       as product_line_c
    , json:SHORT_NOTE_C::varchar(765)                         as short_note_c
    , json:CLOSED_LOST_REASON_C::varchar(765)                 as closed_lost_reason_c
    , json:CLOSED_DATE_STAMP_C::date                          as closed_date_stamp_c
    , json:PRIMARY_CONTACT_C::varchar(18)                     as primary_contact_c
    , json:EXPECTED_REVENUE_C::number(18 , 2)                 as expected_revenue_c
    , json:SYS_MIGRATION_SOURCE_C::varchar(4099)              as sys_migration_source_c
    , json:SYS_MIGRATION_ID_C::varchar(765)                   as sys_migration_id_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:REFERRAL_FIRM_C::varchar(600)                      as referral_firm_c
    , json:PUSH_COUNT::number                                 as push_count
    , json:LAST_STAGE_CHANGE_DATE::timestamptz                as last_stage_change_date
    , json:TOTAL_EXPECTED_REVENUE_C::number(18 , 2)           as total_expected_revenue_c
    , json:OPPORTUNITY_AGE_C::double                          as opportunity_age_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'opportunity')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'opportunity') }}
