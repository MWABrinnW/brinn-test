select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:PARENT_ID::varchar(18)                             as parent_id
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:FIELD::varchar(765)                                as field
    , json:DATA_TYPE::varchar(120)                            as data_type
    , json:OLD_VALUE::varchar(765)                            as old_value
    , json:NEW_VALUE::varchar(765)                            as new_value
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'mhacquisition_history')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'mhacquisition_history') }}
