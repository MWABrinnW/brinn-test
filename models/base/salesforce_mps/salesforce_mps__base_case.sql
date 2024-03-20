select
    a.json:LAST_MODIFIED_DATE::timestamp_tz   as last_modified_date
  , a.json:OWNER_ID::text(900)                as owner_id
  , a.json:DESCRIPTION::text(96800)           as description
  , a.json:IS_ESCALATED::boolean              as is_escalated
  , a.json:ACCOUNT_ID::text(900)              as account_id
  , a.json:ORIGIN::text(1600)                 as origin
  , a.json:SUPPLIED_PHONE::text(1000)         as supplied_phone
  , a.json:SUPPLIED_EMAIL::text(1100)         as supplied_email
  , a.json:LAST_MODIFIED_BY_ID::text(900)     as last_modified_by_id
  , a.json:CLOSED_DATE::timestamp_tz          as closed_date
  , a.json:PARENT_ID::text(900)               as parent_id
  , a.json:PRIORITY::text(1600)               as priority
  , a.json:CREATED_BY_ID::text(900)           as created_by_id
  , a.json:IS_DELETED::boolean                as is_deleted
  , a.json:LAST_REFERENCED_DATE::timestamp_tz as last_referenced_date
  , a.json:REASON::text(1600)                 as reason
  , a.json:_FIVETRAN_SYNCED::timestamp_tz     as _fivetran_synced
  , a.json:SUPPLIED_NAME::text(1100)          as supplied_name
  , a.json:CONTACT_PHONE::text(1000)          as contact_phone
  , a.json:LAST_VIEWED_DATE::timestamp_tz     as last_viewed_date
  , a.json:_FIVETRAN_DELETED::boolean         as _fivetran_deleted
  , a.json:TYPE::text(1600)                   as type
  , a.json:SUPPLIED_COMPANY::text(1100)       as supplied_company
  , a.json:CASE_NUMBER::text(900)             as case_number
  , a.json:CONTACT_FAX::text(1000)            as contact_fax
  , a.json:CONTACT_MOBILE::text(1000)         as contact_mobile
  , a.json:CONTACT_EMAIL::text(1100)          as contact_email
  , a.json:STATUS::text(1600)                 as status
  , a.json:SUBJECT::text(1600)                as subject
  , a.json:CREATED_DATE::timestamp_tz         as created_date
  , a.json:IS_CLOSED::boolean                 as is_closed
  , a.json:ID::text(900)                      as id
  , a.json:SYSTEM_MODSTAMP::timestamp_tz      as system_modstamp
  , a.json:COMMENTS::text(4800)               as comments
  , a.json:MASTER_RECORD_ID::text(900)        as master_record_id
  , a.json:CONTACT_ID::text(900)              as contact_id
  , a.effective_at::timestamp                 as effective_at
  , a._created_at::timestamp                  as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'case'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end      as is_latest
from {{ source('salesforce_mps', 'case') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'case') }}
    group by 1, 2
)                                           b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
