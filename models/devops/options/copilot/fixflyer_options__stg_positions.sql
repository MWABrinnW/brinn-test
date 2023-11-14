select
    a.json:accountId::int                                                                as account_id
  , a.json:positionId::int                                                               as position_id
  , a.json:securityId::text(200)                                                         as security_id
  , a.json:marketValue::number(19, 6)                                                    as market_value
  , a.json:quantity::number(19, 6)                                                       as quantity
  , a.json:price::number(19, 6)                                                          as price
  , a.json:currentPrice::number(19, 6)                                                   as current_price
  , a.json:averagePrice::number(19, 6)                                                   as average_price
  , a.json:currentFxRate::number(19, 6)                                                  as current_fx_rate
  , a.json:custId::int                                                                   as cust_id
  , a.json:custodian::text(200)                                                          as custodian
  , a.json:dayPnL::number(19, 6)                                                         as day_pnl
  , a.json:groupId::text(200)                                                            as group_id
  , a.json:industry::text(200)                                                           as industry
  , a.json:issue::text(200)                                                              as issue
  , to_timestamp(a.json:lastModified::varchar(100), 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM') as last_modified_at
  , a.json:accountPercent::number(19, 6)                                                 as account_percent
  , a.json:parentGroupId::int                                                            as parent_group_id
  , a.json:previousClose::number(19, 6)                                                  as previous_close
  , a.json:product::text(200)                                                            as product
  , a.json:realizedPnL::number(19, 6)                                                    as realized_pnl
  , a.json:sector::text(200)                                                             as sector
  , a.json:sleeveId::text(200)                                                           as sleeve_id
  , a.json:sleevePercent::number(19, 6)                                                  as sleeve_percent
  , a.json:sleeveType::text(200)                                                         as sleeve_type
  , a.json:totalPnL::number(19, 6)                                                       as total_pnl
  , a.json:unrealizedPnL::number(19, 6)                                                  as unrealized_pnl
  , try_to_boolean(a.json:unsupervised::text)::int                                       as is_unsupervised
  , a.json:amount::number(19, 6)                                                         as amount
  , a.json:secIdSrc::text(200)                                                           as sec_id_src
  , case
    when a._created_at || a._uri in
      (select max(_created_at || _uri) from {{ source('copilot', 'positions') }} group by _uri)
    then 1
    else 0
    end::int                                                                             as is_head
  , case when b.account_id is not null then 1 else 0 end::int                            as is_head_for_day
  , dt.prior_market_date                                                                 as effective_date
  , a._created_at                                                                        as _created_at
  , a._source_file                                                                       as _source_file
  , a._uri                                                                               as _uri
  , {{ parse_flyer_env(col='a._uri') }}
from {{ source('copilot', 'positions') }}                         a
     left join (
                   select
                       _uri
                     , json:accountId::int  as account_id
                     , _created_at::date    as _created_date
                     , max(_created_at)     as max_created_at
                   from {{ source('copilot', 'positions') }}
                   group by 1,2,3
               )                                                  b
     on a._created_at::date = b._created_date::date
         and a._created_at::timestamp = b.max_created_at::timestamp
         and a.json:accountId::int = b.account_id
         and a._uri = b._uri
    left join {{ ref('dates' )}} dt
      on a._created_at::date = dt.date_key
where 1=1
order by a._created_at, a.json:accountId::int, a.json:positionId::int
