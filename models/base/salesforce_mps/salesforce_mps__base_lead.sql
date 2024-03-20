select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:NUMBER_OF_EMPLOYEES::number(38, 0)             as number_of_employees
  , a.json:CITY::text(1000)                               as city
  , a.json:JIGSAW::text(900)                              as jigsaw
  , a.json:JIGSAW_CONTACT_ID::text(900)                   as jigsaw_contact_id
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:WEBSITE::text(1600)                            as website
  , a.json:CONVERTED_OPPORTUNITY_ID::text(900)            as converted_opportunity_id
  , a.json:PHONE::text(1000)                              as phone
  , a.json:COUNTRY::text(1100)                            as country
  , a.json:EMAIL::text(1100)                              as email
  , a.json:STATE::text(1100)                              as state
  , a.json:COMPANY::text(1600)                            as company
  , a.json:MASTER_RECORD_ID::text(900)                    as master_record_id
  , a.json:EMAIL_BOUNCED_DATE::timestamp_tz               as email_bounced_date
  , a.json:ANNUAL_REVENUE::number(18, 0)                  as annual_revenue
  , a.json:DESCRIPTION::text(96800)                       as description
  , a.json:LEAD_SOURCE::text(1600)                        as lead_source
  , a.json:CONVERTED_DATE::date                           as converted_date
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:RATING::text(1600)                             as rating
  , a.json:IS_CONVERTED::boolean                          as is_converted
  , a.json:PHOTO_URL::text(1600)                          as photo_url
  , a.json:IS_UNREAD_BY_OWNER::boolean                    as is_unread_by_owner
  , a.json:LONGITUDE::float                               as longitude
  , a.json:IS_PRIORITY_RECORD::boolean                    as is_priority_record
  , a.json:INDIVIDUAL_ID::text(900)                       as individual_id
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:STREET::text(1600)                             as street
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:CONVERTED_CONTACT_ID::text(900)                as converted_contact_id
  , a.json:GEOCODE_ACCURACY::text(1000)                   as geocode_accuracy
  , a.json:CONVERTED_ACCOUNT_ID::text(900)                as converted_account_id
  , a.json:LATITUDE::float                                as latitude
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:FIRST_NAME::text(1000)                         as first_name
  , a.json:SALUTATION::text(1000)                         as salutation
  , a.json:LAST_ACTIVITY_DATE::date                       as last_activity_date
  , a.json:POSTAL_CODE::text(900)                         as postal_code
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:STATUS::text(1600)                             as status
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:EMAIL_BOUNCED_REASON::text(1600)               as email_bounced_reason
  , a.json:LAST_NAME::text(1100)                          as last_name
  , a.json:ID::text(900)                                  as id
  , a.json:INDUSTRY::text(1600)                           as industry
  , a.json:NAME::text(1200)                               as name
  , a.json:TITLE::text(1200)                              as title
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:OWNER_ID::text(900)                            as owner_id
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'lead'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'lead') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'lead') }}
    group by 1, 2
)                                           b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
