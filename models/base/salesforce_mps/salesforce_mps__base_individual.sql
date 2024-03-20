select
    'salesforce'::text(200)                                as system_name
  , 'baystate'::text(200)                                  as system_instance
  , concat(system_name, '__', system_instance)::text(200)  as system_key
  , 'mps'::text(200)                                       as firm_source
  , a.json:MASTER_RECORD_ID::text(900)                     as master_record_id
  , a.json:ID::text(900)                                   as id
  , a.json:HAS_OPTED_OUT_PROCESSING::boolean               as has_opted_out_processing
  , a.json:IS_DELETED::boolean                             as is_deleted
  , a.json:IS_HOME_OWNER::boolean                          as is_home_owner
  , a.json:INDIVIDUALS_AGE::text(1600)                     as individuals_age
  , a.json:BIRTH_DATE::date                                as birth_date
  , a.json:CREATED_DATE::timestamp_tz                      as created_date
  , a.json:WEBSITE::text(1600)                             as website
  , a.json:CREATED_BY_ID::text(900)                        as created_by_id
  , a.json:SHOULD_FORGET::boolean                          as should_forget
  , a.json:CONSUMER_CREDIT_SCORE::number(38, 0)            as consumer_credit_score
  , a.json:HAS_OPTED_OUT_SOLICIT::boolean                  as has_opted_out_solicit
  , a.json:LAST_NAME::text(1100)                           as last_name
  , a.json:CONSUMER_CREDIT_SCORE_PROVIDER_NAME::text(1600) as consumer_credit_score_provider_name
  , a.json:HAS_OPTED_OUT_TRACKING::boolean                 as has_opted_out_tracking
  , a.json:CAN_STORE_PII_ELSEWHERE::boolean                as can_store_pii_elsewhere
  , a.json:DEATH_DATE::date                                as death_date
  , a.json:SEND_INDIVIDUAL_DATA::boolean                   as send_individual_data
  , a.json:FIRST_NAME::text(1000)                          as first_name
  , a.json:CHILDREN_COUNT::number(38, 0)                   as children_count
  , a.json:_FIVETRAN_DELETED::boolean                      as _fivetran_deleted
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                   as system_modstamp
  , a.json:INFLUENCER_RATING::number(38, 0)                as influencer_rating
  , a.json:MILITARY_SERVICE::text(1600)                    as military_service
  , a.json:LAST_MODIFIED_DATE::timestamp_tz                as last_modified_date
  , a.json:OCCUPATION::text(1300)                          as occupation
  , a.json:HAS_OPTED_OUT_GEO_TRACKING::boolean             as has_opted_out_geo_tracking
  , a.json:LAST_MODIFIED_BY_ID::text(900)                  as last_modified_by_id
  , a.json:HAS_OPTED_OUT_PROFILING::boolean                as has_opted_out_profiling
  , a.json:OWNER_ID::text(900)                             as owner_id
  , a.json:SALUTATION::text(1000)                          as salutation
  , a.json:NAME::text(1200)                                as name
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                  as _fivetran_synced
  , a.json:LAST_VIEWED_DATE::timestamp_tz                  as last_viewed_date
  , a.json:CONVICTIONS_COUNT::number(38, 0)                as convictions_count
  , a.effective_at::timestamp                              as effective_at
  , a._created_at::timestamp                               as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'individual'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                   as is_latest
from {{ source('salesforce_mps', 'individual') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'individual') }}
    group by 1, 2
)                                                 b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
