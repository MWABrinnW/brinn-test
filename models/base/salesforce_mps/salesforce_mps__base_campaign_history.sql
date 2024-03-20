select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:NEW_VALUE::text(1600)                          as new_value
  , a.json:DATA_TYPE::text(1000)                          as data_type
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:FIELD::text(1600)                              as field
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:ID::text(900)                                  as id
  , a.json:CAMPAIGN_ID::text(900)                         as campaign_id
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:OLD_VALUE::text(1600)                          as old_value
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'campaign_history'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'campaign_history') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'campaign_history') }}
    group by 1, 2
)                                                       b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
