select *
from {{ ref('schwab__base_referral_fees_prior_quarter') }}
where 1=1
  and firm = 'mwa'
