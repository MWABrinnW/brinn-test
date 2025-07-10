select
    iproductid::int                    as i_product_id
    , iproductname::text               as i_product_name
    , vehicleid::int                   as vehicle_id
    , ticker::text                     as ticker
    , cusip::text                      as cusip
    , imanagerid::int                  as i_manager_id
    , morningstarproductid::text       as morningstar_productid
    , to_boolean(isdeleted::text)::int as is_deleted
    , closedate::timestamp_ntz         as close_date
    , liquidated::text                 as liquidated

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                  as _extracted_at
    , file_type::text                  as file_type
    , _created_at::timestamp           as _created_at
    , _source_file::text               as _source_file
from {{ source('cambak', 'cbiproduct') }}
