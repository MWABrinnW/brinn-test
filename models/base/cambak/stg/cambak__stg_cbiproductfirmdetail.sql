select
    approachid::int             as approach_id
    , managementapproachid::int as management_approach_id
    , regionid::int             as region_id
    , investmentstyleid::int    as investment_style_id
    , firmid::int               as firm_id
    , markettypeid::int         as market_typeid
    , iproductgroupid::text     as i_product_group_id
    , iproductid::int           as i_productid
    , assetcategoryid::int      as asset_categoryid
    , assetclassid::int         as asset_class_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                           as _extracted_at
    , file_type::text           as file_type
    , _created_at::timestamp    as _created_at
    , _source_file::text        as _source_file
from {{ source('cambak', 'cbiproductfirmdetail') }}
