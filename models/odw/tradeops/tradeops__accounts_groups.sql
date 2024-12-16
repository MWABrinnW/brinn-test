select
    a.effective_date     as effective_date
    , a.system_key       as system_key
    , a.group_name       as group_name
    , a.account_id       as account_id
    , lower(a.custodian) as custodian
    , a.account_number   as account_number
    , a.account_name     as account_name
    , a.is_head          as is_head
    , a._created_at      as last_collected_at
    --, a._source_file     as _source_file
from {{ ref('flyer__stg_groups') }} as a
where 1 = 1
    and a.is_head = 1
    and a._env = {{ "'" ~ copilot_env() ~ "'" }}
