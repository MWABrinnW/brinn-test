select
    a.json:GUID::text(500)                       as guid
  , a.json:PORTAL_ID::text(500)                  as portal_id
  , a.json:NAME::text(500)                       as name
  , a.json:ACTION::text(500)                     as action
  , a.json:METHOD::text(500)                     as method
  , a.json:CSS_CLASS::text(500)                  as css_class
  , a.json:REDIRECT::text(500)                   as redirect
  , a.json:SUBMIT_TEXT::text(500)                as submit_text
  , a.json:FOLLOW_UP_ID::text(500)               as follow_up_id
  , a.json:NOTIFY_RECIPIENTS::text(500)          as notify_recipients
  , a.json:LEAD_NURTURING_CAMPAIGN_ID::text(500) as lead_nurturing_campaign_id
  , a.json:FORM_TYPE::text(500)                  as form_type
  , a.json:CREATED_AT::text(500)                 as created_at
  , a.json:UPDATED_AT::text(500)                 as updated_at
  , a.json:_FIVETRAN_DELETED::text(500)          as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED::text(500)           as _fivetran_synced

  , a.effective_at::timestamp                    as effective_at
  , a._created_at::timestamp                     as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'form'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end         as is_latest
from {{ source('hubspot_network', 'form') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'form') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at