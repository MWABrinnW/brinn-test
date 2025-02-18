select
    'cch'::text(200)                                                 as system_name
    , 'axcess'::text(200)                                            as system_instance
    , concat(system_name , '__' , system_instance)::text(200)        as system_key
    , servicecodeident
    , categoryident
    , categoryname
    , subcategoryident
    , subcategoryname
    , servicecodeid
    , servicecodename
    , categoryid
    , subcategoryid
    , billabletypeflag
    , taxable
    , inactiveflag::boolean                                          as inactiveflag
    , deleteflag::boolean                                            as deleteflag
    , servicecodetypeflag
    , mileageunitflag::boolean                                       as mileageunitflag
    , includeinbillablepercentageflag::boolean                       as includeinbillablepercentageflag
    , billratetype
    , surchargetype
    , surchargerate::decimal(19 , 4)                                 as surchargerate
    , surchargeflatamount::decimal(19 , 4)                           as surchargeflatamount
    , surchargepercent::decimal(8 , 4)                               as surchargepercent
    , createdbyident
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as createddatetime
    , lastupdatedbyident
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM') as lastupdateddatetime
    , servicecodedescription
    , serviceclass
    , staffbillrate
    , alternatestaffbillrate
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'servicecode')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'servicecode') }}
