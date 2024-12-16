with cte_max_per_day as (
    select
        _uri
        , _created_at::date as _created_date
        , {{ parse_copilot_env(col='_uri') }}
        , max(_created_at)  as _max_created_at_for_day
    from {{ source('flyer', 'models') }}
    where _env = {{ "'" ~ copilot_env() ~ "'" }}
    group by all
)

, cte_max as (
    select
        _uri
        , max(_max_created_at_for_day) as _max_created_at
    from cte_max_per_day
    group by _uri
)

select
     'copilot'::text as system_name
    , 'mwa-options' as system_instance
    , system_name || '__' || system_instance as system_key
    , a.json:modelId::int                           as model_id
    , a.json:custId::int                            as cust_id
    , a.json:name::text(200)                        as model_name
    , try_to_boolean(a.json:masterModel::text)::int as is_master_model
    , a.json:percentOrShares::double                as percent_or_shares
    , a.json:percent::double                        as percent
    , a.json:assetType::text(200)                   as asset_type
    , c.value:modelId::int                          as contents_model_id
    , c.value:securityId::text(200)                 as security_id
    , c.value:percent::double                       as contents_percent
    , c.value:sharePercent::double                  as share_percent
    , c.value:quantity::double                      as quantity
    , c.value:price::double                         as price
    , c.value:value::double                         as value
    , c.value:product::int                          as product
    , c.value:cusip::text(200)                      as cusip
    , try_to_boolean(c.value:updated::text)::int    as is_updated
    , c.value:lastModified::timestamp_ntz           as last_modified_at
    , case
        when mx._max_created_at is not null
            then 1
        else 0
    end::int                                        as is_head
    , case
        when a._created_at = mxpd._max_created_at_for_day
            then 1
        else 0
    end::int                                        as is_head_for_day
    , dt.prior_market_date                          as effective_date
    , a._created_at                                 as _created_at
    , a._source_file                                as _source_file
    , a._uri                                        as _uri
    , {{ parse_copilot_env(col='a._uri') }}
from {{ source('flyer', 'models') }} as a
left join cte_max as mx
    on a._uri = mx._uri
    and a._created_at = mx._max_created_at
left join cte_max_per_day as mxpd
    on a._uri = mxpd._uri
    and a._created_at::date = mxpd._created_date
left join {{ ref('dates' ) }} as dt
    on a._created_at::date = dt.date_key
, lateral flatten(input => a.json , path => 'contents') as c
where 1 = 1
    and _env = {{ "'" ~ copilot_env() ~ "'" }}
