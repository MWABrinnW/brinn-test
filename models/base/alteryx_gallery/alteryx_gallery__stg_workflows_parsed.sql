select
    json:id::text(200)                             as id
    , json:name::text(200)                         as name
    --, json:publishedVersionNumber::int             as published_version_number

    , json:tool::text(200)                         as tool
    , json:tool_id::int                            as tool_id
    , json:plugin::text(200)                       as plugin
    , json:x::int                                  as x
    , json:y::int                                  as y

    , json:annotation::text(1000)                  as annotation

    , nullif(json:source_tables::text , '[]')      as source_tables
    , nullif(json:destination_tables::text , '[]') as destination_tables
    , json:source_query::text                      as source_query

    , json:box_file_id::text(200)                  as box_file_id
    , json:source_box_file_id::text(200)           as source_box_file_id
    , json:destination_box_file_id::text(200)      as destination_box_file_id

    , json:source_smartsheet_id::text(200)         as source_smartsheet_id
    , json:destination_smartsheet_id::text(200)    as destination_smartsheet_id

    , json:tableau_data_source_name::text(200)     as tableau_data_source_name

    , json:orion_query_id::int                     as orion_query_id

    , json:macro_name::text(200)                   as macro_name
    , json:select_fields::text                     as select_fields
    , json:left_join_fields::text                  as left_join_fields
    , json:right_join_fields::text                 as right_join_fields
from {{ source('alteryx_gallery_datalake', 'alteryx_workflows_parsed') }}
where 1 = 1
    and _source_file ilike 'workflow_tools.json%'
order by name
