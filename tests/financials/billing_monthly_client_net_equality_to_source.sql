{{ config(
    severity='warn',
) }}

{%- set base_bills = [
    {'model': 'salesforce_compass__base_invoice_review_c', 'invoice_date': 'invoice_date_c',
     'client_fee_net': 'net_fee_c', 'is_head': 'yes'},
    {'model': 'addepar_corbenic_history__base_bills', 'invoice_date': 'billing_date',
     'client_fee_net': 'billing_fee_value', 'is_head': 'yes'},
    {'model': 'black_diamond_baystate__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'no'},
    {'model': 'black_diamond_houston__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'no'},
    {'model': 'black_diamond_uhnw__base_bills', 'invoice_date': "(dateadd('day', -1, date_trunc('quarter', cash_available_date)))::date",
     'client_fee_net': 'total_period_fee', 'is_head': 'no'},
    {'model': 'envestnet_manasquan__stg_bills', 'invoice_date': 'invoice_date',
     'client_fee_net': 'total_fee_amount', 'is_head': 'no'},
    {'model': 'sei_manasquan__base_bills', 'invoice_date': 'fee_effective_date',
     'client_fee_net': 'fees_collected', 'is_head': 'no'}
] %}

with cte_base as (
    {% for source in base_bills %}
        select
            system_key                                             as base_system_key--noqa: LT01
            , last_day(date_trunc('month' , {{ source['invoice_date'] }}))::date as base_invoice_date
            , sum({{ source['client_fee_net'] }})::number(15 , 2)                       as base_client_fee_net--noqa: LT01
        from
            {{ ref(source['model']) }}
        where
            true
            and last_day(date_trunc('month' , {{ source['invoice_date'] }}::date))
            >= last_day(dateadd('month' , -15 , date_trunc('month' , current_date)))
            and last_day(date_trunc('month' , {{ source['invoice_date'] }}::date))
            <= last_day(dateadd('month' , -1 , date_trunc('month' , current_date)))

            -- all models
            {% if source['is_head'] == 'yes' %}
                and is_head = 1
            {% else %}
                and 1 = 1
            {% endif %}

            -- salesforce only
            {% if source['model'] == 'salesforce_compass__base_invoice_review_c' %}
                and is_latest = 1
                and is_deleted = 0
                and _fivetran_deleted = 0
            {% else %}
                and 1 = 1
            {% endif %}
        group by all
        {%- if not loop.last %}
            union all
        {% endif %}
    {% endfor %}
)

, cte_billings as (
    select
        system_key                                                 as billings_system_key
        , last_day(date_trunc('month' , invoice_date::date))::date as billings_invoice_date
        , sum(client_fee_net)::number(15 , 2)                      as billings_client_fee_net
    from
        {{ ref('bld_billing_wealth_like') }}
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
    , billings.*
    , (base.base_client_fee_net - billings.billings_client_fee_net)::number(15 , 2) as revenue_diff
    , (base.base_client_fee_net = billings.billings_client_fee_net)::boolean        as revenue_equality
from cte_base as base
left join cte_billings as billings
    on base.base_system_key = billings.billings_system_key
    and base.base_invoice_date = billings.billings_invoice_date
where revenue_equality = false
order by base.base_system_key asc , base.base_invoice_date desc
