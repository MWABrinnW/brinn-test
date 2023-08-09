select
    ci.clientname                                  as clientname
  , content:fkalclient::integer                    as fkalclient
  , content:pkclient::integer                      as pkclient
  , content:fkrep::integer                         as fkrep
  , content:fkpersonal::integer                    as fkpersonal
  , content:fkrep::integer                         as fkrep
  , content:fkclientcat::integer                   as fkclientcat
  , content:fkria::integer                         as fkria
  , content:isactive::boolean::int                 as isactive
  , content:startdate::date                        as startdate
  , content:hhcreateddate::date                    as hhcreateddate
  , content:hhcreatedby::varchar(40)               as hhcreatedby
  , content:editeddate::date                       as editeddate
  , content:editedby::varchar(40)                  as editedby
  , content:fkbilltransmitmethod::integer          as fkbilltransmitmethod
  , content:laststatementsent::date                as laststatementsent
  , content:laststatementsentto::varchar(255)      as laststatementsentto
  , content:importkey::varchar(15)                 as importkey
  , content:storeperformance::integer              as storeperformance
  , content:videostatement::integer                as videostatement
  , content:isqualifiedinvestor::boolean::int      as isqualifiedinvestor
  , content:riskscore::double precision            as riskscore
  , content:logincount::integer                    as logincount
  , content:cctype::varchar(50)                    as cctype
  , content:ccnum::varchar(50)                     as ccnum
  , content:cctoken::varchar(100)                  as cctoken
  , content:ccisvalid::boolean::int                as ccisvalid
  , content:probabilityofsuccess::double precision as probabilityofsuccess
  , content:fkadvclientcategory::integer           as fkadvclientcategory
  , content:isrtqlocked::boolean::int              as isrtqlocked
  , content:createddate::timestamp                 as createddate
  , a.effective_at::date                           as effective_date
  , a._pk::varchar(200)                            as _pk
  , a._client::int                                 as _client
  , a._extracted_at                                as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_household'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                as _is_full
  , a._created_at                                  as _created_at
  , a._source_file                                 as _source_file
  , a._checksum                                    as _checksum
from {{ source('orion', 'vw_household') }}  a
join {{ ref('orion__base_vw_clientinfo') }} ci
     on a._client::int = ci.pkalclient
