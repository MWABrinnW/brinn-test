with cte_max as (
    select
        _uri
        , json:accountId::int                                            as account_id
        , _created_at::date                                              as _created_date
        , {{ parse_flyer_env(col='_uri') }}
        , max(_created_at::date) over (partition by json:accountId::int) as account_max_date
        , max(_created_at)                                               as account_max_created_at
        , max(_created_at::date) over (partition by _uri)                as max_created_date
    from {{ source('flyer', 'positions') }}
    where _env = {{ "'" ~ flyer_env() ~ "'" }}
    group by 1 , 2 , 3
)

select
     'copilot'::text(200)                            as platform
    , 'mwa-options'::text(200)                       as venue
    , a.json:accountId::int                          as account_id
    , a.json:positionId::int                         as position_id
    , a.json:securityId::text(200)                   as security_id
    , a.json:marketValue::number(19 , 6)             as market_value
    , a.json:quantity::number(19 , 6)                as quantity
    , a.json:price::number(19 , 6)                   as price
    , a.json:currentPrice::number(19 , 6)            as current_price
    , a.json:averagePrice::number(19 , 6)            as average_price
    , a.json:currentFxRate::number(19 , 6)           as current_fx_rate
    , a.json:custId::int                             as cust_id
    , a.json:custodian::text(200)                    as custodian
    , a.json:dayPnL::number(19 , 6)                  as day_pnl
    , a.json:groupId::text(200)                      as group_id
    , a.json:industry::text(200)                     as industry
    , a.json:issue::text(200)                        as issue
    , to_timestamp(
        a.json:lastModified::varchar(100)
        , 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM'
    )                                                as last_modified_at
    , a.json:accountPercent::number(19 , 6)          as account_percent
    , a.json:parentGroupId::int                      as parent_group_id
    , a.json:previousClose::number(19 , 6)           as previous_close
    , a.json:product::text(200)                      as product
    , {{ copilot_product_id_to_type('a.json:product::int') }}
    , a.json:realizedPnL::number(19 , 6)             as realized_pnl
    , a.json:sector::text(200)                       as sector
    , a.json:sleeveId::text(200)                     as sleeve_id
    , a.json:sleevePercent::number(19 , 6)           as sleeve_percent
    , a.json:sleeveType::text(200)                   as sleeve_type
    , a.json:totalPnL::number(19 , 6)                as total_pnl
    , a.json:unrealizedPnL::number(19 , 6)           as unrealized_pnl
    , try_to_boolean(a.json:unsupervised::text)::int as is_unsupervised
    , a.json:amount::number(19 , 6)                  as amount
    , a.json:secIdSrc::text(200)                     as sec_id_src

    , case
        when product = 5
            then regexp_substr(
                a.json:securityId::text(200), '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 1
            )
            else null
            end::text(200)                           as option_ticker
    , case
        when product = 5
            then try_to_date(regexp_substr(
                a.json:securityId::text(200), '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 2
            ), 'YYMMDD')
            else null
            end::date                                as option_ex_date
    , case
        when product = 5
            then regexp_substr(
                    a.json:securityId::text(200), '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 3
                )
            else null
            end::text(200)                           as option_type
    , case
        when product = 5
            then (regexp_substr(
                a.json:securityId::text(200), '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 4
            )::int / 1000)
            else null
            end::decimal(20 , 2)                     as option_strike_price
    , option_ticker
        || ' '
        || to_char(option_ex_date, 'YYMMDD')
        || option_type
        || lpad(to_char((option_strike_price * 1000)::int), 8, '0')
        ::text(200)                                  as option_symbol

    , case
        when a._created_at = b.account_max_created_at and a._created_at::date = b.max_created_date
            then 1
        else 0
    end::int                                         as is_head
    , case
        when a._created_at = b.account_max_created_at
            then 1
        else 0
    end::int                                         as is_head_for_day
    , dt.prior_market_date                           as effective_date
    , a._created_at                                  as _created_at
    , a._source_file                                 as _source_file
    , a._uri                                         as _uri
    , {{ parse_flyer_env(col='a._uri') }}
from {{ source('flyer', 'positions') }} as a
left join cte_max as b
    on a._created_at::date = b._created_date::date
    and a.json:accountId::int = b.account_id
    and a._uri = b._uri
left join {{ ref('dates' ) }} as dt
    on a._created_at::date = dt.date_key
where 1 = 1
    and _env = {{ "'" ~ flyer_env() ~ "'" }}
    and product_type = 'OPT'
    and _created_at::date = '2/26/2024'
order by a._created_at , a.json:accountId::int , a.json:positionId::int
