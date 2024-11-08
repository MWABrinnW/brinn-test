select
    _data:clientid::text(200)                                                             as clientid
    , _data:advisorid::text(200)                                                          as advisorid
    , _data:clientname::text(200)                                                         as clientname
    , _data:firstname::text(200)                                                          as firstname--noqa: RF04
    , _data:lastname::text(200)                                                           as lastname--noqa: RF04
    , _data:gender::text(200)                                                             as gender
    , _data:maritalstatus::text(200)                                                      as maritalstatus
    , _data:citizenship::text(200)                                                        as citizenship
    , nullif(_data:companyname , '')::text(200)                                           as companyname
    , _data:spousefirstname::text(200)                                                    as spousefirstname
    , _data:spouselastname::text(200)                                                     as spouselastname
    , _data:address1::text(200)                                                           as address1
    , _data:address2::text(200)                                                           as address2
    , _data:city::text(200)                                                               as city
    , _data:stateorprovince::text(200)                                                    as stateorprovince
    , _data:postalcode::text(200)                                                         as postalcode
    , nullif(_data:homephone , '')::text(200)                                             as homephone
    , nullif(_data:businessphone , '')::text(200)                                         as businessphone
    , _data:cellphone::text(200)                                                          as cellphone
    , _data:spousecellphone::text(200)                                                    as spousecellphone
    , nullif(_data:spousebusinessphone , '')::text(200)                                   as spousebusinessphone
    , nullif(_data:fax , '')::text(200)                                                   as fax
    , _data:email::text(200)                                                              as email--noqa: RF04
    , _data:spouseemail::text(200)                                                        as spouseemail
    , _data:empname::text(200)                                                            as empname
    , nullif(_data:empaddress1 , '')::text(200)                                           as empaddress1
    , nullif(_data:empaddress2 , '')::text(200)                                           as empaddress2
    , nullif(_data:empcity , '')::text(200)                                               as empcity
    , nullif(_data:empstate , '')::text(200)                                              as empstate
    , nullif(_data:emppostalcode , '')::text(200)                                         as emppostalcode
    , nullif(_data:empbusinessfax , '')::text(200)                                        as empbusinessfax
    , nullif(_data:empemailaddress , '')::text(200)                                       as empemailaddress
    , nullif(_data:empjobtitle , '')::text(200)                                           as empjobtitle
    , nullif(_data:empyearsemployed , '')::text(200)                                      as empyearsemployed
    , nullif(_data:empprevempname , '')::text(200)                                        as empprevempname
    , nullif(_data:empprevjobtitle , '')::text(200)                                       as empprevjobtitle
    , nullif(_data:empprevempyearsemployed , '')::text(200)                               as empprevyearsemployed
    , nullif(_data:spouseempname , '')::text(200)                                         as spouseempname
    , nullif(_data:spouseempaddress1 , '')::text(200)                                     as spouseempaddress_1
    , nullif(_data:spouseempaddress2 , '')::text(200)                                     as spouseempaddress_2
    , nullif(_data:spouseempcity , '')::text(200)                                         as spouceempcity
    , nullif(_data:spouseemstate , '')::text(200)                                         as spouseempstate
    , nullif(_data:spouseemppostalcode , '')::text(200)                                   as spouseemppostal_code
    , nullif(_data:spouseempbusinessfax , '')::text(200)                                  as spouseempbusiness_fax
    , nullif(_data:spouseempemailaddress , '')::text(200)                                 as spouseempemail_address
    , nullif(_data:spouseempjobtitle , '')::text(200)                                     as spouseempjobtitle
    , nullif(_data:spouseempyearsemployed , '')::text(200)                                as spouseempyearsemployed
    , nullif(_data:spouseempprevempname , '')::text(200)                                  as spouseempprevempname
    , nullif(_data:spouseempprevjobtitle , '')::text(200)                                 as spouseempprevjobtitle
    , nullif(_data:spouseempprevempyearsemployed , '')::text(200)                         as spouseempprevyearsemployed
    , _data:userrole::text(200)                                                           as userrole
    , _data:userroleint::int                                                              as userroleint
    , _data:entitlements::text(200)                                                       as entitlements
    , to_timestamp_ntz((_data:"createtimestamp"::text(200)) , 'MM/DD/YYYY HH12:MI:SS AM') as createtimestamp
    , to_timestamp_ntz((_data:"deletetimestamp"::text(200)) , 'MM/DD/YYYY HH12:MI:SS AM') as deletetimestamp
    , _created_at::date                                                                   as record_date
    , _created_at::timestampntz                                                           as record_datetime
    , effective_date::date                                                                as effective_date
    , _created_at::timestampntz                                                           as _created_at
    , _source_file::text(200)                                                             as _source_file
    , _id::int                                                                            as _id
    , {{ col_is_head(reference=source('emoney_mwa', 'clients')) }}
from {{ source('emoney_mwa','clients') }}
