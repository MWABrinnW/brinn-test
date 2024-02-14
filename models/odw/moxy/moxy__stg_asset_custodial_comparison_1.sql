
select
    pkaccount
  , acctstatus
  , acctsource
  , fund_name
  , custodianname
  , productid
  , productname
  , ticker
  , effectivedate::date              as effectivedate
  , systemvalue::number(19, 6)       as systemvalue
  , fileassetvalue::number(19, 6)    as fileassetvalue
  , valuedifference::number(19, 6)   as valuedifference
  , systemunitbalance::number(19, 6) as systemunitbalance
  , fileunitbalance::number(19, 6)   as fileunitbalance
  , unitdifference::number(19, 6)    as unitdifference
  , systemprice::number(19, 6)       as systemprice
  , fileprice::number(19, 6)         as fileprice
  , regname
  , pkclient
  , pkregistration
  , pkasset
  , producttype
  , acctcode
  , downloaddesc
  , record_datetime::timestamp       as record_datetime
  , record_date::date                as record_date
from {{ source('moxy', 'asset_custodial_comparison_1') }}
where record_datetime = (select max(record_datetime) from {{ source('moxy', 'asset_custodial_comparison_1') }})
