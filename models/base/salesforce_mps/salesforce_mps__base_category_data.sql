select
    a.json:LAST_MODIFIED_BY_ID::text(900)   as last_modified_by_id
  , a.json:CREATED_BY_ID::text(900)         as created_by_id
  , a.json:ID::text(900)                    as id
  , a.json:SYSTEM_MODSTAMP::timestamp_tz    as system_modstamp
  , a.json:_FIVETRAN_SYNCED::timestamp_tz   as _fivetran_synced
  , a.json:_FIVETRAN_DELETED::boolean       as _fivetran_deleted
  , a.json:CATEGORY_NODE_ID::text(900)      as category_node_id
  , a.json:RELATED_SOBJECT_ID::text(900)    as related_sobject_id
  , a.json:CREATED_DATE::timestamp_tz       as created_date
  , a.json:IS_DELETED::boolean              as is_deleted
  , a.json:LAST_MODIFIED_DATE::timestamp_tz as last_modified_date
  , a.effective_at::timestamp               as effective_at
  , a._created_at::timestamp                as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'category_data'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end    as is_latest
from {{ source('salesforce_mps', 'category_data') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'category_data') }}
    group by 1, 2
)                                                    b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
