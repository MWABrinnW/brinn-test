select
    'cch'::text(200)                                                 as system_name
    , 'axcess'::text(200)                                            as system_instance
    , concat(system_name , '__' , system_instance)::text(200)        as system_key
    , invoiceident
    , clientident
    , to_timestamp(acctperdatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as acctperdatetime
    , to_timestamp(invoicedatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as invoicedatetime
    , to_timestamp(reverseddatetime , 'MM/DD/YYYY HH12:MI:SS AM')    as reverseddatetime
    , invoicenumber
    , stdwipamount::decimal(19 , 4)                                  as stdwipamount
    , adjustmentamount::decimal(19 , 4)                              as adjustmentamount
    , taxamount::decimal(19 , 4)                                     as taxamount
    , hours::decimal(19 , 4)                                         as hours
    , taxappamount::decimal(19 , 4)                                  as taxappamount
    , progressbilledamount::decimal(19 , 4)                          as progressbilledamount
    , progressapplyamount::decimal(19 , 4)                           as progressapplyamount
    , progresstaxamount::decimal(19 , 4)                             as progresstaxamount
    , progresstaxappamount::decimal(19 , 4)                          as progresstaxappamount
    , statuscode
    , invoicetypecode
    , paidinfullflag
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as createddatetime
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM') as lastupdateddatetime
    , createdbyident
    , lastupdatedbyident
    , reasonname
    , invoicestatusname
    , invoicestatusdescription
    , invoicenumbercode
    , invoiceofficecode
    , to_timestamp(billthrudate , 'MM/DD/YYYY HH12:MI:SS AM')        as billthrudate
    , clientbillingfeeagreementname
    , invoicetemplatename
    , invoicetitle
    , billinggroupname
    , subsidiaryclientident
    , projectident
    , invoiceofficename
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'invoice')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'invoice') }}
