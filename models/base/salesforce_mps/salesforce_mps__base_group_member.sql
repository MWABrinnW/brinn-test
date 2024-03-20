select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:GROUP_ID::text(900)                            as group_id
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:ID::text(900)                                  as id
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:USER_OR_GROUP_ID::text(900)                    as user_or_group_id
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'group_member'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'group_member') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'group_member') }}
    group by 1, 2
)                                                   b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
