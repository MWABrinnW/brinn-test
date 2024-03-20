select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:PERSON_MAILING_CITY::text(1000)                as person_mailing_city
  , a.json:PERSON_OTHER_POSTAL_CODE::text(900)            as person_other_postal_code
  , a.json:IS_PERSON_ACCOUNT::boolean                     as is_person_account
  , a.json:SHIPPING_LATITUDE::float                       as shipping_latitude
  , a.json:PERSON_CONTACT_ID::text(900)                   as person_contact_id
  , a.json:PERSON_OTHER_STATE::text(1100)                 as person_other_state
  , a.json:PERSON_TITLE::text(1100)                       as person_title
  , a.json:PERSON_OTHER_CITY::text(1000)                  as person_other_city
  , a.json:ANNUAL_HOUSEHOLD_INCOME_C::number(18, 0)       as annual_household_income_c
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:SHIPPING_POSTAL_CODE::text(900)                as shipping_postal_code
  , a.json:PERSON_ASSISTANT_PHONE::text(1000)             as person_assistant_phone
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:FAX::text(1000)                                as fax
  , a.json:SHIPPING_CITY::text(1000)                      as shipping_city
  , a.json:PERSON_OTHER_GEOCODE_ACCURACY::text(1000)      as person_other_geocode_accuracy
  , a.json:BILLING_POSTAL_CODE::text(900)                 as billing_postal_code
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:PERSON_EMAIL_BOUNCED_DATE::timestamp_tz        as person_email_bounced_date
  , a.json:NAME::text(1600)                               as name
  , a.json:JIGSAW_COMPANY_ID::text(900)                   as jigsaw_company_id
  , a.json:PERSON_HOME_PHONE::text(1000)                  as person_home_phone
  , a.json:TYPE::text(1600)                               as type
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:SHIPPING_STATE::text(1100)                     as shipping_state
  , a.json:JIGSAW::text(900)                              as jigsaw
  , a.json:NUMBER_OF_EMPLOYEES::number(38, 0)             as number_of_employees
  , a.json:PERSON_OTHER_LATITUDE::float                   as person_other_latitude
  , a.json:ID::text(900)                                  as id
  , a.json:LAST_NAME::text(1100)                          as last_name
  , a.json:SIC_DESC::text(1100)                           as sic_desc
  , a.json:PERSON_LAST_CUUPDATE_DATE::timestamp_tz        as person_last_cuupdate_date
  , a.json:PERSON_OTHER_STREET::text(1600)                as person_other_street
  , a.json:RECORD_TYPE_ID::text(900)                      as record_type_id
  , a.json:FIRST_NAME::text(1000)                         as first_name
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:PHONE::text(1000)                              as phone
  , a.json:PERSON_MAILING_GEOCODE_ACCURACY::text(1000)    as person_mailing_geocode_accuracy
  , a.json:PERSON_MOBILE_PHONE::text(1000)                as person_mobile_phone
  , a.json:PERSON_MAILING_LATITUDE::float                 as person_mailing_latitude
  , a.json:ANNUAL_REVENUE::number(18, 0)                  as annual_revenue
  , a.json:PERSON_MAILING_LONGITUDE::float                as person_mailing_longitude
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:IS_PRIORITY_RECORD::boolean                    as is_priority_record
  , a.json:BILLING_GEOCODE_ACCURACY::text(1000)           as billing_geocode_accuracy
  , a.json:BILLING_STREET::text(1600)                     as billing_street
  , a.json:PARENT_ID::text(900)                           as parent_id
  , a.json:PERSON_ASSISTANT_NAME::text(1000)              as person_assistant_name
  , a.json:BILLING_LONGITUDE::float                       as billing_longitude
  , a.json:BILLING_LATITUDE::float                        as billing_latitude
  , a.json:PERSON_INDIVIDUAL_ID::text(900)                as person_individual_id
  , a.json:DESCRIPTION::text(96800)                       as description
  , a.json:PERSON_LEAD_SOURCE::text(1600)                 as person_lead_source
  , a.json:BILLING_CITY::text(1000)                       as billing_city
  , a.json:PERSON_DEPARTMENT::text(1100)                  as person_department
  , a.json:BILLING_COUNTRY::text(1100)                    as billing_country
  , a.json:SHIPPING_COUNTRY::text(1100)                   as shipping_country
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:WEBSITE::text(1600)                            as website
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:INDUSTRY::text(1600)                           as industry
  , a.json:BILLING_STATE::text(1100)                      as billing_state
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:TEST_DATE_C::date                              as test_date_c
  , a.json:OWNER_ID::text(900)                            as owner_id
  , a.json:SHIPPING_GEOCODE_ACCURACY::text(1000)          as shipping_geocode_accuracy
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:PERSON_OTHER_LONGITUDE::float                  as person_other_longitude
  , a.json:NET_WORTH_C::number(18, 0)                     as net_worth_c
  , a.json:PERSON_MAILING_STREET::text(1600)              as person_mailing_street
  , a.json:PHOTO_URL::text(1600)                          as photo_url
  , a.json:PERSON_MAILING_STATE::text(1100)               as person_mailing_state
  , a.json:TAX_BRACKET_C::float                           as tax_bracket_c
  , a.json:SALUTATION::text(1000)                         as salutation
  , a.json:PERSON_LAST_CUREQUEST_DATE::timestamp_tz       as person_last_curequest_date
  , a.json:PERSON_EMAIL_BOUNCED_REASON::text(1600)        as person_email_bounced_reason
  , a.json:PERSON_OTHER_COUNTRY::text(1100)               as person_other_country
  , a.json:PERSON_OTHER_PHONE::text(1000)                 as person_other_phone
  , a.json:TRADING_SYSTEM_HOUSE_ID_C::text(900)           as trading_system_house_id_c
  , a.json:PERSON_MAILING_COUNTRY::text(1100)             as person_mailing_country
  , a.json:PERSON_BIRTHDATE::date                         as person_birthdate
  , a.json:LAST_ACTIVITY_DATE::date                       as last_activity_date
  , a.json:PERSON_MAILING_POSTAL_CODE::text(900)          as person_mailing_postal_code
  , a.json:PERSON_EMAIL::text(1100)                       as person_email
  , a.json:SHIPPING_STREET::text(1600)                    as shipping_street
  , a.json:ACCOUNT_SOURCE::text(1600)                     as account_source
  , a.json:MASTER_RECORD_ID::text(900)                    as master_record_id
  , a.json:SHIPPING_LONGITUDE::float                      as shipping_longitude
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'account'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'account') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'account') }}
    group by 1, 2
)                                              b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
