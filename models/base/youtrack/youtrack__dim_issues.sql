with cte_custom_fields as (
    select
        issues.id                                                                                  as id
        , max(case when cf.value:"name" = 'Group' then cf.value:"value" end)::variant              as group_name
        , max(case when cf.value:"name" = 'Type' then cf.value:"value":"name" end)::text(200)      as type--noqa: RF04
        , max(case when cf.value:"name" = 'State' then cf.value:"value":"name" end)::text(200)     as state
        , max(case when cf.value:"name" = 'Priority' then cf.value:"value":"name" end)::text(200)  as priority
        , max(case when cf.value:"name" = 'Status' then cf.value:"value":"name" end)::text(200)    as status
        , max(case when cf.value:"name" = 'Stakeholder' then cf.value:"value" end::variant)        as stakeholders
        , max(case when cf.value:"name" = 'Assignee' then cf.value:"value":"name" end)::text(200)  as assignee
        , max(case when cf.value:"name" = 'Start Date' then cf.value:"value" end)::text            as start_date
        , max(case when cf.value:"name" = 'End Date' then cf.value:"value" end)::text              as end_date
        , max(case when cf.value:"name" = 'Due Date' then cf.value:"value" end)::text              as due_date
        , max(case when cf.value:"name" = 'Initial Estimate' then cf.value:"value" end)::text(200) as initial_estimate
        , max(case when cf.value:"name" = 'Final Estimate' then cf.value:"value" end)::text(200)   as final_estimate
        , max(case when cf.value:"name" = 'System' then cf.value:"value":"name" end)::text(200)    as system--noqa: RF04
        , max(case when cf.value:"name" = 'Support Type' then cf.value:"value" end)::text(200)     as support_type
        , max(case when cf.value:"name" = 'Business Unit' then cf.value:"value" end)::text(200)    as business_unit
    from {{ ref('youtrack__stg_issues') }} as issues
    , table(flatten(INPUT => issues.custom_fields)) as cf
    group by issues.id
)

select
    src.id                                                  as id
    , src.issue_id                                          as issue_id
    , src.summary                                           as summary
    , src.description                                       as description
    , src.reporter                                          as reporter
    , src.created_at                                        as created_at
    , src.updated_at                                        as updated_at
    , src.updated_by                                        as updated_by
    , src.resolved_at                                       as resolved_at
    , src.parent_issue_id                                   as parent_issue_id
    , src.project_name                                      as project_name
    , src.project_id                                        as project_id
    , src.project_description                               as project_description
    , array_construct_compact(
        cf.group_name[0]:"name"::text
        , cf.group_name[1]:"name"::text
        , cf.group_name[2]:"name"::text
        , cf.group_name[3]:"name"::text
        , cf.group_name[4]:"name"::text
        , cf.group_name[5]:"name"::text
    )                                                       as groups
    , cf.type                                               as type--noqa: RF04
    , cf.priority                                           as priority
    , cf.state                                              as state
    , cf.status                                             as status
    , array_construct_compact(
        cf.stakeholders[0]:fullName::text
        , cf.stakeholders[1]:fullName::text
        , cf.stakeholders[2]:fullName::text
        , cf.stakeholders[3]:fullName::text
    )                                                       as stakeholders
    , cf.assignee                                           as assignee
    , to_date(to_timestamp_tz((cf.start_date::int) / 1000)) as start_date
    , to_date(to_timestamp_tz((cf.end_date::int) / 1000))   as end_date
    , to_date(to_timestamp_tz((cf.due_date::int) / 1000))   as due_date
    , cf.system                                             as system--noqa: RF04
    , cf.support_type                                       as support_type
    , cf.business_unit                                      as business_unit
    , src.links                                             as links
    , src.subtasks                                          as subtasks
    , src.tags                                              as tags
    , src.visibility                                        as visibility
    , src.watchers                                          as watchers
    , src.wikified_description                              as wikified_description
    , src.comments_count                                    as comments_count
    , src.is_draft                                          as is_draft
    , src._created_at                                       as _created_at
    , src._updated_at                                       as _updated_at
    , src._id                                               as _id
from {{ ref('youtrack__stg_issues') }} as src
left join cte_custom_fields as cf
    on src.id = cf.id
order by created_at desc
