select
    m.value:modelId::string             as modelid
  , m.value:custId::string              as custid
  , m.value:name::string                as name
  , m.value:masterModel::boolean        as mastermodel
  , m.value:percentOrShares::double     as percentorshares
  , m.value:percent::double             as percent
  , m.value:assetType::string           as assettype
  , c.value:modelId::string             as contents_modelid
  , c.value:securityId::string          as securityid
  , c.value:percent::double             as contents_percent
  , c.value:sharePercent::double        as sharepercent
  , c.value:quantity::double            as quantity
  , c.value:price::double               as price
  , c.value:value::double               as value
  , c.value:product::int                as product
  , c.value:cusip::string               as cusip
  , c.value:updated::boolean            as updated
  , c.value:lastModified::TIMESTAMP_NTZ as lastmodified
  , {{ col_is_head(reference=source('copilot', 'models_raw'), source_date_col='r.record_datetime', reference_date_col='record_datetime') }}
  , r.record_date                       as record_date
  , r.record_datetime                   as record_datetime
from {{ source('copilot', 'models_raw') }}                 r
   , lateral flatten(input => r.json, path => 'models')    m
   , lateral flatten(input => m.value, path => 'contents') c