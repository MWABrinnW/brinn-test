select
    effective_date                          as effective_date
    , custodian                             as custodiancode
    , account_number                        as account
    , product                               as product
    , ticker                                as symbol
    , quantity                              as quantity
    , price                                 as unitcost
    , lot_cost                              as totalcost
    , current_price                         as price
    , lot_date                              as lotdate
    , lot_num                               as lotnum
    , null::text(200)                       as source_lot_id
    , unsupervised                          as unsupervised
    , cusiplookup                           as cusiplookup
    , cusip                                 as cusip
    , preferred                             as preferred
    , securityid                            as securityid
    , security_type_description             as security_type_description
    , fund_type                             as fund_type
    , product_type                          as product_type
    , product_type_source_code              as product_type_source_code
    , product_type_source_definition        as product_type_source_definition
    , legacy_product_type                   as legacy_product_type
    , legacy_product_type_source_code       as legacy_product_type_source_code
    , legacy_product_type_source_definition as legacy_product_type_source_definition
from {{ ref('fixflyer_options__sod_positions_prep') }}
