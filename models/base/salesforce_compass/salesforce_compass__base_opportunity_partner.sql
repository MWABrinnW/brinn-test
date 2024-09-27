select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OPPORTUNITY_ID::varchar(18)                        as opportunity_id
    , json:ACCOUNT_TO_ID::varchar(18)                         as account_to_id
    , json:ROLE::varchar(765)                                 as role
    , json:IS_PRIMARY::boolean                                as is_primary
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:IS_DELETED::boolean                                as is_deleted
    , json:REVERSE_PARTNER_ID::varchar(18)                    as reverse_partner_id
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'opportunity_partner')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'opportunity_partner') }}
