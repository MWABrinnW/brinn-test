select
    'cch'::text(200)                                                 as system_name
    , 'axcess'::text(200)                                            as system_instance
    , concat(system_name , '__' , system_instance)::text(200)        as system_key
    , addressident
    , addressidentcategorytype
    , employeeplansubentitytypecode
    , referenceident
    , referenceidenttype
    , firmaddresstypelabelname
    , firmaddresstypedescription
    , addressline1
    , addressline2
    , addressline3
    , cityname
    , postalcode
    , countrycode
    , primaryaddressflag
    , mailingaddressflag
    , aptorsuitenumber
    , stateprovincecode
    , createdbyident
    , lastupdatedbyident
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as createddatetime
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM') as lastupdateddatetime
    , invoiceflag::boolean                                           as invoiceflag
    , statementflag::boolean                                         as statementflag
    , isclientcontactbillingaddressflag::boolean                     as isclientcontactbillingaddressflag
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'clientaddress')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'clientaddress') }}
