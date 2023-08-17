select
    p.json:accountId::int                                                                as account_id
  , p.json:positionId::int                                                               as position_id
  , p.json:securityId::text(200)                                                         as security_id
  , p.json:marketValue::number(19, 6)                                                    as market_value
  , p.json:quantity::number(19, 6)                                                       as quantity
  , p.json:price::number(19, 6)                                                          as price
  , p.json:currentPrice::number(19, 6)                                                   as current_price
  , p.json:averagePrice::number(19, 6)                                                   as average_price
  , p.json:currentFxRate::number(19, 6)                                                  as current_fx_rate
  , p.json:custId::int                                                                   as cust_id
  , p.json:custodian::text(200)                                                          as custodian
  , p.json:dayPnL::number(19, 6)                                                         as day_pnl
  , p.json:groupId::text(200)                                                            as group_id
  , p.json:industry::text(200)                                                           as industry
  , p.json:issue::text(200)                                                              as issue
  , to_timestamp(p.json:lastModified::varchar(100), 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM') as last_modified_at
  , p.json:accountPercent::number(19, 6)                                                 as account_percent
  , p.json:parentGroupId::int                                                            as parent_group_id
  , p.json:previousClose::number(19, 6)                                                  as previous_close
  , p.json:product::text(200)                                                            as product
  , p.json:realizedPnL::number(19, 6)                                                    as realized_pnl
  , p.json:sector::text(200)                                                             as sector
  , p.json:sleeveId::text(200)                                                           as sleeve_id
  , p.json:sleevePercent::number(19, 6)                                                  as sleeve_percent
  , p.json:sleeveType::text(200)                                                         as sleeve_type
  , p.json:totalPnL::number(19, 6)                                                       as total_pnl
  , p.json:unrealizedPnL::number(19, 6)                                                  as unrealized_pnl
  , try_to_boolean(p.json:unsupervised::text)::int                                       as is_unsupervised
  , p.json:amount::number(19, 6)                                                         as amount
  , p.json:secIdSrc::text(200)                                                           as sec_id_src
  , {{ col_is_head(reference=source('copilot', 'positions'), source_date_col='p._created_at::date', reference_date_col='_created_at::date') }}
  , case when b.account_id is not null then 1 else 0 end                                                 as is_latest
  , p._created_at                                                                        as _created_at
  , p._source_file                                                                       as _source_file
  , p._uri                                                                               as _uri
from {{ source('copilot', 'positions') }}                      p
     left join (
                   select
                       json:accountId::int  as account_id
                     , _created_at::date    as _created_date
                     , max(_created_at)     as max_created_at
                   from {{ source('copilot', 'positions') }}
                   group by 1,2
               )                                                  b
     on p._created_at::date = b._created_date::date
         and p._created_at::timestamp = b.max_created_at::timestamp
         and p.json:accountId::int = b.account_id
where 1=1
order by p._created_at, p.json:accountId::int, p.json:positionId::int
