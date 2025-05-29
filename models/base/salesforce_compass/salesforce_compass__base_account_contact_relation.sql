select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:ACCOUNT_ID::varchar(18)                          as account_id
    , a.json:CONTACT_ID::varchar(18)                          as contact_id
    , a.json:ROLES::varchar(4099)                             as roles
    , a.json:IS_DIRECT::boolean                               as is_direct
    , a.json:IS_ACTIVE::boolean                               as is_active
    , a.json:START_DATE::date                                 as start_date
    , a.json:END_DATE::date                                   as end_date
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:SORT_ORDER_C::double                             as sort_order_c
    , a.json:STATEMENT_MAILING_PREFERENCE_C::varchar(765)     as statement_mailing_preference_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'account_contact_relation'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_head_for_day
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_latest
    , case
        when a._created_at = min(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_earliest
from {{ source('salesforce_compass', 'account_contact_relation') }} as a
