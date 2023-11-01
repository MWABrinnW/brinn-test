select
    to_date(r.json:restrictionStartDate::text(200), 'YYYYMMDD')                as restriction_start_date
  , case
        when r.json:restrictionEndDate != ''
            then to_date(r.json:restrictionEndDate::text(200), 'YYYYMMDD') end as restriction_end_date
  , try_to_boolean(r.json:enabled::text)::int                                  as is_enabled
  , r.json:restrictionId::text(200)                                            as restriction_id
  , r.json:accountId::text(200)                                                as account_id
  , r.json:custId::text(200)                                                   as custid
  , r.json:userId::text(200)                                                   as userid
  , r.json:restrictionType::text(200)                                          as restriction_type
  , r.json:securityId::text(200)                                               as security_id
  , r.json:cusip::text(200)                                                    as cusip
  , r.json:product::text(200)                                                  as product
  , r.json:notes::text(200)                                                    as notes
  , to_timestamp_tz(r.json:lastModified::text(200),
                    'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM')                         as last_modified_at
  , {{ col_is_head(reference=source('copilot', 'restrictions'), source_date_col='r._created_at', reference_date_col='_created_at') }}
  , case when r._created_at = b.max_created_at then 1 else 0 end               as is_latest
  , dt.prior_market_date                                                       as effective_date
  , r._created_at                                                              as _created_at
  , r._source_file                                                             as _source_file
  , r._uri                                                                     as _uri
from {{ source('copilot', 'restrictions') }}              r
     left join (
                   select
                       _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'restrictions') }}
                   group by 1
               )                                          b
     on r._created_at::date = b._created_date::date
         and r._created_at = b.max_created_at
    left join {{ ref('dates' )}} dt
      on r._created_at::date = dt.date_key
where 1=1
