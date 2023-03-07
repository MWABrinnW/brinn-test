select
    a.json:CONTACT_ID::text(500)                    as contact_id
  , a.json:FORM_ID::text(500)                       as form_id
  , a.json:TIMESTAMP::text(500)                     as timestamp
  , a.json:PORTAL_ID::text(500)                     as portal_id
  , a.json:PAGE_ID::text(500)                       as page_id
  , a.json:_FIVETRAN_SYNCED::text(500)              as _fivetran_synced

  , a.effective_at::timestamp                       as effective_at
  , a._created_at::timestamp                        as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'contact_form_submission'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'contact_form_submission') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'contact_form_submission') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at