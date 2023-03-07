select
    a.json:OWNER_ID::text(500)           as owner_id
  , a.json:FIRST_NAME::text(500)         as first_name
  , a.json:LAST_NAME::text(500)          as last_name
  , a.json:EMAIL::text(500)              as email
  , a.json:CREATED_AT::text(500)         as created_at
  , a.json:UPDATED_AT::text(500)         as updated_at
  , a.json:ACTIVE_USER_ID::text(500)     as active_user_id
  , a.json:IS_ACTIVE::text(500)          as is_active
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'owner'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'owner') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'owner') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at