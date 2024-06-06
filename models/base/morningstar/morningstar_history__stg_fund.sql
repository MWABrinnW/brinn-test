select
    _data:mstarid::text(200)                                                   as mstarid
    , _data:cusip::text(200)                                                   as cusip
    , _data:ticker::text(200)                                                  as ticker
    , _data:fundstandardname::text(200)                                        as fundstandardname
    , _data:fundname::text(200)                                                as fundname
    , _data:securitytype::text(200)                                            as securitytype
    , nullif(trim(_data:shareclasstype) , '')::text(200)                       as shareclasstype
    , _data:globalcategoryname::text(200)                                      as globalcategoryname
    , _data:categoryname::text(200)                                            as categoryname
    , nullif(trim(_data:marketcapital) , '')::dec(20 , 6)                      as marketcapital
    , nullif(trim(_data:equitystylebox) , '')::int                             as equitystylebox
    , nullif(trim(_data:equitystyleboxname) , '')::text(200)                   as equitystyleboxname
    , nullif(trim(_data:equitystyleboxshort) , '')::int                        as equitystyleboxshort
    , nullif(trim(_data:equitystyleboxshortname) , '')::text(200)              as equitystyleboxshortname
    , nullif(trim(_data:fixedincomestylebox) , '')::int                        as fixedincomestylebox
    , nullif(trim(_data:fixedincomestyleboxname) , '')::text(200)              as fixedincomestyleboxname
    , nullif(trim(_data:percentilerank3mth) , '')::int                         as percentilerank3mth
    , nullif(trim(_data:percentilerankytd) , '')::int                          as percentilerankytd
    , nullif(trim(_data:percentilerank5yr) , '')::int                          as percentilerank5yr
    , nullif(trim(_data:percentilerank10yr) , '')::int                         as percentilerank10yr
    , nullif(trim(_data:percentilerank15yr) , '')::int                         as percentilerank15yr
    , nullif(trim(_data:return1mth) , '')::dec(20 , 6)                         as return1mth
    , nullif(trim(_data:return3mth) , '')::dec(20 , 6)                         as return3mth
    , nullif(trim(_data:return5yr) , '')::dec(20 , 6)                          as return5yr
    , nullif(trim(_data:return10yr) , '')::dec(20 , 6)                         as return10yr
    , nullif(trim(_data:return15yr) , '')::dec(20 , 6)                         as return15yr
    , nullif(trim(_data:bondlong) , '')::dec(20 , 6)                           as bondlong
    , nullif(trim(_data:bondnet) , '')::dec(20 , 6)                            as bondnet
    , nullif(trim(_data:bondshort) , '')::dec(20 , 6)                          as bondshort
    , nullif(trim(_data:cashlong) , '')::dec(20 , 6)                           as cashlong
    , nullif(trim(_data:cashnet) , '')::dec(20 , 6)                            as cashnet
    , nullif(trim(_data:cashshort) , '')::dec(20 , 6)                          as cashshort
    , nullif(trim(_data:convertiblelong) , '')::dec(20 , 6)                    as convertiblelong
    , nullif(trim(_data:convertiblenet) , '')::dec(20 , 6)                     as convertiblenet
    , nullif(trim(_data:convertibleshort) , '')::dec(20 , 6)                   as convertibleshort
    , nullif(trim(_data:otherlong) , '')::dec(20 , 6)                          as otherlong
    , nullif(trim(_data:othernet) , '')::dec(20 , 6)                           as othernet
    , nullif(trim(_data:othershort) , '')::dec(20 , 6)                         as othershort
    , nullif(trim(_data:portfoliodate) , '')::date                             as portfoliodate
    , nullif(trim(_data:preferredlong) , '')::dec(20 , 6)                      as preferredlong
    , nullif(trim(_data:preferrednet) , '')::dec(20 , 6)                       as preferrednet
    , nullif(trim(_data:preferredshort) , '')::dec(20 , 6)                     as preferredshort
    , nullif(trim(_data:stocklong) , '')::dec(20 , 6)                          as stocklong
    , nullif(trim(_data:stocknet) , '')::dec(20 , 6)                           as stocknet
    , nullif(trim(_data:stockshort) , '')::dec(20 , 6)                         as stockshort
    , nullif(trim(_data:largeblend) , '')::dec(20 , 6)                         as largeblend
    , nullif(trim(_data:largegrowth) , '')::dec(20 , 6)                        as largegrowth
    , nullif(trim(_data:largevalue) , '')::dec(20 , 6)                         as largevalue
    , nullif(trim(_data:midblend) , '')::dec(20 , 6)                           as midblend
    , nullif(trim(_data:midgrowth) , '')::dec(20 , 6)                          as midgrowth
    , nullif(trim(_data:midvaluev) , '')::dec(20 , 6)                          as midvalue
    , nullif(trim(_data:smallblen) , '')::dec(20 , 6)                          as smallblen
    , nullif(trim(_data:smallgrowth) , '')::dec(20 , 6)                        as smallgrowth
    , nullif(trim(_data:smallvalue) , '')::dec(20 , 6)                         as smallvalue
    , nullif(trim(_data:netmargin) , '')::dec(20 , 6)                          as netmargin
    , nullif(trim(_data:totalmarketvaluelong) , '')::dec(20 , 6)               as totalmarketvaluelong
    , nullif(trim(_data:totalmarketvaluenet) , '')::dec(20 , 6)                as totalmarketvaluenet
    , nullif(trim(_data:totalmarketvalueshort) , '')::dec(20 , 6)              as totalmarketvalueshort
    , nullif(trim(_data:totalyieldlong) , '')::dec(20 , 6)                     as totalyieldlong
    , _data:fundnetassets::int                                                 as fundnetassets
    , nullif(trim(_data:netassetsdate) , '')::date                             as netassetsdate
    , _data:normalizedfundnetassets::int                                       as normalizedfundnetassets
    , nullif(trim(_data:countryexposure_country) , '')::text(200)              as countryexposure_country
    , nullif(trim(_data:countryexposure_value) , '')::dec(20 , 6)              as countryexposure_value
    , nullif(trim(_data:countryexposure_country_2) , '')::text(200)            as countryexposure_country_2
    , nullif(trim(_data:countryexposure_value_2) , '')::dec(20 , 6)            as countryexposure_value_2
    , nullif(trim(_data:countryexposure_country_3) , '')::text(200)            as countryexposure_country_3
    , nullif(trim(_data:countryexposure_value_3) , '')::dec(20 , 6)            as countryexposure_value_3
    , nullif(trim(_data:countryexposure_country_4) , '')::text(200)            as countryexposure_country_4
    , nullif(trim(_data:countryexposure_value_4) , '')::dec(20 , 6)            as countryexposure_value_4
    , nullif(trim(_data:countryexposure_country_5) , '')::text(200)            as countryexposure_country_5
    , nullif(trim(_data:countryexposure_value_5) , '')::dec(20 , 6)            as countryexposure_value_5
    , nullif(trim(_data:countryexposurebond_country) , '')::text(200)          as countryexposurebond_country
    , nullif(trim(_data:countryexposurebond_value) , '')::dec(20 , 6)          as countryexposurebond_value
    , nullif(trim(_data:countryexposurebond_country_2) , '')::text(200)        as countryexposurebond_country_2
    , nullif(trim(_data:countryexposurebond_value_2) , '')::dec(20 , 6)        as countryexposurebond_value_2
    , nullif(trim(_data:countryexposurebond_country_3) , '')::text(200)        as countryexposurebond_country_3
    , nullif(trim(_data:countryexposurebond_value_3) , '')::dec(20 , 6)        as countryexposurebond_value_3
    , nullif(trim(_data:countryexposurebond_country_4) , '')::text(200)        as countryexposurebond_country_4
    , nullif(trim(_data:countryexposurebond_value_4) , '')::dec(20 , 6)        as countryexposurebond_value_4
    , nullif(trim(_data:countryexposurebond_country_5) , '')::text(200)        as countryexposurebond_country_5
    , nullif(trim(_data:countryexposurebond_value_5) , '')::dec(20 , 6)        as countryexposurebond_value_5
    , nullif(trim(_data:countryexposureconvertible_country) , '')::text(200)   as countryexposureconvertible_country
    , nullif(trim(_data:countryexposureconvertible_value) , '')::dec(20 , 6)   as countryexposureconvertible_value
    , nullif(trim(_data:countryexposureconvertible_country_2) , '')::text(200) as countryexposureconvertible_country_2
    , nullif(trim(_data:countryexposureconvertible_value_2) , '')::dec(20 , 6) as countryexposureconvertible_value_2
    , nullif(trim(_data:countryexposureconvertible_country_3) , '')::text(200) as countryexposureconvertible_country_3
    , nullif(trim(_data:countryexposureconvertible_value_3) , '')::dec(20 , 6) as countryexposureconvertible_value_3
    , nullif(trim(_data:countryexposureconvertible_country_4) , '')::text(200) as countryexposureconvertible_country_4
    , nullif(trim(_data:countryexposureconvertible_value_4) , '')::dec(20 , 6) as countryexposureconvertible_value_4
    , nullif(trim(_data:countryexposureconvertible_country_5) , '')::text(200) as countryexposureconvertible_country_5
    , nullif(trim(_data:countryexposureconvertible_value_5) , '')::dec(20 , 6) as countryexposureconvertible_value_5
    , nullif(trim(_data:countryexposureequity_country) , '')::text(200)        as countryexposureequity_country
    , nullif(trim(_data:countryexposureequity_value) , '')::dec(20 , 6)        as countryexposureequity_value
    , nullif(trim(_data:countryexposureequity_country_2) , '')::text(200)      as countryexposureequity_country_2
    , nullif(trim(_data:countryexposureequity_value_2) , '')::dec(20 , 6)      as countryexposureequity_value_2
    , nullif(trim(_data:countryexposureequity_country_3) , '')::text(200)      as countryexposureequity_country_3
    , nullif(trim(_data:countryexposureequity_value_3) , '')::dec(20 , 6)      as countryexposureequity_value_3
    , nullif(trim(_data:countryexposureequity_country_4) , '')::text(200)      as countryexposureequity_country_4
    , nullif(trim(_data:countryexposureequity_value_4) , '')::dec(20 , 6)      as countryexposureequity_value_4
    , nullif(trim(_data:countryexposureequity_country_5) , '')::text(200)      as countryexposureequity_country_5
    , nullif(trim(_data:countryexposureequity_value_5) , '')::dec(20 , 6)      as countryexposureequity_value_5
    , mtype::text(200)                                                         as mtype
    , _created_at::date                                                        as record_date
    , _created_at::timestampntz                                                as record_datetime
    , effective_date::date                                                     as effective_date
    , {{ col_is_head(reference=source('morningstar' ~ src, 'fund')) }}
    , _created_at::timestampntz                                                as _created_at
    , _source_file::text(200)                                                  as _source_file
    , _id::int                                                                 as _id
from {{ source('morningstar','fund') }}
