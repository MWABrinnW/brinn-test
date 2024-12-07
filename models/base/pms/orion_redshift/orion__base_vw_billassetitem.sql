select
    ci.clientname                                     as clientname
    , ci.system_name                                  as system_name
    , ci.system_instance                              as system_instance
    , ci.system_key                                   as system_key
    , ci.firm_source                                  as firm_source
    , a.content:fkalclient::integer                   as fkalclient
    , a.content:pkbillassetitem::integer              as pkbillassetitem
    , a.content:fkbillaccountitem::integer            as fkbillaccountitem
    , a.content:fkasset::integer                      as fkasset
    , a.content:cpricepershare::double precision      as cpricepershare
    , a.content:cbillmktvalue::double precision       as cbillmktvalue
    , a.content:cfeeamount::double precision          as cfeeamount
    , a.content:bastitemediteddate::date              as bastitemediteddate
    , a.content:bastitemeditedby::varchar(50)         as bastitemeditedby
    , a.content:bastitemcreateddate::date             as bastitemcreateddate
    , a.content:bastitemcreatedby::varchar(50)        as bastitemcreatedby
    , a.content:billshares::double precision          as billshares
    , a.content:transdate::date                       as transdate
    , a.content:assetproportion::double precision     as assetproportion
    , a.content:tieredval::double precision           as tieredval
    , a.content:error::varchar(250)                   as error
    , a.content:islocked::boolean::int                as islocked
    , a.content:fktransaction::integer                as fktransaction
    , a.content:fkbillinstance::integer               as fkbillinstance
    , a.content:accruedinterest::double precision     as accruedinterest
    , a.content:createddate::timestamp                as createddate
    , max(ed.prior_market_date) over (partition by 1) as effective_date
    , a._pk::varchar(200)                             as _pk

    , a._extracted_at::timestamp_ntz                  as _extracted_at
    , 1::int                                          as is_head
    , {{ col_is_current(date_col='max(ed.prior_market_date) over (partition by 1 = 1)') }}
    , a._is_full::int                                 as _is_full
    , a._created_at::timestamp_ntz                    as _created_at
    , a._source_file                                  as _source_file
    , a._checksum                                     as _checksum
from {{ source('orion', 'vw_billassetitem') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
left join {{ ref('dates') }} as ed
    on a._extracted_at::date = ed.date_key
