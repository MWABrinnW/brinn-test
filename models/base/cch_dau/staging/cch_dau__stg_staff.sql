select
    'cch'::text(200)                                                  as system_name
    , 'axcess'::text(200)                                             as system_instance
    , concat(system_name , '__' , system_instance)::text(200)         as system_key
    , staffident
    , staffofficename
    , staffregionname
    , staffbusinessunitname
    , staffdescription
    , staffidentifier
    , staffname
    , staffdepartment
    , staffposition
    , staffreportingmanagername
    , reportname
    , firmident
    , firmname
    , staffstatus
    , deleteflag
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')      as createddatetime
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM')  as lastupdateddatetime
    , to_timestamp(lastinactivedatetime , 'MM/DD/YYYY HH12:MI:SS AM') as lastinactivedatetime
    , stafffirstname
    , staffmiddlename
    , stafflastname
    , staffsuffixcode
    , emergencycontactname
    , emergencycontactrelationship
    , emergencycontactphone
    , employeenumber
    , to_timestamp(reviewdate , 'MM/DD/YYYY HH12:MI:SS AM')           as reviewdate
    , hiresalary::decimal(19 , 4)                                     as hiresalary
    , to_timestamp(hiredate , 'MM/DD/YYYY HH12:MI:SS AM')             as hiredate
    , currentsalary::decimal(19 , 4)                                  as currentsalary
    , staffuserid
    , userloginenabledflag
    , hiredtypename
    , paytypename
    , honorificcode
    , to_timestamp(lastactivedatetime , 'MM/DD/YYYY HH12:MI:SS AM')   as lastactivedatetime
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'staff')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'staff') }}
