{{ config(
  grants = {'select': ['engineering']}
) }}

select
    json:ID::text                                                                      as id
    , json:CREATED_BY_ID::text                                                         as created_by_id
    , to_timestamp_tz(json:CREATED_DATE::text , 'yyyy-mm-dd hh24:mi:ss.ff3 "Z"')       as created_date
    , try_to_boolean(json:IS_DELETED::text)::int                                       as is_deleted
    , json:LAST_MODIFIED_BY_ID::text                                                   as last_modified_by_id
    , to_timestamp_tz(json:LAST_MODIFIED_DATE::text , 'yyyy-mm-dd hh24:mi:ss.ff3 "Z"') as last_modified_date
    , json:NAME::text                                                                  as name
    , json:OWNER_ID::text                                                              as owner_id
    , json:PAYOUT_FIXED_RATE_C::float                                                  as payout_fixed_rate_c
    , json:PAYOUT_TIER_1_RATE_C::float                                                 as payout_tier_1_rate_c
    , json:PAYOUT_TIER_1_THRESHOLD_C::float                                            as payout_tier_1_threshold_c
    , json:PAYOUT_TIER_2_RATE_C::float                                                 as payout_tier_2_rate_c
    , json:PAYOUT_TIER_2_THRESHOLD_C::float                                            as payout_tier_2_threshold_c
    , json:PAYOUT_TIER_3_RATE_C::float                                                 as payout_tier_3_rate_c
    , json:PAYOUT_TIER_3_THRESHOLD_C::float                                            as payout_tier_3_threshold_c
    , json:PAYOUT_TIER_4_RATE_C::float                                                 as payout_tier_4_rate_c
    , json:PAYOUT_TIER_4_THRESHOLD_C::float                                            as payout_tier_4_threshold_c
    , try_to_boolean(json:PAYOUT_TIERED_C::text)::int                                  as payout_tiered_c
    , json:SYS_UNIQUE_RATE_C::text                                                     as sys_unique_rate_c
    , to_timestamp_tz(json:SYSTEM_MODSTAMP::text , 'yyyy-mm-dd hh24:mi:ss.ff3 "Z"')    as system_mod_stamp
    , try_to_boolean(json:_FIVETRAN_DELETED::text)::int                                as five_tran_deleted
    , to_timestamp_tz(json:_FIVETRAN_SYNCED::text , 'yyyy-mm-dd hh24:mi:ss.ff3 "Z"')   as five_tran_synced

    , effective_at::timestamp                                                          as effective_at
    , _created_at::timestamp                                                           as _created_at
from {{ source('salesforce_compass', 'payout_rate_c') }}
