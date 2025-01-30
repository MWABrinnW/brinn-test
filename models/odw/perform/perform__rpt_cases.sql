select
    c.case_num          as case_num
    , c.case_id         as case_id
    , c.estate_item_id  as estate_item_id
    , a.account_number  as account_number
    , a.trading_systems as trading_systems
    , a.household_name  as household_name
    , a.client_manager  as client_manager
    , c.modified_at     as case_modified_at
    , c.created_at      as case_created_at
    , c.status          as case_status
    , c.subject         as case_subject
    , c.description     as case_description
    , c.estate_item_id  as crm_account_id
from {{ ref('mis__stg_salesforce_compass_case') }} as c
left join {{ ref('mis__accounts') }} as a
    on c.estate_item_id = a.crm_account_id
where 1 = 1
    and c.is_head = 1
