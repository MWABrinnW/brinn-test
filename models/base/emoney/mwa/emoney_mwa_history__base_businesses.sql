select
    _data:clientid::text(200)                                                        as clientid
    , _data:factid::text(200)                                                        as factid
    , _data:type::text(200)                                                          as type--noqa: RF04
    , _data:typecode::text(200)                                                      as typecode
    , _data:subtype::text(200)                                                       as subtype
    , _data:name::text(200)                                                          as name--noqa: RF04
    , _data:amount::int                                                              as amount
    , to_timestamp_ntz((_data:"amountasof"::text(200)) , 'MM/DD/YYYY HH12:MI:SS AM') as amountasof
    , nullif(_data:costbasis , '')::int                                              as costbasis
    , nullif(_data:country , '')::text(200)                                          as country
    , nullif(_data:remcapitalcommitment , '')::text(200)                             as remcapitalcommitment
    , nullif(_data:valuationdate , '')::text(200)                                    as valuationdate
    , nullif(_data:initialinvestmentdate , '')::text(200)                            as initialinvestmentdate
    , nullif(_data:capitalcommitment , '')::text(200)                                as capitalcommitment
    , nullif(_data:capitalcalled , '')::text(200)                                    as capitalcalled
    , nullif(_data:nonrecallablecapitaldistributed , '')::text(200)                  as nonrecallablecapitaldistributed
    , nullif(_data:recallablecapitaldistributed , '')::text(200)                     as recallablecapitaldistributed
    , nullif(_data:totalcapitaldistributed , '')::text(200)                          as totalcapitaldistributed
    , _created_at::date                                                              as record_date
    , _created_at::timestampntz                                                      as record_datetime
    , effective_date::date                                                           as effective_date
    , _created_at::timestampntz                                                      as _created_at
    , _source_file::text(200)                                                        as _source_file
    , _id::int                                                                       as _id
from {{ source('emoney_mwa', 'businesses') }}
