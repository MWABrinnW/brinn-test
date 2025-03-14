select
    templaterelatedattributeid::int     as template_related_attribute_id
    , groupcategorytemplateid::int      as group_category_template_id
    , attributename::text               as attribute_name
    , controltypeid::int                as control_type_id
    , picklistid::int                   as picklist_id
    , relatedattributeorder::int        as related_attribute_order
    , masterid::int                     as master_id
    , to_boolean(isrequired::text)::int as is_required
    , pickliststringid::int             as picklist_string_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                   as _extracted_at
    , file_type::text                   as file_type
    , _created_at::timestamp            as _created_at
    , _source_file::text                as _source_file
from {{ source('cambak', 'cbgroupcategorytemplaterelatedattribute') }}
