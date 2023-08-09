select
    ci.clientname                                   as clientname
  , content:fkalclient::integer                     as fkalclient
  , content:pkbillassetitem::integer                as pkbillassetitem
  , content:fkbillaccountitem::integer              as fkbillaccountitem
  , content:fkasset::integer                        as fkasset
  , content:cpricepershare::double precision        as cpricepershare
  , content:cbillmktvalue::double precision         as cbillmktvalue
  , content:cfeeamount::double precision            as cfeeamount
  , content:bastitemediteddate::date                as bastitemediteddate
  , content:bastitemeditedby::varchar(50)           as bastitemeditedby
  , content:bastitemcreateddate::date               as bastitemcreateddate
  , content:bastitemcreatedby::varchar(50)          as bastitemcreatedby
  , content:billshares::double precision            as billshares
  , content:transdate::date                         as transdate
  , content:assetproportion::double precision       as assetproportion
  , content:tieredval::double precision             as tieredval
  , content:error::varchar(250)                     as error
  , content:islocked::boolean::int                  as islocked
  , content:fktransaction::integer                  as fktransaction
  , content:fkbillinstance::integer                 as fkbillinstance
  , content:accruedinterest::double precision       as accruedinterest
  , content:createddate::timestamp                  as createddate
  , max(ed.prior_market_date) over (partition by 1) as effective_date
  , a._pk::varchar(200)                             as _pk
  , a._client::int                                  as _client
  , a._extracted_at                                 as _extracted_at
  , 1::int                                          as is_head
  , {{ col_is_current(date_col='max(ed.prior_market_date) over (partition by 1 = 1)') }}
  , a._is_full::int                                 as _is_full
  , a._created_at                                   as _created_at
  , a._source_file                                  as _source_file
  , a._checksum                                     as _checksum
from {{ source('orion', 'vw_billassetitem') }}   a
join      {{ ref('orion__base_vw_clientinfo') }} ci
          on a._client::int = ci.pkalclient
left join {{ ref('dates') }}                     ed
          on a._extracted_at::date = ed.date_key
