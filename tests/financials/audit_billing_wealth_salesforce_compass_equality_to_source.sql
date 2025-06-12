with max_invoice_created_at as (
    select max(invoice_created_at) as invoice_created_at
    from {{ ref('billing_wealth') }}
    where system_key = 'salesforce__compass'

    union all

    select max(invoice_created_at) as invoice_created_at
    from {{ ref('billing_independent_advisory') }}
    where system_key = 'salesforce__compass'
)

, src as (
    select
        name             as invoice_number
        , sum(net_fee_c) as client_fee_net
        , invoice_date_c as invoice_date
    from {{ ref('stg_salesforce_compass_invoice_review') }}
    where 1 = 1
        and is_deleted = 0
        and _fivetran_deleted = 0
        -- This is the same filter as the related compass billing models.
        and invoice_date_c >= '12/31/2021'
        -- Exclude invoices that were created so recently and that haven't been built yet.
        -- This is only relevant if the test is being invoked without having just built the related upstream models.
        -- Or, if the fivetran data is synced inbetween model execution and test invocation (would be rare).
        and convert_timezone('America/Chicago' , created_date) <= (select max(invoice_created_at) from max_invoice_created_at)
    group by all
)

   , dest as (
    select
        invoice_number_source as invoice_number
        , sum(client_fee_net) as client_fee_net
        , invoice_date
    from {{ ref('billing_wealth') }}
    where 1 = 1
        and system_key = 'salesforce__compass'
    group by all

    union all

    select
        invoice_number_source as invoice_number
        , sum(client_fee_net) as client_fee_net
        , invoice_date
    from {{ ref('billing_independent_advisory') }}
    where 1 = 1
        and system_key = 'salesforce__compass'
    group by all
)

   , spine as (
    select invoice_number
    from src
    union distinct
    select invoice_number
    from dest
)

select
    a.invoice_number
    , b.client_fee_net                                                as client_fee_net_src
    , c.client_fee_net                                                as client_fee_net_dest
    , b.invoice_date                                                  as invoice_date_src
    , c.invoice_date                                                  as invoice_date_dest
    , coalesce(b.client_fee_net , 0) - coalesce(c.client_fee_net , 0) as diff
from spine as a
left join src as b
    on a.invoice_number = b.invoice_number
left join dest as c
    on a.invoice_number = c.invoice_number
where 1 = 1
    and abs(diff) > 1
