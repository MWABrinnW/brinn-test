select
    'salesforce'            as system_name
    , 'compass'             as system_instance
    , 'salesforce__compass' as system_key
    , *
from {{ source('salesforce_compass_fivetran', 'invoice_review_c') }}
