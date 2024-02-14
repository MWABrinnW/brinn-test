
select
    pkaccount
  , acctstatus
  , acctsource
  , fundname
  , custodian
  , pkproduct
  , productname
  , ticker
  , effectivedate::date              as effectivedate
  , calculatedvalue::number(19, 6)   as calculatedvalue
  , fileassetvalue::number(19, 6)    as fileassetvalue
  , valuediff::number(19, 6)         as valuediff
  , systemunitbalance::number(19, 6) as systemunitbalance
  , fileunitbalance::number(19, 6)   as fileunitbalance
  , unitdiff::number(19, 6)          as unitdiff
  , systemprice::number(19, 6)       as systemprice
  , fileprice::number(19, 6)         as fileprice
  , reg_name
  , client_id
  , reg_id
  , pkasset
  , producttype
  , acctcode
  , downloaddesc
  , record_datetime::timestamp       as record_datetime
  , record_date::date                as record_date
from {{ source('moxy', 'asset_custodial_comparison_2') }}
where record_datetime = (select max(record_datetime) from {{ source('moxy', 'asset_custodial_comparison_2') }})
