select
    accountid::integer                                  as account_id
    , accountinvestmentid::integer                      as account_investment_id
    , accountname::text                                 as account_name
    , approachid::integer                               as approach_id
    , approachstring::text                              as approach_string
    , assetcategoryid::text                             as asset_category_id
    , assetcategorystring::text                         as asset_category_string
    , assetclassid::text                                as asset_class_id
    , assetclassstring::text                            as asset_classs_tring
    , clientid::integer                                 as client_id
    , clientname::text                                  as client_name
    , cusip::text                                       as cusip
    , effectiveassetcategoryid::integer                 as effective_asset_category_id
    , effectiveassetclassid::integer                    as effective_asset_class_id
    , effectiveinvestmentstyleid::integer               as effective_investment_style_id
    , effectiveregionid::text                           as effective_region_id
    , externalid::text                                  as external_id
    , firmid::integer                                   as firm_id
    , fundingdate::text                                 as funding_date
    , guidanceid::integer                               as guidance_id
    , guidancestring::text                              as guidance_string
    , to_boolean(hasactiveiproductflags::text)::int     as has_active_iproduct_flags
    , to_boolean(hasiproductdocuments::text)::int       as has_iproduct_documents
    , to_boolean(hasiproductflags::text)::int           as has_iproduct_flags
    , to_boolean(hasrecentiproductdocuments::text)::int as has_recent_iproduct_documents
    , imanagerid::integer                               as imanager_id
    , imanagername::text                                as imanager_name
    , investmentstyleid::text                           as investment_style_id
    , investmentstylestring::text                       as investment_style_string
    , iproductid::integer                               as iproduct_id
    , iproductname::text                                as iproduct_name
    , ipstarget::text                                   as ips_target
    , to_boolean(isclosed::text)::int                   as is_closed
    , to_boolean(isdeleted::text)::int                  as is_deleted
    , to_boolean(isproductdeleted::text)::int           as is_product_deleted
    , managementapproachid::integer                     as management_approach_id
    , managementapproachstring::text                    as management_approach_string
    , managerweburl::text                               as manager_web_url
    , markettypeid::integer                             as market_type_id
    , markettypestring::text                            as market_type_string
    , maxpercent::text                                  as max_ercent
    , minpercent::text                                  as minpercent
    , to_boolean(nonadvisory::text)::int                as nonadvisory
    , notes::text                                       as notes
    , planid::integer                                   as plan_id
    , planname::text                                    as plan_name
    , ratingdate::text                                  as rating_date
    , ratingnote::text                                  as rating_note
    , recommendationid::integer                         as recommendation_id
    , recommendationstring::text                        as recommendation_string
    , regionid::text                                    as region_id
    , regionstring::text                                as region_string
    , sponsorstring::text                               as sponsor_string
    , ticker::text                                      as ticker
    , vehicleid::integer                                as vehicle_id
    , vehiclestring::text                               as vehicle_string
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                   as _extracted_at
    , file_type::text                                   as file_type
    , _created_at::timestamp                            as _created_at
    , _source_file::text                                as _source_file
from {{ source('cambak', 'accountinvestmentex') }}
