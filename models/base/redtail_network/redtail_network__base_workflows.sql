{% set src = source('redtail_network', 'workflows') %}

with workflow_steps_cte as (
    select
        s.json:id::int                                     as workflow_id
        , workflow_steps.value:id::int                     as step_id
        , workflow_steps.value:name::varchar               as step_name
        , workflow_steps.value:workflow_id::varchar        as step_workflow_id
        , workflow_steps.value:order_position::int         as step_order_position
        , workflow_steps.value:interval::varchar           as step_interval
        , workflow_steps.value:frequency::varchar          as step_frequency
        , workflow_steps.value:interval_placement::varchar as step_interval_placement
        , workflow_steps.value:display_interval::varchar   as step_display_interval
        , workflow_steps.value:completion_date::timestamp  as step_completion_date
        , workflow_steps.value:description::varchar        as step_description
        , workflow_steps.value:comments::varchar           as step_comments
        , workflow_steps.value:tasks_remaining::int        as step_tasks_remaining
        , workflow_steps.value:deleted::boolean            as step_deleted
        , workflow_steps.value:created_at::timestamp       as step_created_at
        , workflow_steps.value:updated_at::timestamp       as step_updated_at
        , workflow_steps.value:workflow_step_tasks         as workflow_step_tasks
    from {{ src }} as s
    , lateral flatten(input => s.json:workflow_steps) as workflow_steps
)

, workflow_step_tasks_cte as (
    select
        workflow_steps_cte.workflow_id                             as workflow_id
        , workflow_steps_cte.step_id                               as step_id
        , workflow_step_tasks.value:id::varchar                    as task_id
        , workflow_step_tasks.value:name::varchar                  as task_name
        , workflow_step_tasks.value:workflow_step_id::int          as task_workflow_step_id
        , workflow_step_tasks.value:parent_step_task_id::varchar   as parent_step_task_id
        , workflow_step_tasks.value:assignee_id::int               as task_assignee_id
        , workflow_step_tasks.value:assignee_type::int             as task_assignee_type
        , workflow_step_tasks.value:display_position::int          as task_display_position
        , workflow_step_tasks.value:due_date::timestamp            as task_due_date
        , workflow_step_tasks.value:calculated_due_date::timestamp as task_calculated_due_date
        , workflow_step_tasks.value:completion_date::timestamp     as task_completion_date
        , workflow_step_tasks.value:description::varchar           as task_description
        , workflow_step_tasks.value:deleted::boolean               as task_deleted
        , workflow_step_tasks.value:created_at::timestamp          as task_created_at
        , workflow_step_tasks.value:updated_at::timestamp          as task_updated_at
    from workflow_steps_cte
    , lateral flatten(input => workflow_steps_cte.workflow_step_tasks) as workflow_step_tasks
)

, linked_contacts_cte as (
    select
        s.json:id::int                                as workflow_id
        , linked_contacts.value:type::varchar         as contact_type
        , linked_contacts.value:first_name::varchar   as contact_first_name
        , linked_contacts.value:middle_name::varchar  as contact_middle_name
        , linked_contacts.value:last_name::varchar    as contact_last_name
        , linked_contacts.value:company_name::varchar as contact_company_name
        , linked_contacts.value:full_name::varchar    as contact_full_name
        , linked_contacts.value:nickname::varchar     as contact_nickname
        , linked_contacts.value:suffix_id::varchar    as contact_suffix_id
        , linked_contacts.value:suffix::varchar       as contact_suffix
        , linked_contacts.value:job_title::varchar    as contact_job_title
        , linked_contacts.value:favorite::boolean     as contact_favorite
        , linked_contacts.value:pronouns::varchar     as contact_pronouns
        , linked_contacts.value:deleted::boolean      as contact_deleted
        , linked_contacts.value:created_at::timestamp as contact_created_at
        , linked_contacts.value:updated_at::timestamp as contact_updated_at
        , linked_contacts.value:contact_id::int       as contact_id
    from {{ src }} as s
    , lateral flatten(input => s.json:linked_contacts) as linked_contacts
)

select
    -- top level fields
    s.json:id::int                         as workflow_id
    , s.json:workflow_template_id::varchar as workflow_template_id
    , s.json:name::varchar                 as workflow_name
    , s.json:due_date::timestamp           as workflow_due_date
    , s.json:current_step_id::int          as current_step_id
    , s.json:status::int                   as workflow_status
    , s.json:assignee_id::int              as workflow_assignee_id
    , s.json:assignee_type::varchar        as assignee_type
    , s.json:completion_date::timestamp    as workflow_completion_date
    , s.json:description::varchar          as workflow_description
    , s.json:category_id::int              as category_id
    , s.json:category::varchar             as workflow_category
    , s.json:exclude_weekends::boolean     as exclude_weekends
    , s.json:deleted::boolean              as workflow_deleted
    , s.json:created_at::timestamp         as workflow_created_at
    , s.json:updated_at::timestamp         as workflow_updated_at
    , s.json:_effective_at::timestamp      as workflow_effective_at

    -- workflow steps
    , ws.step_id                           as step_id
    , ws.step_name                         as step_name
    , ws.step_workflow_id                  as step_workflow_id
    , ws.step_order_position               as step_order_position
    , ws.step_interval                     as step_interval
    , ws.step_frequency                    as step_frequency
    , ws.step_interval_placement           as step_interval_placement
    , ws.step_display_interval             as step_display_interval
    , ws.step_completion_date              as step_completion_date
    , ws.step_description                  as step_description
    , ws.step_comments                     as step_comments
    , ws.step_tasks_remaining              as step_tasks_remaining
    , ws.step_deleted                      as step_deleted
    , ws.step_created_at                   as step_created_at
    , ws.step_updated_at                   as step_updated_at

    -- workflow step tasks
    , wt.task_id                           as task_id
    , wt.task_name                         as task_name
    , wt.task_workflow_step_id             as task_workflow_step_id
    , wt.parent_step_task_id               as parent_step_task_id
    , wt.task_assignee_id                  as task_assignee_id
    , wt.task_assignee_type                as task_assignee_type
    , wt.task_display_position             as task_display_position
    , wt.task_due_date                     as task_due_date
    , wt.task_calculated_due_date          as task_calculated_due_date
    , wt.task_completion_date              as task_completion_date
    , wt.task_description                  as task_description
    , wt.task_deleted                      as task_deleted
    , wt.task_created_at                   as task_created_at
    , wt.task_updated_at                   as task_updated_at

    -- linked contacts
    , lc.contact_type                      as contact_type
    , lc.contact_first_name                as contact_first_name
    , lc.contact_middle_name               as contact_middle_name
    , lc.contact_last_name                 as contact_last_name
    , lc.contact_company_name              as contact_company_name
    , lc.contact_full_name                 as contact_full_name
    , lc.contact_nickname                  as contact_nickname
    , lc.contact_suffix_id                 as contact_suffix_id
    , lc.contact_suffix                    as contact_suffix
    , lc.contact_job_title                 as contact_job_title
    , lc.contact_favorite                  as contact_favorite
    , lc.contact_pronouns                  as contact_pronouns
    , lc.contact_deleted                   as contact_deleted
    , lc.contact_created_at                as contact_created_at
    , lc.contact_updated_at                as contact_updated_at
    , lc.contact_id                        as contact_id

    , s._created_at                        as _created_at

from {{ src }} as s
left join workflow_steps_cte as ws
    on s.json:id::int = ws.workflow_id
left join workflow_step_tasks_cte as wt
    on ws.step_id = wt.step_id
left join linked_contacts_cte as lc
    on s.json:id::int = lc.workflow_id
