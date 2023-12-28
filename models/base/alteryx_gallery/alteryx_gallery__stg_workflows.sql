select
    json:id::text(200)                                as id
    , json:name::text(200)                            as name
    , json:versions[0]:details:fileName::text(200)    as file_name
    , json:dateCreated::timestamp                     as created_date
    , json:publishedVersionNumber::int                as published_version_number
    , json:ownerId::text(200)                         as owner_id
    , json:versions[0]:detail:author::text(200)       as author
    , json:versions[0]:packageWorkflowType::text(200) as package_workflow_type
    , json:executionMode::text(200)                   as execution_mode
    , json:isAmp::boolean::int                        as is_amp
    , json:isPublic::boolean::int                     as is_public
    , json:othersMayDownload::boolean::int            as others_may_download
    , json:versions[0]:comments::text(1000)           as comments
    , json:versions[0]:detail:description::text(1000) as description
    , json:versions[0]:detail:url::text(200)          as url
    , json:versions[0]:detail:urlText::text(200)      as url_text
    , _created_at                                     as _created_at
from {{ source('alteryx_gallery', 'alteryx_workflows_parsed') }}
where 1 = 1
    and _source_file ilike 'workflows.json%'
order by name
