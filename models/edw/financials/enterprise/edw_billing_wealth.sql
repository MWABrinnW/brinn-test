{{
  config(
    alias = 'billing_wealth' if target.name in ['prod', 'ci'] else None
    )
}}

select *
from {{ ref('billing_wealth') }}
