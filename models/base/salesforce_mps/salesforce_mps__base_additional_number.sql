select
    a.json:CREATED_DATE::timestamp_tz       as created_date
  , a.json:ID::text(900)                    as id
  , a.json:IS_DELETED::boolean              as is_deleted
  , a.json:NAME::text(1100)                 as name
  , a.json:DESCRIPTION::text(1600)          as description
  , a.json:_FIVETRAN_SYNCED::timestamp_tz   as _fivetran_synced
  , a.json:LAST_MODIFIED_DATE::timestamp_tz as last_modified_date
  , a.json:CALL_CENTER_ID::text(900)        as call_center_id
  , a.json:CREATED_BY_ID::text(900)         as created_by_id
  , a.json:LAST_MODIFIED_BY_ID::text(900)   as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP::timestamp_tz    as system_modstamp
  , a.json:_FIVETRAN_DELETED::boolean       as _fivetran_deleted
  , a.json:PHONE::text(1000)                as phone
  , a.effective_at::timestamp               as effective_at
  , a._created_at::timestamp                as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'additional_number'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end    as is_latest
from {{ source('salesforce_mps', 'additional_number') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'additional_number') }}
    group by 1, 2
)                                                        b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
