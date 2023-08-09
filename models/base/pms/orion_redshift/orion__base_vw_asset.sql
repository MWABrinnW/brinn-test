select
    ci.clientname                                   as clientname
  , content:fkalclient::integer                     as fkalclient
  , content:fkasset::integer                        as fkasset
  , content:accountid::integer                      as accountid
  , content:fkregistration::integer                 as fkregistration
  , content:fkpersonalregistration::integer         as fkpersonalregistration
  , content:fkclient::integer                       as fkclient
  , content:fkrep::integer                          as fkrep
  , content:fkcustodian::integer                    as fkcustodian
  , content:fkplatform::integer                     as fkplatform
  , content:fkdwnldsymbol::integer                  as fkdwnldsymbol
  , content:productid::integer                      as productid
  , content:fkproducttype::integer                  as fkproducttype
  , content:assetcreateddate::date                  as assetcreateddate
  , content:assetcreatedby::varchar(40)             as assetcreatedby
  , content:acctcode::varchar(50)                   as acctcode
  , content:secondaryacctcode::varchar(50)          as secondaryacctcode
  , content:currvalue::double precision             as currvalue
  , content:currshares::double precision            as currshares
  , content:isactive::boolean::int                  as isactive
  , content:editeddate::date                        as editeddate
  , content:editedby::varchar(100)                  as editedby
  , content:lastbuydate::date                       as lastbuydate
  , content:freesharevalue::double precision        as freesharevalue
  , content:freeshareasof::date                     as freeshareasof
  , content:isscapreinvested::boolean::int          as isscapreinvested
  , content:islcapreinvested::boolean::int          as islcapreinvested
  , content:isdivreinvested::boolean::int           as isdivreinvested
  , content:fkdwnldtype::integer                    as fkdwnldtype
  , content:rollupdate::date                        as rollupdate
  , content:isnasent::boolean::int                  as isnasent
  , content:pendvalue::double precision             as pendvalue
  , content:pendshares::double precision            as pendshares
  , content:costbasisvalue::double precision        as costbasisvalue
  , content:costbasisdate::date                     as costbasisdate
  , content:importkey::varchar(20)                  as importkey
  , content:istradeblocked::boolean::int            as istradeblocked
  , content:tradeblockreason::varchar(20)           as tradeblockreason
  , content:fkpricecurrvalue::integer               as fkpricecurrvalue
  , content:assetstrategyid::integer                as assetstrategyid
  , content:lastupdate::date                        as lastupdate
  , content:isvaluechangevalid::boolean::int        as isvaluechangevalid
  , content:pendingcalls::integer                   as pendingcalls
  , content:ismanaged::boolean::int                 as ismanaged
  , content:assetismanaged::boolean::int            as assetismanaged
  , content:assetstatus::integer                    as assetstatus
  , content:isstrategyoverride::boolean::int        as isstrategyoverride
  , content:lastrecondate::date                     as lastrecondate
  , content:expectedrecondate::date                 as expectedrecondate
  , content:excludedfrompositiononly::boolean::int  as excludedfrompositiononly
  , content:isadvisoronly::boolean::int             as isadvisoronly
  , content:dailychangetolerance::double precision  as dailychangetolerance
  , content:mscsfundaccountnumber::varchar(20)      as mscsfundaccountnumber
  , content:isadvreportable::boolean::int           as isadvreportable
  , content:is13freportable::boolean::int           as is13freportable
  , content:assetrowversion::varchar(100)           as assetrowversion
  , content:isorionvision::boolean::int             as isorionvision
  , content:pkbillasset::integer                    as pkbillasset
  , content:assetclassid::integer                   as assetclassid
  , content:productcategoryid::integer              as productcategoryid
  , content:fkfundfamily::integer                   as fkfundfamily
  , content:fkpersonalfundfamily::integer           as fkpersonalfundfamily
  , content:isrebalance::boolean::int               as isrebalance
  , content:iscash::boolean::int                    as iscash
  , content:riskcategoryid::integer                 as riskcategoryid
  , content:fkassetsma::integer                     as fkassetsma
  , content:usedfor::integer                        as usedfor
  , content:assetpercentofaccount::double precision as assetpercentofaccount
  , content:accounttype::varchar(50)                as accounttype
  , content:createddate::timestamp                  as createddate
  , a.effective_at::date                            as effective_date
  , a._pk::varchar(200)                             as _pk
  , a._client::int                                  as _client
  , a._extracted_at                                 as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_asset'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                 as _is_full
  , a._created_at                                   as _created_at
  , a._source_file                                  as _source_file
  , a._checksum                                     as _checksum
from {{ source('orion', 'stg_vw_asset') }}  a
join {{ ref('orion__base_vw_clientinfo') }} ci
     on a._client::int = ci.pkalclient
