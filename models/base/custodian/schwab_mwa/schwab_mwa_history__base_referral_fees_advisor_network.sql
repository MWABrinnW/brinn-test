{{ config(tags=["referral_fees"]) }}

select *
from {{ ref('schwab__base_referral_fees_advisor_network') }}
where 1=1
  and firm = 'mwa'
