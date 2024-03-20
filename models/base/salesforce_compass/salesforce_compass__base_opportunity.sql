select
    'salesforce'::text(200)                                 as system_name
  , 'compass'::text(200)                                    as system_instance
  , concat(system_name, '__', system_instance)::text(200)   as system_key
  , 'mwa'::text(200)                                        as firm_source
  , a.json:ID:: varchar(18)                                 as id
  , a.json:IS_DELETED:: boolean                             as is_deleted
  , a.json:ACCOUNT_ID:: varchar(18)                         as account_id
  , a.json:RECORD_TYPE_ID:: varchar(18)                     as record_type_id
  , a.json:IS_PRIVATE:: boolean                             as is_private
  , a.json:NAME:: varchar(360)                              as name
  , a.json:DESCRIPTION:: varchar(96000)                     as description
  , a.json:STAGE_NAME:: varchar(765)                        as stage_name
  , a.json:AMOUNT:: number(18, 2)                           as amount
  , a.json:PROBABILITY:: double                             as probability
  , a.json:EXPECTED_REVENUE:: number(18, 2)                 as expected_revenue
  , a.json:TOTAL_OPPORTUNITY_QUANTITY:: double              as total_opportunity_quantity
  , a.json:CLOSE_DATE:: date                                as close_date
  , a.json:TYPE:: varchar(765)                              as type
  , a.json:NEXT_STEP:: varchar(765)                         as next_step
  , a.json:LEAD_SOURCE:: varchar(765)                       as lead_source
  , a.json:IS_CLOSED:: boolean                              as is_closed
  , a.json:IS_WON:: boolean                                 as is_won
  , a.json:FORECAST_CATEGORY:: varchar(120)                 as forecast_category
  , a.json:FORECAST_CATEGORY_NAME:: varchar(765)            as forecast_category_name
  , a.json:CAMPAIGN_ID:: varchar(18)                        as campaign_id
  , a.json:HAS_OPPORTUNITY_LINE_ITEM:: boolean              as has_opportunity_line_item
  , a.json:IS_SPLIT:: boolean                               as is_split
  , a.json:PRICEBOOK_2_ID:: varchar(18)                     as pricebook_2_id
  , a.json:OWNER_ID:: varchar(18)                           as owner_id
  , a.json:CREATED_DATE:: timestamptz                       as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                      as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamptz                 as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)                as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamptz                    as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: date                        as last_activity_date
  , a.json:FISCAL_QUARTER:: number                          as fiscal_quarter
  , a.json:FISCAL_YEAR:: number                             as fiscal_year
  , a.json:FISCAL:: varchar(6)                              as fiscal
  , a.json:CONTACT_ID:: varchar(18)                         as contact_id
  , a.json:LAST_VIEWED_DATE:: timestamptz                   as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: timestamptz               as last_referenced_date
  , a.json:SYNCED_QUOTE_ID:: varchar(18)                    as synced_quote_id
  , a.json:CONTRACT_ID:: varchar(18)                        as contract_id
  , a.json:HAS_OPEN_ACTIVITY:: boolean                      as has_open_activity
  , a.json:HAS_OVERDUE_TASK:: boolean                       as has_overdue_task
  , a.json:LAST_AMOUNT_CHANGED_HISTORY_ID:: varchar(18)     as last_amount_changed_history_id
  , a.json:LAST_CLOSE_DATE_CHANGED_HISTORY_ID:: varchar(18) as last_close_date_changed_history_id
  , a.json:ACTUAL_CLOSE_DATE_C:: date                       as actual_close_date_c
  , a.json:ACTUAL_AUM_C:: number(18, 2)                     as actual_aum_c
  , a.json:REFERRAL_SOURCE_C:: varchar(18)                  as referral_source_c
  , a.json:EXPECTED_MWA_REVENUE_C:: number(12, 2)           as expected_mwa_revenue_c
  , a.json:EXPECTED_MONTAGE_REVENUE_C:: number(12, 2)       as expected_montage_revenue_c
  , a.json:PRODUCT_LINE_C:: varchar(765)                    as product_line_c
  , a.json:SHORT_NOTE_C:: varchar(765)                      as short_note_c
  , a.json:CLOSED_LOST_REASON_C:: varchar(765)              as closed_lost_reason_c
  , a.json:CLOSED_DATE_STAMP_C:: date                       as closed_date_stamp_c
  , a.json:PRIMARY_CONTACT_C:: varchar(18)                  as primary_contact_c
  , a.json:EXPECTED_REVENUE_C:: number(18, 2)               as expected_revenue_c
  , a.json:SYS_MIGRATION_SOURCE_C:: varchar(4099)           as sys_migration_source_c
  , a.json:SYS_MIGRATION_ID_C:: varchar(765)                as sys_migration_id_c
  , a.json:_FIVETRAN_SYNCED:: timestamptz                   as _fivetran_synced
  , a.json:REFERRAL_FIRM_C:: varchar(600)                   as referral_firm_c
  , a.json:PUSH_COUNT:: number                              as push_count
  , a.json:LAST_STAGE_CHANGE_DATE:: timestamptz             as last_stage_change_date
  , a.json:TOTAL_EXPECTED_REVENUE_C:: number(18, 2)         as total_expected_revenue_c
  , a.json:OPPORTUNITY_AGE_C:: double                       as opportunity_age_c
  , a.json:_FIVETRAN_DELETED:: boolean                      as _fivetran_deleted

  , a.effective_at::timestamp                               as effective_at
  , a._created_at::timestamp                                as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'opportunity'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                    as is_latest
from {{ source('salesforce_compass', 'opportunity') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'opportunity') }}
    group by 1, 2
)                                                      b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
