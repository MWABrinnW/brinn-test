select
    effective_date::date                             as effective_date
  , custodiancode::text(200)                         as custodiancode
  , account::text(200)                               as account
  , product::text(200)                               as product
  , symbol::text(200)                                as symbol
  , quantity::decimal(19, 6)                         as quantity
  , unitcost::decimal(19, 6)                         as unitcost
  , totalcost::decimal(19, 6)                        as totalcost
  , price::decimal(19, 6)                            as price
  , lotdate::date                                    as lotdate
  , lotnum::text(200)                                as lotnum
  , unsupervised::text(200)                          as unsupervised
  , cusiplookup::text(200)                           as cusiplookup
  , cusip::text(200)                                 as cusip
  , preferred::text(200)                             as preferred
  , securityid::text(200)                            as securityid
  , security_type_description::text(200)             as security_type_description
  , fund_type::text(200)                             as fund_type
  , product_type::text(200)                          as product_type
  , product_type_source_code::text(200)              as product_type_source_code
  , product_type_source_definition::text(200)        as product_type_source_definition
  , legacy_product_type::text(200)                   as legacy_product_type
  , legacy_product_type_source_code::text(200)       as legacy_product_type_source_code
  , legacy_product_type_source_definition::text(200) as legacy_product_type_source_definition
  , _created_at::timestamp_ntz                       as created_at
from {{ source('copilot', 'sod_positions_history') }}