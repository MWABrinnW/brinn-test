select
    a.json:CONTACT_ID::text(500)         as contact_id
  , a.json:NAME::text(500)               as name
  , a.json:TIMESTAMP::text(500)          as timestamp
  , a.json:VALUE::text(500)              as value
  , a.json:SOURCE_ID::text(500)          as source_id
  , a.json:SOURCE::text(500)             as source
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced
  , a.json:_FIVETRAN_START::text(500)    as _fivetran_start
  , a.json:_FIVETRAN_END::text(500)      as _fivetran_end
  , a.json:_FIVETRAN_ACTIVE::text(500)   as _fivetran_active

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'contact_property_history'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'contact_property_history') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'contact_property_history') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at