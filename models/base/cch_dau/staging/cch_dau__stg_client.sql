select
    'cch'::text(200)                                                        as system_name
    , 'axcess'::text(200)                                                   as system_instance
    , concat(system_name , '__' , system_instance)::text(200)               as system_key
    , clientident
    , clientofficename
    , clientregionname
    , clientbusinessunitname
    , clientid
    , clientidsubid
    , primaryclientflag::boolean                                            as primaryclientflag
    , clientsubid
    , clienttype
    , lineofbusiness
    , clientprimaryservicetype
    , clientsortname
    , returngroupname
    , deleteflag::boolean                                                   as deleteflag
    , fiscalperiod
    , clientstatus
    , to_timestamp(clientstatusdatetime , 'MM/DD/YYYY HH12:MI:SS AM')       as clientstatusdatetime
    , shareableflag
    , to_timestamp(acquireddatetime , 'MM/DD/YYYY HH12:MI:SS AM')           as acquireddatetime
    , clientclass
    , webpageurl
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')            as createddatetime
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM')        as lastupdateddatetime
    , salutationtext
    , attentiontext
    , correspondencename
    , subordinatedescription
    , firmmarketingmethod
    , to_timestamp(lastactivedatetime , 'MM/DD/YYYY HH12:MI:SS AM')         as lastactivedatetime
    , to_timestamp(terminateddatetime , 'MM/DD/YYYY HH12:MI:SS AM')         as terminateddatetime
    , to_timestamp(lastinactivedatetime , 'MM/DD/YYYY HH12:MI:SS AM')       as lastinactivedatetime
    , to_timestamp(lastonholddatetime , 'MM/DD/YYYY HH12:MI:SS AM')         as lastonholddatetime
    , to_timestamp(lastlitigationholddatetime , 'MM/DD/YYYY HH12:MI:SS AM') as lastlitigationholddatetime
    , createdbyident
    , lastupdatedbyident
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'client')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'client') }}
