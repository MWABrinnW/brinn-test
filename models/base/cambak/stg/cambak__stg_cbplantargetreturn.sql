{% set src = source('cambak', 'cbplantargetreturn') %}
select
    plantargetreturnid::int                                              as plan_target_return_id
    , planid::int                                                        as plan_id
    , to_timestamp_ntz(effectivedate::text , 'MM/DD/YYYY HH12:MI:SS AM') as effective_date
    , targetreturn::int                                                  as target_return
    , notes::text                                                        as notes
    , to_timestamp_ntz(createddate::text , 'MM/DD/YYYY HH12:MI:SS AM')   as created_date
    , createdby::int                                                     as created_by

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                    as _extracted_at
    , file_type::text                                                    as file_type
    , _created_at::timestamp                                             as _created_at
    , _source_file::text                                                 as _source_file
from {{ src }}
