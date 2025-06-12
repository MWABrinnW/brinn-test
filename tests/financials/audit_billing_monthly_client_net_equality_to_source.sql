{{ config(
    severity='warn',
) }}

{%- set src_bills = [
    {'model': 'addepar_corbenic_history__int_bills', 'invoice_date': 'billing_date',
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
        system_key                   as dest_system_key
        , max(_created_at)::datetime as max_created_at
    from
        {{ ref('billing_wealth') }}
    group by all
)

, source_stats as (
    {%- for source in src_bills %}
        select
            a.system_key                                                         as src_system_key--noqa: LT01
            , last_day(date_trunc('month' , {{ source['invoice_date'] }}))::date as src_invoice_date
            , sum({{ source['client_fee_net'] }})::number(15 , 2)                as src_client_fee_net--noqa: LT01
        from
            {{ ref(source['model']) }} as a
        left join cte_billing_max as b
            on a.system_key = b.dest_system_key
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
        {%- if source['model'] == 'stg_salesforce_compass_invoice_review' %}
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
        system_key                                                 as dest_system_key
        , last_day(date_trunc('month' , invoice_date::date))::date as dest_invoice_date
        , sum(client_fee_net)::number(15 , 2)                      as dest_client_fee_net
    from
        {{ ref('billing_wealth') }}
    where
        true
        and last_day(date_trunc('month' , invoice_date::date))
        >= last_day(dateadd('month' , -15 , date_trunc('month' , current_date)))
        and last_day(date_trunc('month' , invoice_date::date))
        <= last_day(dateadd('month' , -1 , date_trunc('month' , current_date)))
    group by all
)

select
    src.*
    , dest.*
    , (dest.dest_client_fee_net - src.src_client_fee_net)::number(15 , 2) as revenue_diff
    , (src.src_client_fee_net = dest.dest_client_fee_net)::int            as is_match
from source_stats as src
left join cte_billing as dest
    on src.src_system_key = dest.dest_system_key
    and src.src_invoice_date = dest.dest_invoice_date
where is_match = 0
order by src.src_system_key asc , src.src_invoice_date desc
