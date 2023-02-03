select
    id
    , product_id
    , deal_id
    , is_deleted
    , property_price
    , property_createdate
    , property_description
    , property_hs_lastmodifieddate
    , property_hs_position_on_quote
    , property_quantity
    , property_hs_object_id
    , property_hs_updated_by_user_id
    , property_hs_created_by_user_id
    , property_recurringbillingfrequency
    , property_name
    , _fivetran_synced
    , property_hs_url
from {{ source('hubspot_network', 'line_item') }}