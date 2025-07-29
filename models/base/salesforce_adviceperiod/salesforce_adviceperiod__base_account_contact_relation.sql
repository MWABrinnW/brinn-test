select
    'salesforce'::text(200)                               as system_name
  , 'adviceperiod'::text(200)                             as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:ID:: varchar(18)                               as id
  , a.json:ACCOUNT_ID:: varchar(18)                       as account_id
  , a.json:CONTACT_ID:: varchar(18)                       as contact_id
  , a.json:ROLES:: varchar(4099)                          as roles
  , a.json:IS_DIRECT:: boolean                            as is_direct
  , a.json:IS_ACTIVE:: boolean                            as is_active
  , a.json:START_DATE:: date                              as start_date
  , a.json:END_DATE:: date                                as end_date
  , a.json:IS_DELETED:: boolean                           as is_deleted
  , a.json:CREATED_DATE:: timestamp_tz(9)                 as created_date
  , a.json:CREATED_BY_ID:: varchar(18)                    as created_by_id
  , a.json:LAST_MODIFIED_DATE:: timestamp_tz(9)           as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: varchar(18)              as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: timestamp_tz(9)              as system_modstamp
  , a.json:FULL_NAME_C:: varchar(3900)                    as full_name_c
  , a.json:_FIVETRAN_SYNCED:: timestamp_tz(9)             as _fivetran_synced
  , a.json:_FIVETRAN_DELETED:: boolean                    as _fivetran_deleted

  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(reference=source('salesforce_adviceperiod', 'account_contact_relation'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_adviceperiod', 'account_contact_relation') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_adviceperiod', 'account_contact_relation') }}
    group by 1, 2
)                                                                        b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at