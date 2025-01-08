{{ config(
    severity='warn',
) }}

{%- set base_bills = [
    {'model': 'salesforce_compass__base_invoice_review_c', 'invoice_date': 'invoice_date_c',
     'client_fee_net': 'net_fee_c', 'is_head': 'yes', 'created_at': "greatest(last_modified_date,created_date)"},
    {'model': 'addepar_corbenic_history__base_bills', 'invoice_date': 'billing_date',
     'client_fee_net': 'billing_fee_value', 'is_head': 'yes', 'created_at': '_created_at'},
    {'model': 'black_diamond_baystate__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'yes', 'created_at': '_created_at'},
    {'model': 'black_diamond_houston__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'yes', 'created_at': '_created_at'},
    {'model': 'black_diamond_mps__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'yes', 'created_at': '_created_at'},
    {'model': 'black_diamond_uhnw__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'yes', 'created_at': '_created_at'},
    {'model': 'envestnet_manasquan__stg_bills', 'invoice_date': 'invoice_date',
     'client_fee_net': 'total_fee_amount', 'is_head': 'yes', 'created_at': '_created_at'},
    {'model': 'sei_manasquan__base_bills', 'invoice_date': 'fee_effective_date',
     'client_fee_net': 'fees_collected', 'is_head': 'yes', 'created_at': '_created_at'}
] %}

with cte_billing_max as (
    select
        system_key                   as billing_system_key
        , max(_created_at)::datetime as max_created_at
    from
        {{ ref('bld_billing_wealth') }}
    group by all
)

, cte_base as (
    {%- for source in base_bills %}
        select
            a.system_key                                             as base_system_key--noqa: LT01
            , last_day(date_trunc('month' , {{ source['invoice_date'] }}))::date as base_invoice_date
            , sum({{ source['client_fee_net'] }})::number(15 , 2)                       as base_client_fee_net--noqa: LT01
        from
            {{ ref(source['model']) }} as a
        left join cte_billing_max as b
            on a.system_key = b.billing_system_key
        where
            true
            and last_day(date_trunc('month' , {{ source['invoice_date'] }}::date))
            >= last_day(dateadd('month' , -15 , date_trunc('month' , current_date)))
            and last_day(date_trunc('month' , {{ source['invoice_date'] }}::date))
            <= last_day(dateadd('month' , -1 , date_trunc('month' , current_date)))
            and {{ source['created_at'] }} <= b.max_created_at

            -- all models
            {%- if source['is_head'] == 'yes' %}
                and a.is_head = 1
            {%- endif %}

            -- salesforce only
            {%- if source['model'] == 'salesforce_compass__base_invoice_review_c' %}
                and a.is_latest = 1
                and a.is_deleted = 0
                and a._fivetran_deleted = 0
            {%- endif %}

        group by all

        {%- if not loop.last %}
            union all
        {%- endif %}

    {% endfor %}
)

, cte_billing as (
    select
        system_key                                                 as billing_system_key
        , last_day(date_trunc('month' , invoice_date::date))::date as billing_invoice_date
        , sum(client_fee_net)::number(15 , 2)                      as billing_client_fee_net
    from
        {{ ref('bld_billing_wealth') }}
    where
        true
        and last_day(date_trunc('month' , invoice_date::date))
        >= last_day(dateadd('month' , -15 , date_trunc('month' , current_date)))
        and last_day(date_trunc('month' , invoice_date::date))
        <= last_day(dateadd('month' , -1 , date_trunc('month' , current_date)))
    group by all
)

select
    base.*
    , billing.*
    , (base.base_client_fee_net - billing.billing_client_fee_net)::number(15 , 2) as revenue_diff
    , (base.base_client_fee_net = billing.billing_client_fee_net)::boolean        as revenue_equality
from cte_base as base
left join cte_billing as billing
    on base.base_system_key = billing.billing_system_key
    and base.base_invoice_date = billing.billing_invoice_date
where revenue_equality = false
order by base.base_system_key asc , base.base_invoice_date desc
