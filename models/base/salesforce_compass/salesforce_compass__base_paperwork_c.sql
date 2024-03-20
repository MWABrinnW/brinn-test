select
    a.json:ID::text(200)                        as id
  , a.json:OWNER_ID::text(200)                  as owner_id
  , a.json:IS_DELETED::boolean                  as is_deleted
  , a.json:NAME::text(200)                      as name
  , a.json:RECORD_TYPE_ID::text(200)            as record_type_id
  , a.json:CREATED_DATE::timestamptz(9)         as created_date
  , a.json:CREATED_BY_ID::text(200)             as created_by_id
  , a.json:LAST_MODIFIED_DATE::timestamptz(9)   as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID::text(200)       as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP::timestamptz(9)      as system_modstamp
  , a.json:LAST_ACTIVITY_DATE::date             as last_activity_date
  , a.json:LAST_VIEWED_DATE::timestamptz(9)     as last_viewed_date
  , a.json:LAST_REFERENCED_DATE::timestamptz(9) as last_referenced_date
  , a.json:PAPERWORK_ID_18_C::text(200)         as paperwork_id_18_c
  , a.json:_FIVETRAN_DELETED::boolean           as _fivetran_deleted
  , a.json:_FIVETRAN_SYNCED::timestamptz(9)     as _fivetran_synced

  , a.effective_at::timestamp                   as effective_at
  , a._created_at::timestamp                    as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'paperwork_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end        as is_latest
from {{ source('salesforce_compass', 'paperwork_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'paperwork_c') }}
    group by 1, 2
)                                                      b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at