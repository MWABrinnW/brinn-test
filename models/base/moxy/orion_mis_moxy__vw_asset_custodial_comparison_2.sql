
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
--   , case when record_datetime::timestamp = (select max(record_datetime::timestamp)) from {{ source('orion_mis_moxy', 'asset_custodial_comparison_2') }}) 
--         then 1 else 0 end as is_current
  , record_datetime::timestamp       as record_datetime
  , record_date::date                as record_date
from {{ source('orion_mis_moxy', 'asset_custodial_comparison_2') }}
where record_datetime = (select max(record_datetime) from {{ source('orion_mis_moxy', 'asset_custodial_comparison_2') }})
