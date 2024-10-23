{{ config(
    severity='error',
) }}

select distinct--noqa: AM01
    invoice_number_source
    , count(*) as cnt
from {{ ref('bld_billing_wealth_like') }}
where true
    and system_key = 'salesforce__compass'
group by all
having cnt > 1
