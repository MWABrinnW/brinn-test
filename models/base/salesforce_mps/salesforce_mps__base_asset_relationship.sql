select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:ASSET_ID::text(900)                            as asset_id
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:ASSET_RELATIONSHIP_NUMBER::text(1600)          as asset_relationship_number
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:RELATIONSHIP_TYPE::text(1000)                  as relationship_type
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:FROM_DATE::timestamp_tz                        as from_date
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:TO_DATE::timestamp_tz                          as to_date
  , a.json:ID::text(900)                                  as id
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:RELATED_ASSET_ID::text(900)                    as related_asset_id
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'asset_relationship'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'asset_relationship') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'asset_relationship') }}
    group by 1, 2
)                                                         b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
