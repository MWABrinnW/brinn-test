select
    prod.system_name::text                     as system_name
    , prod.system_instance::text               as system_instance
    , prod.system_key::text                    as system_key
    , prod.firm_source::text                   as firm_source
    , prod.pkproduct                           as product_id
    , coalesce(prod.ticker , prod.cusip)::text as symbol
    , prod.cusip::text                         as cusip
    , prod.ticker::text                        as ticker
    , case
        when prod.cusip = prod.ticker
            then 1
        else 0
    end::int                                   as is_ticker_cusip
    , prod.iscustodialcash::int                as is_custodial_cash
    , prod.ismanaged::int                      as is_product_managed
    , prod.productname::text                   as product_name
    , prod.productnameoverride::text           as product_name_override
    , prod.producttypename::text               as product_type
    , pc.pkproductclass::text                  as product_class_id
    , prod.productclass::text                  as product_class
    , prod.productclass::text                  as asset_class
    , pc.description::text                     as product_class_description
    , pc.category::text                        as product_class_category
    , pc.subcategory::text                     as product_class_subcategory
    , pcat.pkproductcategory::text             as product_category_id
    , pcat.categoryabbr::text                  as product_category_abbreviation
    , pcat.categoryname::text                  as product_category
    , pcat.parentcategory::text                as product_parent_category_abbreviation
    --, prod.productclass::text                  as product_class_description
    --, pc.name::text                            as product_class_name

    -- Orion Product Description Provider Id (text not yet in RS)
    -- pc.fkProductDescriptionProvider

    , prod.fkalclient::int                     as fkalclient
    , prod._created_at::timestamp_ntz          as _created_at
    , prod._extracted_at::timestamp_ntz        as _source_loaded_at
    , prod.createddate                         as createddate
    , prod._source_file::text                  as _source_file
from {{ ref('orion__base_vw_product') }} as prod
left join {{ ref('orion__base_vw_productclass') }} as pc
    on prod.fkalclient = pc.fkalclient
    and prod.fkproductclass = pc.pkproductclass
left join {{ ref('orion__base_vw_productcategory') }} as pcat
    on pc.fkalclient = pcat.fkalclient
    and pc.fkproductcategory = pcat.pkproductcategory
where 1 = 1
