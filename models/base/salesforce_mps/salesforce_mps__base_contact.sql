select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:EMAIL_BOUNCED_REASON::text(1600)               as email_bounced_reason
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:OTHER_COUNTRY::text(1100)                      as other_country
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:JIGSAW_CONTACT_ID::text(900)                   as jigsaw_contact_id
  , a.json:MAILING_POSTAL_CODE::text(900)                 as mailing_postal_code
  , a.json:OTHER_STATE::text(1100)                        as other_state
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:ACCOUNT_ID::text(900)                          as account_id
  , a.json:OTHER_LATITUDE::float                          as other_latitude
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:RECORD_TYPE_ID::text(900)                      as record_type_id
  , a.json:JIGSAW::text(900)                              as jigsaw
  , a.json:MASTER_RECORD_ID::text(900)                    as master_record_id
  , a.json:PHOTO_URL::text(1600)                          as photo_url
  , a.json:MAILING_CITY::text(1000)                       as mailing_city
  , a.json:MAILING_LONGITUDE::float                       as mailing_longitude
  , a.json:LEAD_SOURCE::text(1600)                        as lead_source
  , a.json:SALUTATION::text(1000)                         as salutation
  , a.json:TITLE::text(1200)                              as title
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:EMAIL::text(1100)                              as email
  , a.json:EMAIL_BOUNCED_DATE::timestamp_tz               as email_bounced_date
  , a.json:INDIVIDUAL_ID::text(900)                       as individual_id
  , a.json:IS_EMAIL_BOUNCED::boolean                      as is_email_bounced
  , a.json:ASSISTANT_PHONE::text(1000)                    as assistant_phone
  , a.json:MAILING_COUNTRY::text(1100)                    as mailing_country
  , a.json:OTHER_GEOCODE_ACCURACY::text(1000)             as other_geocode_accuracy
  , a.json:NAME::text(1200)                               as name
  , a.json:ASSISTANT_NAME::text(1000)                     as assistant_name
  , a.json:OWNER_ID::text(900)                            as owner_id
  , a.json:LAST_ACTIVITY_DATE::date                       as last_activity_date
  , a.json:MAILING_GEOCODE_ACCURACY::text(1000)           as mailing_geocode_accuracy
  , a.json:REPORTS_TO_ID::text(900)                       as reports_to_id
  , a.json:HOME_PHONE::text(1000)                         as home_phone
  , a.json:OTHER_POSTAL_CODE::text(900)                   as other_postal_code
  , a.json:DESCRIPTION::text(96800)                       as description
  , a.json:MOBILE_PHONE::text(1000)                       as mobile_phone
  , a.json:OTHER_CITY::text(1000)                         as other_city
  , a.json:LAST_NAME::text(1100)                          as last_name
  , a.json:MAILING_STREET::text(1600)                     as mailing_street
  , a.json:PHONE::text(1000)                              as phone
  , a.json:IS_PERSON_ACCOUNT::boolean                     as is_person_account
  , a.json:DEPARTMENT::text(1100)                         as department
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:MAILING_STATE::text(1100)                      as mailing_state
  , a.json:OTHER_PHONE::text(1000)                        as other_phone
  , a.json:OTHER_LONGITUDE::float                         as other_longitude
  , a.json:IS_PRIORITY_RECORD::boolean                    as is_priority_record
  , a.json:OTHER_STREET::text(1600)                       as other_street
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:LAST_CUUPDATE_DATE::timestamp_tz               as last_cuupdate_date
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:LAST_CUREQUEST_DATE::timestamp_tz              as last_curequest_date
  , a.json:FAX::text(1000)                                as fax
  , a.json:FIRST_NAME::text(1000)                         as first_name
  , a.json:BIRTHDATE::date                                as birthdate
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:MAILING_LATITUDE::float                        as mailing_latitude
  , a.json:ID::text(900)                                  as id
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'contact'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'contact') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'contact') }}
    group by 1, 2
)                                              b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
