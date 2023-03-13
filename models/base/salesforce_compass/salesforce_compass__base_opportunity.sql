select
    a.json:ID:: VARCHAR(18)                                 as id
  , a.json:IS_DELETED:: BOOLEAN                             as is_deleted
  , a.json:ACCOUNT_ID:: VARCHAR(18)                         as account_id
  , a.json:RECORD_TYPE_ID:: VARCHAR(18)                     as record_type_id
  , a.json:IS_PRIVATE:: BOOLEAN                             as is_private
  , a.json:NAME:: VARCHAR(360)                              as name
  , a.json:DESCRIPTION:: VARCHAR(96000)                     as description
  , a.json:STAGE_NAME:: VARCHAR(765)                        as stage_name
  , a.json:AMOUNT:: NUMBER(18, 2)                           as amount
  , a.json:PROBABILITY:: DOUBLE                             as probability
  , a.json:EXPECTED_REVENUE:: NUMBER(18, 2)                 as expected_revenue
  , a.json:TOTAL_OPPORTUNITY_QUANTITY:: DOUBLE              as total_opportunity_quantity
  , a.json:CLOSE_DATE:: DATE                                as close_date
  , a.json:TYPE:: VARCHAR(765)                              as type
  , a.json:NEXT_STEP:: VARCHAR(765)                         as next_step
  , a.json:LEAD_SOURCE:: VARCHAR(765)                       as lead_source
  , a.json:IS_CLOSED:: BOOLEAN                              as is_closed
  , a.json:IS_WON:: BOOLEAN                                 as is_won
  , a.json:FORECAST_CATEGORY:: VARCHAR(120)                 as forecast_category
  , a.json:FORECAST_CATEGORY_NAME:: VARCHAR(765)            as forecast_category_name
  , a.json:CAMPAIGN_ID:: VARCHAR(18)                        as campaign_id
  , a.json:HAS_OPPORTUNITY_LINE_ITEM:: BOOLEAN              as has_opportunity_line_item
  , a.json:IS_SPLIT:: BOOLEAN                               as is_split
  , a.json:PRICEBOOK_2_ID:: VARCHAR(18)                     as pricebook_2_id
  , a.json:OWNER_ID:: VARCHAR(18)                           as owner_id
  , a.json:CREATED_DATE:: TIMESTAMPTZ                       as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)                      as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ                 as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)                as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ                    as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: DATE                        as last_activity_date
  , a.json:FISCAL_QUARTER:: NUMBER                          as fiscal_quarter
  , a.json:FISCAL_YEAR:: NUMBER                             as fiscal_year
  , a.json:FISCAL:: VARCHAR(6)                              as fiscal
  , a.json:CONTACT_ID:: VARCHAR(18)                         as contact_id
  , a.json:LAST_VIEWED_DATE:: TIMESTAMPTZ                   as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMPTZ               as last_referenced_date
  , a.json:SYNCED_QUOTE_ID:: VARCHAR(18)                    as synced_quote_id
  , a.json:CONTRACT_ID:: VARCHAR(18)                        as contract_id
  , a.json:HAS_OPEN_ACTIVITY:: BOOLEAN                      as has_open_activity
  , a.json:HAS_OVERDUE_TASK:: BOOLEAN                       as has_overdue_task
  , a.json:LAST_AMOUNT_CHANGED_HISTORY_ID:: VARCHAR(18)     as last_amount_changed_history_id
  , a.json:LAST_CLOSE_DATE_CHANGED_HISTORY_ID:: VARCHAR(18) as last_close_date_changed_history_id
  , a.json:ACTUAL_CLOSE_DATE_C:: DATE                       as actual_close_date_c
  , a.json:ACTUAL_AUM_C:: NUMBER(18, 2)                     as actual_aum_c
  , a.json:REFERRAL_SOURCE_C:: VARCHAR(18)                  as referral_source_c
  , a.json:EXPECTED_MWA_REVENUE_C:: NUMBER(12, 2)           as expected_mwa_revenue_c
  , a.json:EXPECTED_MONTAGE_REVENUE_C:: NUMBER(12, 2)       as expected_montage_revenue_c
  , a.json:PRODUCT_LINE_C:: VARCHAR(765)                    as product_line_c
  , a.json:SHORT_NOTE_C:: VARCHAR(765)                      as short_note_c
  , a.json:CLOSED_LOST_REASON_C:: VARCHAR(765)              as closed_lost_reason_c
  , a.json:CLOSED_DATE_STAMP_C:: DATE                       as closed_date_stamp_c
  , a.json:PRIMARY_CONTACT_C:: VARCHAR(18)                  as primary_contact_c
  , a.json:EXPECTED_REVENUE_C:: NUMBER(18, 2)               as expected_revenue_c
  , a.json:SYS_MIGRATION_SOURCE_C:: VARCHAR(4099)           as sys_migration_source_c
  , a.json:SYS_MIGRATION_ID_C:: VARCHAR(765)                as sys_migration_id_c
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ                   as _fivetran_synced
  , a.json:REFERRAL_FIRM_C:: VARCHAR(600)                   as referral_firm_c
  , a.json:PUSH_COUNT:: NUMBER                              as push_count
  , a.json:LAST_STAGE_CHANGE_DATE:: TIMESTAMPTZ             as last_stage_change_date
  , a.json:TOTAL_EXPECTED_REVENUE_C:: NUMBER(18, 2)         as total_expected_revenue_c
  , a.json:OPPORTUNITY_AGE_C:: DOUBLE                       as opportunity_age_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN                      as _fivetran_deleted

  , a.effective_at::timestamp                               as effective_at
  , a._created_at::timestamp                                as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'opportunity'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                    as is_latest
from {{ source('salesforce_compass', 'opportunity') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'opportunity') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
