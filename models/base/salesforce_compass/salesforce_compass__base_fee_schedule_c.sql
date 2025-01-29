select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:OWNER_ID::varchar(18)                            as owner_id
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:NAME::varchar(240)                               as name
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:LAST_VIEWED_DATE::timestamptz                    as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                as last_referenced_date
    , a.json:BASIS_C::varchar(765)                            as basis_c
    , a.json:FEE_RATE_10_C::double                            as fee_rate_10_c
    , a.json:FEE_RATE_11_C::double                            as fee_rate_11_c
    , a.json:FEE_RATE_1_C::double                             as fee_rate_1_c
    , a.json:FEE_RATE_2_C::double                             as fee_rate_2_c
    , a.json:FEE_RATE_3_C::double                             as fee_rate_3_c
    , a.json:FEE_RATE_4_C::double                             as fee_rate_4_c
    , a.json:FEE_RATE_5_C::double                             as fee_rate_5_c
    , a.json:FEE_RATE_6_C::double                             as fee_rate_6_c
    , a.json:FEE_RATE_7_C::double                             as fee_rate_7_c
    , a.json:FEE_RATE_8_C::double                             as fee_rate_8_c
    , a.json:FEE_RATE_9_C::double                             as fee_rate_9_c
    , a.json:FEE_SCHEDULE_EXPIRATION_DATE_C::timestamptz      as fee_schedule_expiration_date_c
    , a.json:FEE_TYPE_C::varchar(765)                         as fee_type_c
    , a.json:LEVEL_10_C::number(18)                           as level_10_c
    , a.json:LEVEL_11_C::number(18)                           as level_11_c
    , a.json:LEVEL_1_C::number(18)                            as level_1_c
    , a.json:LEVEL_2_C::number(18)                            as level_2_c
    , a.json:LEVEL_3_C::number(18)                            as level_3_c
    , a.json:LEVEL_4_C::number(18)                            as level_4_c
    , a.json:LEVEL_5_C::number(18)                            as level_5_c
    , a.json:LEVEL_6_C::number(18)                            as level_6_c
    , a.json:LEVEL_7_C::number(18)                            as level_7_c
    , a.json:LEVEL_8_C::number(18)                            as level_8_c
    , a.json:LEVEL_9_C::number(18)                            as level_9_c
    , a.json:MINIMUM_ANNUAL_FEE_C::number(18 , 2)             as minimum_annual_fee_c
    , a.json:NUMBER_OF_LEVELS_C::double                       as number_of_levels_c
    , a.json:FIRMS_USING_THIS_FEE_SCHEDULE_C::varchar(4099)   as firms_using_this_fee_schedule_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:MAXIMUM_LEVEL_C::number(18 , 2)                  as maximum_level_c
    , a.json:DATE_REVIEWED_BY_OPS_C::date                     as date_reviewed_by_ops_c
    , a.json:REVIEWED_BY_C::varchar(18)                       as reviewed_by_c
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'fee_schedule_c'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case when b.rn_latest = 1 then 1 else 0 end             as is_latest
    , case when b.rn_earliest = 1 then 1 else 0 end           as is_earliest
from {{ source('salesforce_compass', 'fee_schedule_c') }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn_latest
        , row_number() over (partition by a.effective_at::date order by a._created_at asc)  as rn_earliest
    from {{ source('salesforce_compass', 'fee_schedule_c') }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
