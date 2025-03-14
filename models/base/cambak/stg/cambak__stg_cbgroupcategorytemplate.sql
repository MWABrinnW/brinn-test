select
    groupcategorytemplateid::int                                       as group_category_template_id
    , groupcategoryid::int                                             as group_category_id
    , subject::text                                                    as subject
    , templatecontent::text                                            as template_content
    , createduserid::int                                               as created_user_id
    , to_timestamp_ntz(createddate::text , 'MM/DD/YYYY HH12:MI:SS AM') as created_date
    , entitytypeid::int                                                as entity_type_id
    , meetinggroupcategorytemplateid::int                              as meeting_group_category_template_id
    , templatedescription::text                                        as template_description
    , templateinstructions::text                                       as template_instructions

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                  as _extracted_at
    , file_type::text                                                  as file_type
    , _created_at::timestamp                                           as _created_at
    , _source_file::text                                               as _source_file
from {{ source('cambak', 'cbgroupcategorytemplate') }}
