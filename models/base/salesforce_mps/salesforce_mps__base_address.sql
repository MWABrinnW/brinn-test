select
    a.json:DESCRIPTION::text(1600)          as description
  , a.json:TIME_ZONE::text(1600)            as time_zone
  , a.json:LATITUDE::float                  as latitude
  , a.json:COUNTRY::text(1100)              as country
  , a.json:POSTAL_CODE::text(900)           as postal_code
  , a.json:ID::text(900)                    as id
  , a.json:PARENT_ID::text(900)             as parent_id
  , a.json:LAST_MODIFIED_DATE::timestamp_tz as last_modified_date
  , a.json:_FIVETRAN_DELETED::boolean       as _fivetran_deleted
  , a.json:NAME::text(1600)                 as name
  , a.json:LAST_MODIFIED_BY_ID::text(900)   as last_modified_by_id
  , a.json:STREET::text(1600)               as street
  , a.json:CREATED_BY_ID::text(900)         as created_by_id
  , a.json:DRIVING_DIRECTIONS::text(3800)   as driving_directions
  , a.json:GEOCODE_ACCURACY::text(1600)     as geocode_accuracy
  , a.json:SYSTEM_MODSTAMP::timestamp_tz    as system_modstamp
  , a.json:IS_DELETED::boolean              as is_deleted
  , a.json:_FIVETRAN_SYNCED::timestamp_tz   as _fivetran_synced
  , a.json:LOCATION_TYPE::text(1000)        as location_type
  , a.json:CREATED_DATE::timestamp_tz       as created_date
  , a.json:CITY::text(1000)                 as city
  , a.json:LONGITUDE::float                 as longitude
  , a.json:ADDRESS_TYPE::text(1000)         as address_type
  , a.json:STATE::text(1100)                as state
  , a.effective_at::timestamp               as effective_at
  , a._created_at::timestamp                as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'address'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end    as is_latest
from {{ source('salesforce_mps', 'address') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'address') }}
    group by 1, 2
)                                              b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
