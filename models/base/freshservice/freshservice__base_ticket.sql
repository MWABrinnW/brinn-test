select
    id::number(38 , 0)                      as id
    , requester_id::number(38 , 0)          as requester_id
    , responder_id::number(38 , 0)          as responder_id
    , department_id::number(38 , 0)         as department_id
    , group_id::number(38 , 0)              as group_id
    , requested_for_id::number(38 , 0)      as requested_for_id
    , created_at::timestamp_tz(9)           as created_at
    , updated_at::timestamp_tz(9)           as updated_at
    , due_by::timestamp_tz(9)               as due_by
    , fr_due_by::timestamp_tz(9)            as fr_due_by
    , priority::text(256)                   as priority
    , status::text(256)                     as status
    , source::text(256)                     as source
    , subject::text(256)                    as subject
    , type::text(256)                       as type
    , category::text(256)                   as category
    , is_escalated::boolean                 as is_escalated
    , description_text::text                as description_text
    , description::text                     as description
    , association_type::number(38 , 0)      as association_type
    , approval_status::number(38 , 0)       as approval_status
    , approval_status_name::text(256)       as approval_status_name
    , _fivetran_deleted::boolean            as _fivetran_deleted
    , _fivetran_synced::timestamp_tz(9)     as _fivetran_synced
    , custom_account_number::number(38 , 0) as custom_account_number
    , custom_yt::text(256)                  as custom_yt
    , workspace_id::number(38 , 0)          as workspace_id
    , sub_category::text(256)               as sub_category
    , item_category::text(256)              as item_category
    , custom_follow_up_date::date           as custom_follow_up_date
    , custom_advisor_region::text(256)      as custom_advisor_region
    , custom_advisor_tier::text(256)        as custom_advisor_tier
from {{ source('freshservice', 'ticket') }}
