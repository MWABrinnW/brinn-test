select
    accountinvestmentid::int                                           as account_investment_id
    , accountid::int                                                   as account_id
    , iproductid::int                                                  as i_productid
    , minpercent::number(20 , 2)                                       as min_percent
    , maxpercent::number(20 , 2)                                       as max_percent
    , ipstarget::number(20 , 2)                                        as ips_target
    , firmid::int                                                      as firm_id
    , regionid::int                                                    as region_id
    , assetclassid::int                                                as asset_class_id
    , assetcategoryid::int                                             as asset_categoryid
    , to_timestamp_ntz(fundingdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as funding_date
    , investmentstyleid::int                                           as investment_style_id
    , to_boolean(isdeleted::text)::int                                 as is_deleted
    , createduserid::int                                               as created_userid
    , to_timestamp_ntz(createddate::text , 'MM/DD/YYYY HH12:MI:SS AM') as created_date
    , deleteduserid::int                                               as deleted_userid
    , to_timestamp_ntz(deleteddate::text , 'MM/DD/YYYY HH12:MI:SS AM') as deleted_date
    , to_boolean(nonadvisory::text)::int                               as non_advisory
    , notes::text                                                      as notes
    , externalid::int                                                  as externalid

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                  as _extracted_at
    , file_type::text                                                  as file_type
    , _created_at::timestamp                                           as _created_at
    , _source_file::text                                               as _source_file
from {{ source('cambak', 'cbaccountinvestment') }}
