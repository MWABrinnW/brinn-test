select
    a.json:CONTACT_ID::text(500)          as contact_id
  , a.json:MARKETING_EMAIL_ID::text(500)  as marketing_email_id
  , a.json:IS_CONTACT_INCLUDED::text(500) as is_contact_included
  , a.json:_FIVETRAN_SYNCED::text(500)    as _fivetran_synced

  , a.effective_at::timestamp             as effective_at
  , a._created_at::timestamp              as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'marketing_email_contact'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end  as is_latest
from {{ source('hubspot_network', 'marketing_email_contact') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'marketing_email_contact') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at