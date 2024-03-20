select
    'salesforce'::text(200)                                     as system_name
  , 'baystate'::text(200)                                       as system_instance
  , concat(system_name, '__', system_instance)::text(200)       as system_key
  , 'mps'::text(200)                                            as firm_source
  , a.json:RECEIVES_INFO_EMAILS::boolean                        as receives_info_emails
  , a.json:STATE::text(1100)                                    as state
  , a.json:PREFERENCES_ONLY_LLPERM_USER_ALLOWED::boolean        as preferences_only_llperm_user_allowed
  , a.json:PHONE::text(1000)                                    as phone
  , a.json:CREATED_DATE::timestamp_tz                           as created_date
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                        as system_modstamp
  , a.json:PREFERENCES_LIGHTNING_LOGIN_ENABLED::boolean         as preferences_lightning_login_enabled
  , a.json:GEOCODE_ACCURACY::text(1000)                         as geocode_accuracy
  , a.json:LANGUAGE_LOCALE_KEY::text(1000)                      as language_locale_key
  , a.json:LAST_MODIFIED_DATE::timestamp_tz                     as last_modified_date
  , a.json:COUNTRY::text(1100)                                  as country
  , a.json:USES_START_DATE_AS_FISCAL_YEAR_NAME::boolean         as uses_start_date_as_fiscal_year_name
  , a.json:NUM_KNOWLEDGE_SERVICE::number(38, 0)                 as num_knowledge_service
  , a.json:WEB_TO_CASE_DEFAULT_ORIGIN::text(1000)               as web_to_case_default_origin
  , a.json:CITY::text(1000)                                     as city
  , a.json:IS_SANDBOX::boolean                                  as is_sandbox
  , a.json:COMPLIANCE_BCC_EMAIL::text(1100)                     as compliance_bcc_email
  , a.json:DEFAULT_LOCALE_SID_KEY::text(1000)                   as default_locale_sid_key
  , a.json:PREFERENCES_REQUIRE_OPPORTUNITY_PRODUCTS::boolean    as preferences_require_opportunity_products
  , a.json:ID::text(900)                                        as id
  , a.json:DEFAULT_OPPORTUNITY_ACCESS::text(1000)               as default_opportunity_access
  , a.json:DEFAULT_CAMPAIGN_ACCESS::text(1000)                  as default_campaign_access
  , a.json:RECEIVES_ADMIN_INFO_EMAILS::boolean                  as receives_admin_info_emails
  , a.json:PREFERENCES_EMAIL_SENDER_ID_COMPLIANCE::boolean      as preferences_email_sender_id_compliance
  , a.json:PREFERENCES_AUTO_SELECT_INDIVIDUAL_ON_MERGE::boolean as preferences_auto_select_individual_on_merge
  , a.json:DIVISION::text(1100)                                 as division
  , a.json:DEFAULT_LEAD_ACCESS::text(1000)                      as default_lead_access
  , a.json:LONGITUDE::float                                     as longitude
  , a.json:LATITUDE::float                                      as latitude
  , a.json:NAMESPACE_PREFIX::text(900)                          as namespace_prefix
  , a.json:DEFAULT_CASE_ACCESS::text(1000)                      as default_case_access
  , a.json:LAST_MODIFIED_BY_ID::text(900)                       as last_modified_by_id
  , a.json:UI_SKIN::text(1000)                                  as ui_skin
  , a.json:DEFAULT_CALENDAR_ACCESS::text(1000)                  as default_calendar_access
  , a.json:DEFAULT_ACCOUNT_ACCESS::text(1000)                   as default_account_access
  , a.json:FAX::text(1000)                                      as fax
  , a.json:CREATED_BY_ID::text(900)                             as created_by_id
  , a.json:FISCAL_YEAR_START_MONTH::number(38, 0)               as fiscal_year_start_month
  , a.json:DEFAULT_CONTACT_ACCESS::text(1000)                   as default_contact_access
  , a.json:IS_READ_ONLY::boolean                                as is_read_only
  , a.json:POSTAL_CODE::text(900)                               as postal_code
  , a.json:PRIMARY_CONTACT::text(1100)                          as primary_contact
  , a.json:MONTHLY_PAGE_VIEWS_USED::number(38, 0)               as monthly_page_views_used
  , a.json:TRIAL_EXPIRATION_DATE::timestamp_tz                  as trial_expiration_date
  , a.json:_FIVETRAN_DELETED::boolean                           as _fivetran_deleted
  , a.json:STREET::text(1600)                                   as street
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                       as _fivetran_synced
  , a.json:TIME_ZONE_SID_KEY::text(1000)                        as time_zone_sid_key
  , a.json:DEFAULT_PRICEBOOK_ACCESS::text(1000)                 as default_pricebook_access
  , a.json:PREFERENCES_CONSENT_MANAGEMENT_ENABLED::boolean      as preferences_consent_management_enabled
  , a.json:MONTHLY_PAGE_VIEWS_ENTITLEMENT::number(38, 0)        as monthly_page_views_entitlement
  , a.json:INSTANCE_NAME::text(900)                             as instance_name
  , a.json:NAME::text(1100)                                     as name
  , a.json:ORGANIZATION_TYPE::text(1000)                        as organization_type
  , a.json:SIGNUP_COUNTRY_ISO_CODE::text(900)                   as signup_country_iso_code
  , a.effective_at::timestamp                                   as effective_at
  , a._created_at::timestamp                                    as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'organization'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                        as is_latest
from {{ source('salesforce_mps', 'organization') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'organization') }}
    group by 1, 2
)                                                   b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
