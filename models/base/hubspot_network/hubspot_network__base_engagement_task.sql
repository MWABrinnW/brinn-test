select
    a.json:ENGAGEMENT_ID::text(500)               as engagement_id
  , a.json:BODY::text                             as body
  , a.json:SUBJECT::text                          as subject
  , a.json:STATUS::text(500)                      as status
  , a.json:FOR_OBJECT_TYPE::text(500)             as for_object_type
  , a.json:TASK_TYPE::text(500)                   as task_type
  , a.json:COMPLETION_DATE::text(500)             as completion_date
  , a.json:PRIORITY::text(500)                    as priority
  , a.json:_FIVETRAN_SYNCED::text(500)            as _fivetran_synced
  , a.json:IS_ALL_DAY::text(500)                  as is_all_day
  , a.json:TEMPLATE_ID::text(500)                 as template_id
  , a.json:SEQUENCE_STEP_ENROLLMENT_ID::text(500) as sequence_step_enrollment_id
  , a.json:SEQUENCE_STEP_ORDER::text(500)         as sequence_step_order

  , a.effective_at::timestamp                     as effective_at
  , a._created_at::timestamp                      as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'engagement_task'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end          as is_latest
from {{ source('hubspot_network', 'engagement_task') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'engagement_task') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at