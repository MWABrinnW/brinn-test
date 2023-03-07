select
    a.json:PIPELINE_ID::text(500)        as pipeline_id
  , a.json:LABEL::text(500)              as label
  , a.json:ACTIVE::text(500)             as active
  , a.json:DISPLAY_ORDER::text(500)      as display_order
  , a.json:_FIVETRAN_DELETED::text(500)  as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED::text(500)   as _fivetran_synced

  , a.effective_at::timestamp            as effective_at
  , a._created_at::timestamp             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'deal_pipeline'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'deal_pipeline') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'deal_pipeline') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at