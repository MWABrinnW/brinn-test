select
    ci.clientname                             as clientname
    , ci.system_name                          as system_name
    , ci.system_instance                      as system_instance
    , ci.system_key                           as system_key
    , ci.firm_source                          as firm_source
    , a.content:fkalclient::integer           as fkalclient
    , a.content:pkbill::integer               as pkbill
    , a.content:fkbillclient::integer         as fkbillclient
    , a.content:fkbilltransmitmethod::integer as fkbilltransmitmethod
    , a.content:fkblob::integer               as fkblob
    , a.content:dtcalcdate::date              as dtcalcdate
    , a.content:billediteddate::date          as billediteddate
    , a.content:billeditedby::varchar(50)     as billeditedby
    , a.content:billcreateddate::date         as billcreateddate
    , a.content:billcreatedby::varchar(50)    as billcreatedby
    , a.content:isvalid::integer              as isvalid
    , a.content:oldinvoiceno::integer         as oldinvoiceno
    , a.content:billtype::integer             as billtype
    , a.content:fkbillinstance::integer       as fkbillinstance
    , a.content:fkclientstamp::integer        as fkclientstamp
    , a.content:fkbillaccountitem::integer    as fkbillaccountitem
    , a.content:createddate::timestamp        as createddate
    , a.effective_at::date                    as effective_date
    , a._pk::varchar(200)                     as _pk

    , a._extracted_at::timestamp_ntz          as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_bill'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                         as _is_full
    , a._created_at::timestamp_ntz            as _created_at
    , a._source_file                          as _source_file
    , a._checksum                             as _checksum
from {{ source('orion', 'vw_bill') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
