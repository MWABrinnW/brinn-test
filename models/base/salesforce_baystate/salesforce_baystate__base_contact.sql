{% set src = source('salesforce_baystate', 'contact') %}

select
    'salesforce'::text(200)                                   as system_name
    , 'baystate'::text(200)                                   as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'baystate'::text(200)                                   as firm_source
    , a.json:LAST_CUUPDATE_DATE::timestamp_tz                 as last_cuupdate_date
    , a.json:MAILING_STATE::text(1100)                        as mailing_state
    , a.json:OTHER_CITY::text(1000)                           as other_city
    , a.json:LEAD_SOURCE::text(1600)                          as lead_source
    , a.json:LAST_ACTIVITY_DATE::date                         as last_activity_date
    , a.json:SALUTATION::text(1000)                           as salutation
    , a.json:MAILING_STREET::text(1600)                       as mailing_street
    , a.json:JIGSAW_CONTACT_ID::text(900)                     as jigsaw_contact_id
    , a.json:LAST_VIEWED_DATE::timestamp_tz                   as last_viewed_date
    , a.json:JIGSAW::text(900)                                as jigsaw
    , a.json:OTHER_STREET::text(1600)                         as other_street
    , a.json:MAILING_LATITUDE::float                          as mailing_latitude
    , a.json:LAST_MODIFIED_DATE::timestamp_tz                 as last_modified_date
    , a.json:MIDDLE_NAME::text(1000)                          as middle_name
    , a.json:PHOTO_URL::text(1600)                            as photo_url
    , a.json:EMAIL_BOUNCED_DATE::timestamp_tz                 as email_bounced_date
    , a.json:LAST_NAME::text(1100)                            as last_name
    , a.json:IS_PRIORITY_RECORD::boolean                      as is_priority_record
    , a.json:CREATED_DATE::timestamp_tz                       as created_date
    , a.json:OWNER_ID::text(900)                              as owner_id
    , a.json:MASTER_RECORD_ID::text(900)                      as master_record_id
    , a.json:LAST_MODIFIED_BY_ID::text(900)                   as last_modified_by_id
    , a.json:IS_PERSON_ACCOUNT::boolean                       as is_person_account
    , a.json:REPORTS_TO_ID::text(900)                         as reports_to_id
    , a.json:FIRST_NAME::text(1000)                           as first_name
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:OTHER_STATE::text(1100)                          as other_state
    , a.json:PHONE::text(1000)                                as phone
    , a.json:EMAIL_BOUNCED_REASON::text(1600)                 as email_bounced_reason
    , a.json:ASSISTANT_PHONE::text(1000)                      as assistant_phone
    , a.json:_FIVETRAN_SYNCED::timestamp_tz                   as _fivetran_synced
    , a.json:REP_ID_C::text(900)                              as rep_id_c
    , a.json:CREATED_BY_ID::text(900)                         as created_by_id
    , a.json:TITLE::text(1200)                                as title
    , a.json:MAILING_POSTAL_CODE::text(900)                   as mailing_postal_code
    , a.json:DESCRIPTION::text(96800)                         as description
    , a.json:IS_EMAIL_BOUNCED::boolean                        as is_email_bounced
    , a.json:LAST_REFERENCED_DATE::timestamp_tz               as last_referenced_date
    , a.json:MOBILE_PHONE::text(1000)                         as mobile_phone
    , a.json:MAILING_LONGITUDE::float                         as mailing_longitude
    , a.json:MAILING_COUNTRY::text(1100)                      as mailing_country
    , a.json:FAX::text(1000)                                  as fax
    , a.json:OTHER_POSTAL_CODE::text(900)                     as other_postal_code
    , a.json:ID::text(900)                                    as id
    , a.json:OTHER_GEOCODE_ACCURACY::text(1000)               as other_geocode_accuracy
    , a.json:SUFFIX::text(1000)                               as suffix
    , a.json:OTHER_LONGITUDE::float                           as other_longitude
    , a.json:HOME_PHONE::text(1000)                           as home_phone
    , a.json:MAILING_GEOCODE_ACCURACY::text(1000)             as mailing_geocode_accuracy
    , a.json:EMAIL::text(1100)                                as email
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted
    , a.json:BIRTHDATE::date                                  as birthdate
    , a.json:LAST_CUREQUEST_DATE::timestamp_tz                as last_curequest_date
    , a.json:ASSISTANT_NAME::text(1000)                       as assistant_name
    , a.json:SYSTEM_MODSTAMP::timestamp_tz                    as system_modstamp
    , a.json:INDIVIDUAL_ID::text(900)                         as individual_id
    , a.json:OTHER_PHONE::text(1000)                          as other_phone
    , a.json:OTHER_LATITUDE::float                            as other_latitude
    , a.json:DEPARTMENT::text(1100)                           as department
    , a.json:MAILING_CITY::text(1000)                         as mailing_city
    , a.json:ACCOUNT_ID::text(900)                            as account_id
    , a.json:OTHER_COUNTRY::text(1100)                        as other_country
    , a.json:RECORD_TYPE_ID::text(900)                        as record_type_id
    , a.json:NAME::text(1200)                                 as name
    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
    reference=src,
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
    , case
        when a._created_at = (
                select max(sub._created_at)
                from {{ src }} as sub
                where sub.effective_at::date = a.effective_at::date
                    and sub.json:ID::text(200) = a.json:ID::text(200)
            )
            then 1
        else 0
    end::int                                                  as is_head_for_day
    , case when b.rn = 1 then 1 else 0 end                    as is_latest
from {{ src }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at                                                                     as _created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn
    from {{ src }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
