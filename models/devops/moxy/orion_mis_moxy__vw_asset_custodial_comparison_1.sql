
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
--   , case when record_datetime::timestamp = (select max(record_datetime::timestamp)) from {{ source('orion_mis_moxy', 'asset_custodial_comparison_1') }}) 
--         then 1 else 0 end as is_current
  , record_datetime::timestamp       as record_datetime
  , record_date::date                as record_date
from {{ source('orion_mis_moxy', 'asset_custodial_comparison_1') }}
where record_datetime = (select max(record_datetime) from {{ source('orion_mis_moxy', 'asset_custodial_comparison_1') }})
