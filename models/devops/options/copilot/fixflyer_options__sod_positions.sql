select
    effective_date    as effective_date
    , custodian       as custodiancode
    , account_number  as account
    , product         as product
    , ticker          as symbol
    , quantity        as quantity
    , price           as unitcost
    , lot_cost        as totalcost
    , current_price   as price
    , lot_date        as lotdate
    , null::text(200) as source_lot_id
    , unsupervised    as unsupervised
    , cusiplookup     as cusiplookup
    , cusip           as cusip
    , preferred       as preferred
    , securityid      as securityid
    , null::text(200) as security_type_description
    , null::text(200) as fund_type
    , null::text(200) as product_type
    , null::text(200) as product_type_source_code
    , null::text(200) as product_type_source_definition
    , null::text(200) as legacy_product_type
    , null::text(200) as legacy_product_type_source_code
    , null::text(200) as legacy_product_type_source_definition
from {{ ref('fixflyer_options__sod_positions_prep') }}
