with cte_split as (
    select
        cu.effective_date
        , cu.is_head
        , cu.contact_id
        , cu.field_value
        , split.value as advisor
    from {{ ref('redtail_network__base_contact_udfs') }} as cu , lateral split_to_table(cu.field_value , '|') as split
    where true
        and cu.is_head = 1
        and cu.contact_udf_field_id = 272
)

select
    cu.effective_date
    , cu.is_head
    , cu.contact_id
    , cu.field_value
    , cu.advisor
    , cu2.field_value  as preferred_pms
    , re.email_address as email_address
from cte_split as cu
left join {{ ref('redtail_network__base_contact_udfs') }} as cu2
    on cu.contact_id = cu2.contact_id
    and cu2.is_head = 1
    and cu2.contact_udf_field_id = 245
left join {{ ref('redtail_network__base_contact_email_addresses') }} as re
    on re.is_head = 1
    and cu.contact_id = re.contact_id
where true
qualify row_number() over (partition by cu.advisor order by cu.advisor asc) = 1
