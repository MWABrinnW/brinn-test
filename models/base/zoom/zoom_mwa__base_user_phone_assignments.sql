{{ config(
    materialized = 'incremental',
    unique_key='1',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    tags = ['daily']
) }}

with cte_users as (
    -- get all historical emails with max effective_at
    select
        lower(email)        as email
        , max(effective_at) as max_effective_at
    from {{ ref('zoom_mwa__base_phone_users') }}
    where 1 = 1
        {%- if is_incremental() %}
            and exists (
                select t.effective_at
                from {{ ref('zoom_mwa__base_phone_users') }} as t
                where t.effective_at > (select max(tt.effective_at) from {{ this }} as tt)
            )
        {%- endif %}
    group by lower(email)
    order by email
)

, cte_users_with_id as (
    -- get the latest data for each email/user
    select pu.*
    from cte_users as u
    inner join {{ ref('zoom_mwa__base_phone_users') }} as pu
        on u.email = lower(pu.email)
        and u.max_effective_at::date = pu.effective_at::date
)

-- add latest phone number assigned to each email address
select
    u.* exclude (is_head , _created_at)
    , apn.number
    , apn.source
    , apn.number_type
    , apn.location
    , apn.capability
    , apn.assignee_ext_number
    , apn.assignee_type
    , current_timestamp()::timestamp_ntz as _created_at
from cte_users_with_id as u
inner join {{ ref('zoom_mwa__base_account_phone_numbers') }} as apn
    on u.id = apn.assignee_id
    and u.effective_at::date = apn.effective_at::date
qualify row_number() over (partition by lower(u.email) order by apn.number_type) = 1
