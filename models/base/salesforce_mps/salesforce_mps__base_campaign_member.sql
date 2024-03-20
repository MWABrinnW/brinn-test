select
    a.json:LEAD_ID::text(900)                  as lead_id
  , a.json:IS_DELETED::boolean                 as is_deleted
  , a.json:FIRST_NAME::text(1000)              as first_name
  , a.json:FAX::text(1000)                     as fax
  , a.json:TYPE::text(1000)                    as type
  , a.json:HAS_OPTED_OUT_OF_EMAIL::boolean     as has_opted_out_of_email
  , a.json:TITLE::text(1200)                   as title
  , a.json:SYSTEM_MODSTAMP::timestamp_tz       as system_modstamp
  , a.json:COMPANY_OR_ACCOUNT::text(1600)      as company_or_account
  , a.json:CITY::text(1000)                    as city
  , a.json:LAST_MODIFIED_DATE::timestamp_tz    as last_modified_date
  , a.json:POSTAL_CODE::text(900)              as postal_code
  , a.json:DO_NOT_CALL::boolean                as do_not_call
  , a.json:CREATED_DATE::timestamp_tz          as created_date
  , a.json:NAME::text(1600)                    as name
  , a.json:HAS_RESPONDED::boolean              as has_responded
  , a.json:LEAD_OR_CONTACT_ID::text(900)       as lead_or_contact_id
  , a.json:STATE::text(1100)                   as state
  , a.json:CONTACT_ID::text(900)               as contact_id
  , a.json:LAST_MODIFIED_BY_ID::text(900)      as last_modified_by_id
  , a.json:CREATED_BY_ID::text(900)            as created_by_id
  , a.json:MOBILE_PHONE::text(1000)            as mobile_phone
  , a.json:LEAD_OR_CONTACT_OWNER_ID::text(900) as lead_or_contact_owner_id
  , a.json:STATUS::text(1000)                  as status
  , a.json:LEAD_SOURCE::text(1600)             as lead_source
  , a.json:CAMPAIGN_ID::text(900)              as campaign_id
  , a.json:COUNTRY::text(1100)                 as country
  , a.json:DESCRIPTION::text(96800)            as description
  , a.json:LAST_NAME::text(1100)               as last_name
  , a.json:FIRST_RESPONDED_DATE::date          as first_responded_date
  , a.json:_FIVETRAN_SYNCED::timestamp_tz      as _fivetran_synced
  , a.json:STREET::text(1600)                  as street
  , a.json:HAS_OPTED_OUT_OF_FAX::boolean       as has_opted_out_of_fax
  , a.json:ID::text(900)                       as id
  , a.json:_FIVETRAN_DELETED::boolean          as _fivetran_deleted
  , a.json:PHONE::text(1000)                   as phone
  , a.json:SALUTATION::text(1600)              as salutation
  , a.json:EMAIL::text(1100)                   as email
  , a.effective_at::timestamp                  as effective_at
  , a._created_at::timestamp                   as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'campaign_member'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end       as is_latest
from {{ source('salesforce_mps', 'campaign_member') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'campaign_member') }}
    group by 1, 2
)                                                      b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
