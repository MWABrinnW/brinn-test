{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    on_schema_change = 'sync_all_columns',
    unique_key = ['system_name', 'account_number', 'account_id'],
    merge_exclude_columns = ['_created_at'],
    grants = {'+select': ['platforms', 'integration_salesforce']}
) }}

with cte_all_accounts as (
    select
        * exclude (_created_at , effective_date)
        , hash(
            * exclude(
                effective_date
                , _created_at
                , _source_loaded_at
            )
        ) as _id
    from {{ ref('pms__nml_orion_accounts') }}
    where 1 = 1
)

{%- if is_incremental() %}
    , cte_changed_accounts as (
        select a.*
        from cte_all_accounts as a
        left join {{ this }} as b
            on a.account_number = b.account_number
            and a.account_id = b.account_id
            and a.system_name = b.system_name
        where 1 = 1
            and (
            -- Record doesn't exist in destination
                b.account_number is null
                or
                -- Record exists in destination but the value(s) have changed
                a._id <> b._id
            )
    )
{%- endif %}

select
    *
    , current_timestamp()::timestamp_ntz as _created_at
    , current_timestamp()::timestamp_ntz as _updated_at
{%- if is_incremental() %}
    from cte_changed_accounts
{%- else %}
from cte_all_accounts
{%- endif %}
-- We have seen duplicates pop up before and need to ensure that we attempt to merge
-- a unique record no matter what.
qualify row_number() over (
    partition by _id order by _updated_at desc , _created_at desc
) = 1
and row_number() over (
    partition by system_name , account_number , account_id order by _updated_at desc , _created_at desc
) = 1
