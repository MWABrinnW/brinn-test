{% set src = source('redtail_network', 'workflows') %}

with workflow_steps_cte as (
    select
        w.json:id::int                         as workflow_id
        , ws.value:id::int                     as step_id
        , ws.value:name::varchar               as step_name
        , ws.value:workflow_id::varchar        as step_workflow_id
        , ws.value:order_position::int         as step_order_position
        , ws.value:interval::varchar           as step_interval
        , ws.value:frequency::varchar          as step_frequency
        , ws.value:interval_placement::varchar as step_interval_placement
        , ws.value:display_interval::varchar   as step_display_interval
        , ws.value:completion_date::timestamp  as step_completion_date
        , ws.value:description::varchar        as step_description
        , ws.value:comments::varchar           as step_comments
        , ws.value:tasks_remaining::int        as step_tasks_remaining
        , ws.value:deleted::int                as step_deleted
        , ws.value:created_at::timestamp       as step_created_at
        , ws.value:updated_at::timestamp       as step_updated_at
        , ws.value:workflow_step_tasks         as workflow_step_tasks
        , ws.value:workflow_step_outcomes      as workflow_step_outcomes
        , w._created_at::timestamp             as _created_at
    from {{ src }} as w
    , lateral flatten(input => w.json:workflow_steps) as ws
)

, workflow_step_tasks_cte as (
    select
        ws.workflow_id                             as workflow_id
        , ws.step_id                               as step_id
        , wst.value:id::varchar                    as task_id
        , wst.value:name::varchar                  as task_name
        , wst.value:workflow_step_id::int          as task_workflow_step_id
        , wst.value:parent_step_task_id::varchar   as parent_step_task_id
        , wst.value:assignee_id::int               as task_assignee_id
        , wst.value:assignee_type::int             as task_assignee_type
        , wst.value:display_position::int          as task_display_position
        , wst.value:due_date::timestamp            as task_due_date
        , wst.value:calculated_due_date::timestamp as task_calculated_due_date
        , wst.value:completion_date::timestamp     as task_completion_date
        , wst.value:description::varchar           as task_description
        , wst.value:deleted::int                   as task_deleted
        , wst.value:created_at::timestamp          as task_created_at
        , wst.value:updated_at::timestamp          as task_updated_at
        , ws._created_at::timestamp                as _created_at
    from workflow_steps_cte as ws
    , lateral flatten(input => ws.workflow_step_tasks) as wst
)

, workflow_step_outcomes_cte as (
    select
        ws.workflow_id                         as workflow_id
        , ws.step_id                           as step_id
        , wso.value:id::int                    as outcome_id
        , wso.value:name::varchar              as outcome_name
        , wso.value:workflow_step_id::int      as outcome_workflow_step_id
        , wso.value:next_workflow_step_id::int as outcome_next_workflow_step_id
        , wso.value:deleted::int               as outcome_deleted
        , wso.value:created_at::timestamp      as outcome_created_at
        , wso.value:updated_at::timestamp      as outcome_updated_at
        , ws._created_at::timestamp            as _created_at
    from workflow_steps_cte as ws
    , lateral flatten(input => ws.workflow_step_outcomes) as wso
)

, linked_contacts_cte as (
    select
        w.json:id::int                   as workflow_id
        , lc.value:type::varchar         as contact_type
        , lc.value:first_name::varchar   as contact_first_name
        , lc.value:middle_name::varchar  as contact_middle_name
        , lc.value:last_name::varchar    as contact_last_name
        , lc.value:company_name::varchar as contact_company_name
        , lc.value:full_name::varchar    as contact_full_name
        , lc.value:nickname::varchar     as contact_nickname
        , lc.value:suffix_id::varchar    as contact_suffix_id
        , lc.value:suffix::varchar       as contact_suffix
        , lc.value:job_title::varchar    as contact_job_title
        , lc.value:favorite::int         as contact_favorite
        , lc.value:pronouns::varchar     as contact_pronouns
        , lc.value:deleted::int          as contact_deleted
        , lc.value:created_at::timestamp as contact_created_at
        , lc.value:updated_at::timestamp as contact_updated_at
        , lc.value:contact_id::int       as contact_id
        , w._created_at                  as _created_at
    from {{ src }} as w
    , lateral flatten(input => w.json:linked_contacts) as lc
)

select
    -- top level fields
    w.json:id::int                         as workflow_id
    , w.json:workflow_template_id::varchar as workflow_template_id
    , w.json:name::varchar                 as workflow_name
    , w.json:due_date::timestamp           as workflow_due_date
    , w.json:current_step_id::int          as workflow_current_step_id
    , w.json:status::int                   as workflow_status
    , w.json:assignee_id::int              as workflow_assignee_id
    , w.json:assignee_type::varchar        as workflow_assignee_type
    , w.json:completion_date::timestamp    as workflow_completion_date
    , w.json:description::varchar          as workflow_description
    , w.json:category_id::int              as workflow_category_id
    , w.json:category::varchar             as workflow_category
    , w.json:exclude_weekends::int         as workflow_exclude_weekends
    , w.json:deleted::int                  as workflow_deleted
    , w.json:created_at::timestamp         as workflow_created_at
    , w.json:updated_at::timestamp         as workflow_updated_at
    , w.json:_effective_at::timestamp      as workflow_effective_at

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
    , wst.task_id                          as task_id
    , wst.task_name                        as task_name
    , wst.task_workflow_step_id            as task_workflow_step_id
    , wst.parent_step_task_id              as task_parent_step_task_id
    , wst.task_assignee_id                 as task_assignee_id
    , wst.task_assignee_type               as task_assignee_type
    , wst.task_display_position            as task_display_position
    , wst.task_due_date                    as task_due_date
    , wst.task_calculated_due_date         as task_calculated_due_date
    , wst.task_completion_date             as task_completion_date
    , wst.task_description                 as task_description
    , wst.task_deleted                     as task_deleted
    , wst.task_created_at                  as task_created_at
    , wst.task_updated_at                  as task_updated_at

    -- workflow step outcomes
    , wso.outcome_id                       as outcome_id
    , wso.outcome_name                     as outcome_name
    , wso.outcome_workflow_step_id         as outcome_workflow_step_id
    , wso.outcome_next_workflow_step_id    as outcome_next_workflow_step_id
    , wso.outcome_deleted                  as outcome_deleted
    , wso.outcome_created_at               as outcome_created_at
    , wso.outcome_updated_at               as outcome_updated_at

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

    , {{ col_is_head(reference=src,
     reference_date_col='_effective_at::date', source_date_col='_effective_at::date') }}
    , w._effective_at::timestamp_ltz       as effective_at
    , w._created_at::timestamp_ltz         as _source_loaded_at
    , w._source_file::varchar(200)         as _source_file

from {{ src }} as w
left join workflow_steps_cte as ws
    on w.json:id::int = ws.workflow_id
    and w._created_at = ws._created_at
left join workflow_step_tasks_cte as wst
    on ws.step_id = wst.task_workflow_step_id
    and ws._created_at = wst._created_at
left join workflow_step_outcomes_cte as wso
    on ws.step_id = wso.outcome_workflow_step_id
    and ws._created_at = wso._created_at
left join linked_contacts_cte as lc
    on w.json:id::int = lc.workflow_id
    and w._created_at = lc._created_at
