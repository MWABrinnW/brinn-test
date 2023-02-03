select
    deal_id
    , merged_deal_id
    , _fivetran_synced
from {{ source('hubspot_network', 'merged_deal') }}