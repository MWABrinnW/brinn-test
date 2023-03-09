with cte_users as
(
    -- get all historical emails with max effective_at
    select lower(email) as email, max(effective_at) as max_effective_at
    from {{ ref('zoom_mwa__base_phone_users') }}
    group by lower(email)
    order by email
)
,cte_users_with_id as
(
    -- get the latest data for each email/user
    select pu.*
    from cte_users u
    join {{ ref('zoom_mwa__base_phone_users') }} pu
        on u.email = lower(pu.email)
        and u.max_effective_at::date = pu.effective_at::date
)

-- add latest phone number assigned to each email address
select
    u.*
    ,apn.number
    ,apn.source
    ,apn.number_type
    ,apn.location
    ,apn.capability
    ,apn.assignee_ext_number
    ,apn.assignee_type
    ,{{ col_is_head(reference=ref('zoom_mwa__base_account_phone_numbers'), reference_date_col='_created_at', source_date_col='apn._created_at') }}
from cte_users_with_id u
join {{ ref('zoom_mwa__base_account_phone_numbers') }} apn
    on u.id = apn.assignee_id
    and u.effective_at::date = apn.effective_at::date