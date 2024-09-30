select
    'salesforce'::text(200)                               as system_name
  , 'compass'::text(200)                                  as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mwa'::text(200)                                      as firm_source
  , a.json:ID:: varchar(18)                               as id
  , a.json:IS_DELETED:: boolean                           as is_deleted
  , a.json:NAME:: varchar(240)                            as name
  , a.json:CREATED_DATE:: timestamptz                     as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                    as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamptz               as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)              as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamptz                  as system_modstamp
  , a.json:MME_CONTACT_C:: varchar(18)                    as mme_contact_c
  , a.json:MME_EMAIL_C:: varchar(240)                     as mme_email_c
  , a.json:_FIVETRAN_SYNCED:: timestamptz                 as _fivetran_synced

  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'mme_contact_email_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_compass', 'mme_contact_email_c') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_compass', 'mme_contact_email_c') }}
    group by 1, 2
)                                                              b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at