select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:COUNTRY::text(1100)                            as country
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:BEST_TIME_TO_CONTACT_END_TIME::text(1100)      as best_time_to_contact_end_time
  , a.json:PARENT_ID::text(900)                           as parent_id
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:IS_DEFAULT::boolean                            as is_default
  , a.json:ACTIVE_TO_DATE::date                           as active_to_date
  , a.json:OWNER_ID::text(900)                            as owner_id
  , a.json:LATITUDE::float                                as latitude
  , a.json:GEOCODE_ACCURACY::text(1600)                   as geocode_accuracy
  , a.json:IS_PRIMARY::boolean                            as is_primary
  , a.json:POSTAL_CODE::text(900)                         as postal_code
  , a.json:CONTACT_POINT_PHONE_ID::text(900)              as contact_point_phone_id
  , a.json:NAME::text(1600)                               as name
  , a.json:STATE::text(1100)                              as state
  , a.json:BEST_TIME_TO_CONTACT_START_TIME::text(1100)    as best_time_to_contact_start_time
  , a.json:STREET::text(1600)                             as street
  , a.json:BEST_TIME_TO_CONTACT_TIMEZONE::text(1600)      as best_time_to_contact_timezone
  , a.json:ADDRESS_TYPE::text(1000)                       as address_type
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:CITY::text(1000)                               as city
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:USAGE_TYPE::text(1000)                         as usage_type
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:ID::text(900)                                  as id
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:ACTIVE_FROM_DATE::date                         as active_from_date
  , a.json:LONGITUDE::float                               as longitude
  , a.json:PREFERENCE_RANK::number(38, 0)                 as preference_rank
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'contact_point_address'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'contact_point_address') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'contact_point_address') }}
    group by 1, 2
)                                                            b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
