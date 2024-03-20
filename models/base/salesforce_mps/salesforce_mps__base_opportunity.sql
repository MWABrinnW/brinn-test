select
    a.json:LAST_VIEWED_DATE::timestamp_tz                as last_viewed_date
  , a.json:LAST_STAGE_CHANGE_DATE::timestamp_tz          as last_stage_change_date
  , a.json:PRICEBOOK_2_ID::text(900)                     as pricebook_2_id
  , a.json:IS_DELETED::boolean                           as is_deleted
  , a.json:LEAD_SOURCE::text(1600)                       as lead_source
  , a.json:FISCAL_YEAR::number(38, 0)                    as fiscal_year
  , a.json:IS_WON::boolean                               as is_won
  , a.json:PROBABILITY::float                            as probability
  , a.json:ACCOUNT_ID::text(900)                         as account_id
  , a.json:NEXT_STEP::text(1600)                         as next_step
  , a.json:LAST_MODIFIED_BY_ID::text(900)                as last_modified_by_id
  , a.json:HAS_OPEN_ACTIVITY::boolean                    as has_open_activity
  , a.json:FISCAL::text(900)                             as fiscal
  , a.json:OWNER_ID::text(900)                           as owner_id
  , a.json:CONTACT_ID::text(900)                         as contact_id
  , a.json:PUSH_COUNT::number(38, 0)                     as push_count
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                 as system_modstamp
  , a.json:HAS_OVERDUE_TASK::boolean                     as has_overdue_task
  , a.json:FORECAST_CATEGORY_NAME::text(1600)            as forecast_category_name
  , a.json:ID::text(900)                                 as id
  , a.json:AMOUNT::number(18, 2)                         as amount
  , a.json:DESCRIPTION::text(96800)                      as description
  , a.json:_FIVETRAN_DELETED::boolean                    as _fivetran_deleted
  , a.json:STAGE_NAME::text(1600)                        as stage_name
  , a.json:FISCAL_QUARTER::number(38, 0)                 as fiscal_quarter
  , a.json:TYPE::text(1600)                              as type
  , a.json:LAST_MODIFIED_DATE::timestamp_tz              as last_modified_date
  , a.json:IS_CLOSED::boolean                            as is_closed
  , a.json:CLOSE_DATE::date                              as close_date
  , a.json:FORECAST_CATEGORY::text(1000)                 as forecast_category
  , a.json:CREATED_BY_ID::text(900)                      as created_by_id
  , a.json:CAMPAIGN_ID::text(900)                        as campaign_id
  , a.json:LAST_CLOSE_DATE_CHANGED_HISTORY_ID::text(900) as last_close_date_changed_history_id
  , a.json:CREATED_DATE::timestamp_tz                    as created_date
  , a.json:LAST_AMOUNT_CHANGED_HISTORY_ID::text(900)     as last_amount_changed_history_id
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                as _fivetran_synced
  , a.json:LAST_ACTIVITY_DATE::date                      as last_activity_date
  , a.json:HAS_OPPORTUNITY_LINE_ITEM::boolean            as has_opportunity_line_item
  , a.json:LAST_REFERENCED_DATE::timestamp_tz            as last_referenced_date
  , a.json:NAME::text(1200)                              as name
  , a.effective_at::timestamp                            as effective_at
  , a._created_at::timestamp                             as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'opportunity'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                 as is_latest
from {{ source('salesforce_mps', 'opportunity') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'opportunity') }}
    group by 1, 2
)                                                  b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
