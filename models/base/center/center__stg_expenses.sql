{% set src = source('center', 'expenses') %}

select
    e.id::text                            as id
    , e.json:status::text                 as status
    , e.json:userId::text                 as user_id
    , convert_timezone(
        'America/Chicago' , e.json:createdAt::timestamp_tz
    )                                     as created_at
    , convert_timezone(
        'America/Chicago' , e.json:approvedAt::timestamp_tz
    )                                     as approved_at
    , convert_timezone(
        'America/Chicago' , e.json:submittedAt::timestamp_tz
    )                                     as submitted_at
    , convert_timezone(
        'America/Chicago' , e.json:postedAt::timestamp_tz
    )                                     as posted_at
    , convert_timezone(
        'America/Chicago' , e.json:rejectedAt::timestamp_tz
    )                                     as rejected_at
    , convert_timezone(
        'America/Chicago' , e.json:sentBackAt::timestamp_tz
    )                                     as sent_back_at
    , convert_timezone(
        'America/Chicago' , e.json:lockedAt::timestamp_tz
    )                                     as locked_at
    , e.json:costCenterId::text           as default_cost_center_id
    , e.json:expenseTypeId::text          as expense_type_id
    , e.json:purpose::text                as purpose
    , e.json:flags::text                  as flags
    , e.json:hasReceipts::boolean::int    as has_receipts
    , e.json:hasSplits::boolean::int      as has_splits
    , e.json:isOOP::boolean::int          as is_oop
    , e.json:isPersonal::boolean::int     as is_personal
    , e.json:notReadyToSubmitReason::text as not_ready_to_submit_reason
    , e.json:policyId::text               as policy_id
    , e.json:splits::text                 as splits
    , e.json:reimbursement::variant       as reimbursement
    , e.json:notes::text                  as notes
    , e.json:fields::variant              as fields
    , e.json:customFields::variant        as custom_fields
    , e.json:transaction::variant         as transaction
    , e._created_at::timestamp_ntz        as _created_at
    , e._updated_at::timestamp_ntz        as _updated_at
    , e._source_file::varchar             as _source_file
from {{ src }} as e
