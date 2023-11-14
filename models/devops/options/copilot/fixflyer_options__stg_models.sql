select
    a.json:modelId::int                             as model_id
  , a.json:custId::int                              as cust_id
  , a.json:name::text(200)                          as model_name
  , try_to_boolean(a.json:masterModel::text)::int   as is_master_model
  , a.json:percentOrShares::double                  as percent_or_shares
  , a.json:percent::double                          as percent
  , a.json:assetType::text(200)                     as asset_type
  , c.value:modelId::int                            as contents_model_id
  , c.value:securityId::text(200)                   as security_id
  , c.value:percent::double                         as contents_percent
  , c.value:sharePercent::double                    as share_percent
  , c.value:quantity::double                        as quantity
  , c.value:price::double                           as price
  , c.value:value::double                           as value
  , c.value:product::int                            as product
  , c.value:cusip::text(200)                        as cusip
  , try_to_boolean(c.value:updated::text)::int      as is_updated
  , c.value:lastModified::TIMESTAMP_NTZ             as last_modified_at
  , case
    when a._created_at || a._uri in
      (select max(_created_at || _uri) from {{ source('copilot', 'models') }} group by _uri)
    then 1
    else 0
    end::int                                        as is_head
  , case when a._created_at = b.max_created_at then 1 else 0 end::int as is_head_for_day
  , dt.prior_market_date                            as effective_date
  , a._created_at                                   as _created_at
  , a._source_file                                  as _source_file
  , a._uri                                          as _uri
  , {{ parse_flyer_env(col='a._uri') }}
from {{ source('copilot', 'models') }}                 a
     left join (
                   select
                     _uri
                     , _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'models') }}
                   group by 1, 2
               )                                          b
     on a._created_at::date = b._created_date::date
         and a._created_at = b.max_created_at
         and a._uri = b._uri
    left join {{ ref('dates' )}} dt
      on a._created_at::date = dt.date_key
   , lateral flatten(input => a.json, path => 'contents') c
where 1=1
