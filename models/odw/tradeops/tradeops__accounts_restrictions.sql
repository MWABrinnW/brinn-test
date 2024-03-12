select
    a.effective_date         as effective_date
    , a.platform             as platform
    , a.venue                as venue
    , lower(acc.custodian)   as custodian
    , a.account_id           as account_id
    , acc.account_number     as account_number
    , acc.account_name       as account_name

    , a.restriction_id       as restriction_id
    , a.is_enabled           as is_enabled
    , a.restriction_type     as restriction_type
    , a.external_restriction as type
    , a.restriction_mapping  as value
    , a.security_id          as security_id
    , a.cusip                as cusip
    --, a.product              as product
    , a.last_modified_at     as last_modified_at

    --, a.is_head              as is_head
    , a._created_at          as last_collected_at
    --, a._source_file         as _source_file
from {{ ref('flyer__stg_restrictions') }} as a
left join {{ ref('flyer__stg_accounts') }} as acc
    on a.effective_date = acc.effective_date
    and a.account_id = acc.account_id
    and acc.is_head_for_day = 1
where 1 = 1
    and a.is_head = 1
    and a._env = {{ "'" ~ copilot_env() ~ "'" }}
