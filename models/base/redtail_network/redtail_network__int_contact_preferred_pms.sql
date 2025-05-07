with cte_split as (
    select
        cu.effective_date
        , cu.is_head
        , cu.contact_id
        , cu.field_value
        , split.value as advisor
    from {{ ref('redtail_network__base_contact_udfs') }} as cu
    , lateral split_to_table(cu.field_value , '|') as split
    where cu.is_head = 1
        and cu.contact_udf_field_id = 272
)

, cte_emails as (
    -- This CTE selects one 'Work' email address per contact, prioritizing primary emails (is_primary = 1).
    -- If no primary exists, it falls back to a non-primary Work email (is_primary = 0).
    select *
    from (
        select
            *
            , row_number() over (
                partition by contact_id
                order by case when is_primary = 1 then 1 else 2 end
            ) as rn
        from {{ ref('redtail_network__base_contact_email_addresses') }}
        where is_head = 1
            and email_type_description = 'Work'
    ) as prioritized_emails
    where rn = 1
)

select
    ct.effective_date
    , ct.is_head
    , ct.contact_id
    , cu.field_value
    , coalesce(cu.advisor , ct.full_name) as advisor
    , cu2.field_value                     as preferred_pms
    , re.email_address                    as email_address
    , ct.full_name                        as advisor_full_name
    , object_construct_keep_null(
        'rt_status' , ct.status
        , 'rt_category' , ct.category
        , 'ft_full_name' , ct.first_name || ' ' || ct.middle_name || ' ' || ct.last_name
    )                                     as _extra_fields
    --, ct.*
from {{ ref('redtail_network__base_contacts') }} as ct
left join cte_split as cu
    on ct.contact_id = cu.contact_id
left join {{ ref('redtail_network__base_contact_udfs') }} as cu2
    on ct.contact_id = cu2.contact_id
    and cu2.is_head = 1
    and cu2.contact_udf_field_id = 245
left join cte_emails as re
    on ct.contact_id = re.contact_id
where ct.is_head = 1
    and ct.status in ('Platform Advisor' , 'Network Advisor')
