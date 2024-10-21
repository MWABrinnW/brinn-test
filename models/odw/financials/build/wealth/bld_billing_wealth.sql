-- depends_on: {{ ref('addepar_corbenic_history__base_bills') }}
-- depends_on: {{ ref('black_diamond_baystate__base_bills') }}
-- depends_on: {{ ref('black_diamond_houston__base_bills') }}
-- depends_on: {{ ref('black_diamond_uhnw__base_bills') }}
-- depends_on: {{ ref('envestnet_manasquan__stg_bills') }}
-- depends_on: {{ ref('salesforce_compass__base_invoice_review_c') }}
-- depends_on: {{ ref('sei_manasquan__base_bills') }}

{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'system_key',
    cluster_by = ['revenue_period_end_date', 'system_key']
) }}

{%- set system_keys =
    [
        'addepar__corbenic',
        'black_diamond__baystate',
        'black_diamond__houston',
        'black_diamond__uhnw',
        'envestnet__manasquan',
        'salesforce__compass',
        'sei__manasquan'
    ]
-%}

with cte_check as (

    {%- if is_incremental() %}

        select
            case
                when (
                    select max(_created_at)
                    from {{ ref('addepar_corbenic_history__base_bills') }}) > coalesce(
                    (select max(_source_loaded_at) from {{ this }} where system_key = 'addepar__corbenic')
                    , '1900-01-01'::date::timestamp
                )
                    then 'addepar__corbenic'
            end as system_key

        union all

        select
            case
                when (
                    select max(_created_at)
                    from {{ ref('black_diamond_baystate__base_bills') }}) > coalesce(
                    (select max(_source_loaded_at) from {{ this }} where system_key = 'black_diamond__baystate')
                    , '1900-01-01'::date::timestamp
                )
                    then 'black_diamond__baystate'
            end as system_key

        union all

        select
            case
                when (
                    select max(_created_at)
                    from {{ ref('black_diamond_houston__base_bills') }}) > coalesce(
                    (select max(_source_loaded_at) from {{ this }} where system_key = 'black_diamond__houston')
                    , '1900-01-01'::date::timestamp
                )
                    then 'black_diamond__houston'
            end as system_key

        union all

        select
            case
                when (
                    select max(_created_at)
                    from {{ ref('black_diamond_uhnw__base_bills') }}) > coalesce(
                    (select max(_source_loaded_at) from {{ this }} where system_key = 'black_diamond__uhnw')
                    , '1900-01-01'::date::timestamp
                )
                    then 'black_diamond__uhnw'
            end as system_key

        union all

        select
            case
                when (
                    select max(_created_at)
                    from {{ ref('envestnet_manasquan__stg_bills') }}) > coalesce(
                    (select max(_source_loaded_at) from {{ this }} where system_key = 'envestnet__manasquan')
                    , '1900-01-01'::date::timestamp
                )
                    then 'envestnet__manasquan'
            end as system_key

        union all

        select
            case
                when (
                    select max(_created_at)
                    from {{ ref('sei_manasquan__base_bills') }}) > coalesce(
                    (select max(_source_loaded_at) from {{ this }} where system_key = 'sei__manasquan')
                    , '1900-01-01'::date::timestamp
                )
                    then 'sei__manasquan'
            end as system_key

        union all

        -- For salesforce__compass we use the source application timestamp values for comparison.
        select case
            when (
                select
                    greatest(
                        max(last_modified_date)
                        , max(created_date)
                    )
                from {{ ref('salesforce_compass__base_invoice_review_c') }}
                where 1 = 1
                    and is_head = 1
                    and is_latest = 1
                    and is_deleted = 0
                    and _fivetran_deleted = 0
                    and invoice_date_c >= '12/31/2021'-- move downstream
            ) > coalesce(
                (
                    select max(_source_loaded_at) from {{ this }}
                    where system_key = 'salesforce__compass'
                )
                , '1900-01-01'::date::timestamp
            )
                then 'salesforce__compass'
        end as system_key

    {%- else %}

    {%- for key in system_keys %}

        select {{ "'" ~ key ~ "'" }} as system_key

    {%- if not loop.last %}
    union all
    {%- endif %}

    {%- endfor %}

    {%- endif %}

)

, cte_union as (
    select *
    from {{ ref('int_billing_wealth_02_coa') }}
    where true
        {% if is_incremental() %}
            and system_key in (
                select system_key
                from cte_check
                where system_key is not null
            )
        {% endif %}
)

select
    *
    , current_timestamp()::timestamp as _created_at
from cte_union
where true
{% if target.name == 'prod' %}
        and system_key in ('addepar__corbenic', 'black_diamond__baystate', 'black_diamond__houston', 'black_diamond__uhnw', 'salesforce__compass', 'sei__manasquan', 'envestnet__manasquan')
    {% endif %}
