select
    advisoryexposurecount::integer                      as advisory_exposure_count
    , aliasname::text                                   as alias_name
    , approachid::text                                  as approach_id
    , approachstring::text                              as approach_string
    , assetcategoryid::text                             as asset_category_id
    , assetcategorystring::text                         as asset_category_string
    , assetclassid::text                                as asset_class_id
    , assetclassstring::text                            as asset_class_string
    , firmid::integer                                   as firm_id
    , guidanceid::integer                               as guidance_id
    , guidancestring::text                              as guidance_string
    , to_boolean(hasactiveiproductflags::text)::int     as has_active_iproduct_flags
    , to_boolean(hasiproductdocuments::text)::int       as has_iproduct_documents
    , to_boolean(hasiproductflags::text)::int           as has_iproduct_flags
    , to_boolean(hasmeetingscheduled::text)::int        as has_meeting_scheduled
    , to_boolean(hasrecentiproductdocuments::text)::int as has_recent_iproduct_documents
    , imanagerid::integer                               as imanager_id
    , imanagername::text                                as imanager_name
    , investmentstyleid::text                           as investment_style_id
    , investmentstylestring::text                       as investment_style_string
    , iproductgroupid::text                             as iproduct_group_id
    , iproductid::integer                               as iproduct_id
    , iproductname::text                                as iproduct_name
    , to_boolean(isclosedproduct::text)::int            as is_closed_product
    , markettypeid::text                                as market_type_id
    , markettypestring::text                            as market_type_string
    , nonadvisoryexposurecount::integer                 as nonadvisory_exposure_count
    , ratingdate::text                                  as rating_date
    , ratingnote::text                                  as rating_note
    , recommendationid::integer                         as recommendation_id
    , recommendationstring::text                        as recommendation_string
    , regionid::text                                    as region_id
    , regionstring::text                                as region_string
    , sponsorid::text                                   as sponsorid
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
from {{ source('cambak', 'iproducttrackinginfo') }}
