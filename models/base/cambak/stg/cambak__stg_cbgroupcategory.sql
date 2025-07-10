select
    groupcategoryid::int               as group_category_id
    , firmid::int                      as firm_id
    , categoryname::text               as category_name
    , groupid::int                     as groupid
    , parentcategoryid::int            as parent_category_id
    , entitytypeid::int                as entity_type_id
    , to_boolean(isdeleted::text)::int as is_deleted
    , deleteduserid::int               as deleted_user_id
    , deleteddate::timestamp_ntz       as deleted_date

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                  as _extracted_at
    , file_type::text                  as file_type
    , _created_at::timestamp           as _created_at
    , _source_file::text               as _source_file
from {{ source('cambak', 'cbgroupcategory') }}
