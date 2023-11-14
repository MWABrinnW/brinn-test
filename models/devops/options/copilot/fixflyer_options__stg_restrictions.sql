select
    to_date(a.json:restrictionStartDate::text(200), 'YYYYMMDD')                as restriction_start_date
  , case
        when a.json:restrictionEndDate != ''
            then to_date(a.json:restrictionEndDate::text(200), 'YYYYMMDD') end as restriction_end_date
  , try_to_boolean(a.json:enabled::text)::int                                  as is_enabled
  , a.json:restrictionId::text(200)                                            as restriction_id
  , a.json:accountId::text(200)                                                as account_id
  , a.json:custId::text(200)                                                   as cust_id
  , a.json:userId::text(200)                                                   as user_id
  , a.json:restrictionType::text(200)                                          as restriction_type
  , a.json:extRestriction::text(200)                                           as external_restriction
  , a.json:restrictionMapping::text(200)                                       as restriction_mapping
  , a.json:securityId::text(200)                                               as security_id
  , a.json:cusip::text(200)                                                    as cusip
  , a.json:product::text(200)                                                  as product
  , a.json:notes::text(200)                                                    as notes
  , to_timestamp_tz(a.json:lastModified::text(200),
                    'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM')                         as last_modified_at
  , case
    when a._created_at || a._uri in
      (select max(_created_at || _uri) from {{ source('copilot', 'restrictions') }} group by _uri)
    then 1
    else 0
    end::int                                                                   as is_head
  , case when a._created_at = b.max_created_at then 1 else 0 end::int          as is_head_for_day
  , dt.prior_market_date                                                       as effective_date
  , a._created_at                                                              as _created_at
  , a._source_file                                                             as _source_file
  , a._uri                                                                     as _uri
  , {{ parse_flyer_env(col='a._uri') }}
from {{ source('copilot', 'restrictions') }}              a
     left join (
                   select
                     _uri
                     , _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'restrictions') }}
                   group by 1, 2
               )                                          b
     on a._created_at::date = b._created_date::date
         and a._created_at = b.max_created_at
         and a._uri = b._uri
    left join {{ ref('dates' )}} dt
      on a._created_at::date = dt.date_key
where 1=1
