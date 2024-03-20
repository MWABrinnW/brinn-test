select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:INSERTED_BY_ID::text(900)                      as inserted_by_id
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:TITLE::text(1600)                              as title
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:LIKE_COUNT::number(38, 0)                      as like_count
  , a.json:BODY::text(30800)                              as body
  , a.json:COMMENT_COUNT::number(38, 0)                   as comment_count
  , a.json:RELATED_RECORD_ID::text(900)                   as related_record_id
  , a.json:LINK_URL::text(3800)                           as link_url
  , a.json:ID::text(900)                                  as id
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:PARENT_ID::text(900)                           as parent_id
  , a.json:TYPE::text(1000)                               as type
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:IS_RICH_TEXT::boolean                          as is_rich_text
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:BEST_COMMENT_ID::text(900)                     as best_comment_id
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'asset_feed'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'asset_feed') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'asset_feed') }}
    group by 1, 2
)                                                 b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
