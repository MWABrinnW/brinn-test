select
    m.json:modelId::int                             as model_id
  , m.json:custId::int                              as cust_id
  , m.json:name::text(200)                          as model_name
  , try_to_boolean(m.json:masterModel::text)::int   as is_master_model
  , m.json:percentOrShares::double                  as percent_or_shares
  , m.json:percent::double                          as percent
  , m.json:assetType::text(200)                     as asset_type
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
  , {{ col_is_head(reference=source('copilot', 'models'), source_date_col='m._created_at', reference_date_col='_created_at') }}
  , case when m._created_at = b.max_created_at then 1 else 0 end as is_latest
  , m._created_at                                   as _created_at
  , m._source_file                                  as _source_file
  , m._uri                                          as _uri
from {{ source('copilot', 'models') }}                 m
     left join (
                   select
                       _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'models') }}
                   group by 1
               )                                          b
     on m._created_at::date = b._created_date::date
         and m._created_at = b.max_created_at
   , lateral flatten(input => m.json, path => 'contents') c
