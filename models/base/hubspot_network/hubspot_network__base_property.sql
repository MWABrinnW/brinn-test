select
    a.json:_FIVETRAN_ID::text(500)       as _fivetran_id
  , a.json:HUBSPOT_OBJECT::text(500)     as hubspot_object
  , a.json:NAME::text(500)               as name
  , a.json:LABEL::text(500)              as label
  , a.json:DESCRIPTION::text(500)        as description
  , a.json:GROUP_NAME::text(500)         as group_name
  , a.json:TYPE::text(500)               as type
  , a.json:FIELD_TYPE::text(500)         as field_type
  , a.json:CALCULATED::text(500)         as calculated
  , a.json:HUBSPOT_DEFINED::text(500)    as hubspot_defined
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'property'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'property') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'property') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at