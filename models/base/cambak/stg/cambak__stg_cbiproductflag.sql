{% set src = source('cambak', 'cbiproductflag') %}
select
    iproductflagid::int                   as i_product_flag_id
    , iproductid::int                     as i_product_id
    , flagcategoryid::int                 as flag_category_id
    , flagtypeid::int                     as flag_type_id
    , to_boolean(isactive::text)::boolean as is_active
    , sponsorid::int                      as sponsor_id
    , effectivedate::timestamp_ntz        as effective_date
    , flagnote::text                      as flag_note
    , firmid::int                         as firm_id
    , userid::int                         as user_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                     as _extracted_at
    , file_type::text                     as file_type
    , _created_at::timestamp              as _created_at
    , _source_file::text                  as _source_file
from {{ src }}
