{{ config(materialized='table') }}


with contacts as (
    select
        contact_id
        , first_name
        , middle_name
        , last_name
        , full_name
        , nickname
        , status
        , category
        , _created_at
    from {{ ref('redtail_network__base_contacts') }}
    where true
        and is_head = 1
        and status in ('Platform Advisor' , 'Network Advisor')
)

, contact_udfs as (
    select
        cu.effective_at::date     as effective_date
        , cu.contact_id           as contact_id
        , cu.contact_udf_field_id as contact_udf_field_id
        , cu.field_value          as field_value
        , split.value             as advisor
    from {{ ref('redtail_network__base_contact_udfs') }} as cu
    , lateral split_to_table(cu.field_value , '|') as split
    where true
        and cu.is_head = 1
)

, emails as (
    -- This CTE selects one 'Work' email address per contact, prioritizing primary emails (is_primary = 1).
    -- If no primary exists, it falls back to a non-primary Work email (is_primary = 0).
    select
        contact_id
        , email_address
    from {{ ref('redtail_network__base_contact_email_addresses') }}
    where true
        and is_head = 1
        and email_type_description = 'Work'
        and contact_id in (select distinct t.contact_id from contacts as t)
    qualify row_number() over (
            partition by contact_id
            order by case when is_primary = 1 then 1 else 2 end
        ) = 1
)

select
    ct.contact_id                        as contact_id
    , cu.field_value                     as field_value
    , cu.advisor                         as advisor_udf
    {# , coalesce(cu.advisor , ct.full_name) as advisor #} -- results ambiguous column down stream, ENG to better understand this field with DMAG
    , cu2.field_value                    as preferred_pms
    , em.email_address                   as advisor_email
    , ct.first_name                      as advisor_first_name
    , ct.nickname                        as advisor_nick_name
    , ct.middle_name                     as advisor_middle_name
    , ct.last_name                       as advisor_last_name
    , ct.full_name                       as advisor_full_name
    , object_construct_keep_null(
        'redtail_status' , ct.status
        , 'redtail_category' , ct.category
    )                                    as _extra_fields
    , ct._created_at                     as _source_loaded_at
    , current_timestamp()::timestamp_ntz as _created_at
from contacts as ct
left join contact_udfs as cu
    on ct.contact_id = cu.contact_id
    and cu.contact_udf_field_id = 272
-- 245 equates to the "Portfolio Management System" field in Redtail
left join contact_udfs as cu2
    on ct.contact_id = cu2.contact_id
    and cu2.contact_udf_field_id = 245
left join emails as em
    on ct.contact_id = em.contact_id
where true
qualify row_number() over (
        partition by coalesce(cu.advisor , ct.full_name)
        order by ct.contact_id asc , ct._created_at desc
    ) = 1
