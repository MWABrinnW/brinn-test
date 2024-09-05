{{ config(
  grants = {'+select': ['ops_mwa']}
) }}

select *
from {{ ref('salesforce_compass__base_case') }}
where type in (
        'Billing' , 'Reconciliation' , 'Options Recon' , 'New York Operations'
        , 'Trading' , 'Equities - Cincy' , 'Client Services' , 'Operations' , 'Custodial'
    )
