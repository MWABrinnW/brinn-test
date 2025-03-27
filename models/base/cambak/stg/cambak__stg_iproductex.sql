select
    assetcategoryid::text                    as asset_category_id
    , assetcategorystring::text              as asset_category_string
    , assetclassid::text                     as asset_class_id
    , assetclassstring::text                 as asset_class_string
    , cusip::text                            as cusip
    , firmid::integer                        as firm_id
    , imanagerid::integer                    as imanager_id
    , imanagername::text                     as imanager_name
    , investmentstyleid::text                as investment_style_id
    , investmentstylestring::text            as investment_style_string
    , iproductgroupid::text                  as iproduct_group_id
    , iproductid::integer                    as iproduct_id
    , iproductname::text                     as iproduct_name
    , to_boolean(isclosedproduct::text)::int as is_closed_product
    , to_boolean(isdeleted::text)::int       as is_deleted
    , managementapproachid::text             as management_approach_id
    , managementapproachstring::text         as management_approach_string
    , markettypeid::text                     as market_type_id
    , markettypestring::text                 as market_types_tring
    , regionid::text                         as region_id
    , regionstring::text                     as region_string
    , ticker::text                           as ticker
    , vehicleid::integer                     as vehicle_id
    , vehiclestring::text                    as vehicle_string
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                        as _extracted_at
    , file_type::text                        as file_type
    , _created_at::timestamp                 as _created_at
    , _source_file::text                     as _source_file
from {{ source('cambak', 'iproductex') }}
