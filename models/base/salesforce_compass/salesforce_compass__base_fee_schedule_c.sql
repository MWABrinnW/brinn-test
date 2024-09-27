select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::varchar(240)                                 as name
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:BASIS_C::varchar(765)                              as basis_c
    , json:FEE_RATE_10_C::double                              as fee_rate_10_c
    , json:FEE_RATE_11_C::double                              as fee_rate_11_c
    , json:FEE_RATE_1_C::double                               as fee_rate_1_c
    , json:FEE_RATE_2_C::double                               as fee_rate_2_c
    , json:FEE_RATE_3_C::double                               as fee_rate_3_c
    , json:FEE_RATE_4_C::double                               as fee_rate_4_c
    , json:FEE_RATE_5_C::double                               as fee_rate_5_c
    , json:FEE_RATE_6_C::double                               as fee_rate_6_c
    , json:FEE_RATE_7_C::double                               as fee_rate_7_c
    , json:FEE_RATE_8_C::double                               as fee_rate_8_c
    , json:FEE_RATE_9_C::double                               as fee_rate_9_c
    , json:FEE_SCHEDULE_EXPIRATION_DATE_C::timestamptz        as fee_schedule_expiration_date_c
    , json:FEE_TYPE_C::varchar(765)                           as fee_type_c
    , json:LEVEL_10_C::number(18)                             as level_10_c
    , json:LEVEL_11_C::number(18)                             as level_11_c
    , json:LEVEL_1_C::number(18)                              as level_1_c
    , json:LEVEL_2_C::number(18)                              as level_2_c
    , json:LEVEL_3_C::number(18)                              as level_3_c
    , json:LEVEL_4_C::number(18)                              as level_4_c
    , json:LEVEL_5_C::number(18)                              as level_5_c
    , json:LEVEL_6_C::number(18)                              as level_6_c
    , json:LEVEL_7_C::number(18)                              as level_7_c
    , json:LEVEL_8_C::number(18)                              as level_8_c
    , json:LEVEL_9_C::number(18)                              as level_9_c
    , json:MINIMUM_ANNUAL_FEE_C::number(18 , 2)               as minimum_annual_fee_c
    , json:NUMBER_OF_LEVELS_C::double                         as number_of_levels_c
    , json:FIRMS_USING_THIS_FEE_SCHEDULE_C::varchar(4099)     as firms_using_this_fee_schedule_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:MAXIMUM_LEVEL_C::number(18 , 2)                    as maximum_level_c
    , json:DATE_REVIEWED_BY_OPS_C::date                       as date_reviewed_by_ops_c
    , json:REVIEWED_BY_C::varchar(18)                         as reviewed_by_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'fee_schedule_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'fee_schedule_c') }}
