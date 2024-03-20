select
    a.json:NUMBER_OF_WON_OPPORTUNITIES::number(38, 0) as number_of_won_opportunities
  , a.json:STATUS::text(1600)                         as status
  , a.json:END_DATE::date                             as end_date
  , a.json:AMOUNT_WON_OPPORTUNITIES::number(18, 0)    as amount_won_opportunities
  , a.json:OWNER_ID::text(900)                        as owner_id
  , a.json:IS_DELETED::boolean                        as is_deleted
  , a.json:ID::text(900)                              as id
  , a.json:EXPECTED_REVENUE::number(18, 0)            as expected_revenue
  , a.json:AMOUNT_ALL_OPPORTUNITIES::number(18, 0)    as amount_all_opportunities
  , a.json:CREATED_DATE::timestamp_tz                 as created_date
  , a.json:LAST_VIEWED_DATE::timestamp_tz             as last_viewed_date
  , a.json:START_DATE::date                           as start_date
  , a.json:SYSTEM_MODSTAMP::timestamp_tz              as system_modstamp
  , a.json:CAMPAIGN_MEMBER_RECORD_TYPE_ID::text(900)  as campaign_member_record_type_id
  , a.json:ACTUAL_COST::number(18, 0)                 as actual_cost
  , a.json:NUMBER_OF_RESPONSES::number(38, 0)         as number_of_responses
  , a.json:NUMBER_SENT::float                         as number_sent
  , a.json:LAST_REFERENCED_DATE::timestamp_tz         as last_referenced_date
  , a.json:_FIVETRAN_SYNCED::timestamp_tz             as _fivetran_synced
  , a.json:EXPECTED_RESPONSE::float                   as expected_response
  , a.json:BUDGETED_COST::number(18, 0)               as budgeted_cost
  , a.json:_FIVETRAN_DELETED::boolean                 as _fivetran_deleted
  , a.json:NUMBER_OF_LEADS::number(38, 0)             as number_of_leads
  , a.json:NUMBER_OF_CONVERTED_LEADS::number(38, 0)   as number_of_converted_leads
  , a.json:LAST_ACTIVITY_DATE::date                   as last_activity_date
  , a.json:LAST_MODIFIED_BY_ID::text(900)             as last_modified_by_id
  , a.json:TYPE::text(1600)                           as type
  , a.json:DESCRIPTION::text(96800)                   as description
  , a.json:IS_ACTIVE::boolean                         as is_active
  , a.json:NUMBER_OF_OPPORTUNITIES::number(38, 0)     as number_of_opportunities
  , a.json:CREATED_BY_ID::text(900)                   as created_by_id
  , a.json:PARENT_ID::text(900)                       as parent_id
  , a.json:NUMBER_OF_CONTACTS::number(38, 0)          as number_of_contacts
  , a.json:LAST_MODIFIED_DATE::timestamp_tz           as last_modified_date
  , a.json:NAME::text(1100)                           as name
  , a.effective_at::timestamp                         as effective_at
  , a._created_at::timestamp                          as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'campaign'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end              as is_latest
from {{ source('salesforce_mps', 'campaign') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'campaign') }}
    group by 1, 2
)                                               b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
