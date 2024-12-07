{{ config(
    materialized='incremental',
    cluster_by=['fkalclient', 'trunc(fkasset, -5)'],
    unique_key=['fkalclient', 'fkasset'],
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

select
    ci.clientname                                       as clientname
    , ci.system_name                                    as system_name
    , ci.system_instance                                as system_instance
    , ci.system_key                                     as system_key
    , ci.firm_source                                    as firm_source
    , a.content:fkalclient::integer                     as fkalclient
    , a.content:fkasset::integer                        as fkasset
    , a.content:accountid::integer                      as accountid
    , a.content:fkregistration::integer                 as fkregistration
    , a.content:fkpersonalregistration::integer         as fkpersonalregistration
    , a.content:fkclient::integer                       as fkclient
    , a.content:fkrep::integer                          as fkrep
    , a.content:fkcustodian::integer                    as fkcustodian
    , a.content:fkplatform::integer                     as fkplatform
    , a.content:fkdwnldsymbol::integer                  as fkdwnldsymbol
    , a.content:productid::integer                      as productid
    , a.content:fkproducttype::integer                  as fkproducttype
    , a.content:assetcreateddate::date                  as assetcreateddate
    , a.content:assetcreatedby::varchar(40)             as assetcreatedby
    , a.content:acctcode::varchar(50)                   as acctcode
    , a.content:secondaryacctcode::varchar(50)          as secondaryacctcode
    , a.content:currvalue::double precision             as currvalue
    , a.content:currshares::double precision            as currshares
    , a.content:isactive::boolean::int                  as isactive
    , a.content:editeddate::date                        as editeddate
    , a.content:editedby::varchar(100)                  as editedby
    , a.content:lastbuydate::date                       as lastbuydate
    , a.content:freesharevalue::double precision        as freesharevalue
    , a.content:freeshareasof::date                     as freeshareasof
    , a.content:isscapreinvested::boolean::int          as isscapreinvested
    , a.content:islcapreinvested::boolean::int          as islcapreinvested
    , a.content:isdivreinvested::boolean::int           as isdivreinvested
    , a.content:fkdwnldtype::integer                    as fkdwnldtype
    , a.content:rollupdate::date                        as rollupdate
    , a.content:isnasent::boolean::int                  as isnasent
    , a.content:pendvalue::double precision             as pendvalue
    , a.content:pendshares::double precision            as pendshares
    , a.content:costbasisvalue::double precision        as costbasisvalue
    , a.content:costbasisdate::date                     as costbasisdate
    , a.content:importkey::varchar(20)                  as importkey
    , a.content:istradeblocked::boolean::int            as istradeblocked
    , a.content:tradeblockreason::varchar(20)           as tradeblockreason
    , a.content:fkpricecurrvalue::integer               as fkpricecurrvalue
    , a.content:assetstrategyid::integer                as assetstrategyid
    , a.content:lastupdate::date                        as lastupdate
    , a.content:isvaluechangevalid::boolean::int        as isvaluechangevalid
    , a.content:pendingcalls::integer                   as pendingcalls
    , a.content:ismanaged::boolean::int                 as ismanaged
    , a.content:assetismanaged::boolean::int            as assetismanaged
    , a.content:assetstatus::integer                    as assetstatus
    , a.content:isstrategyoverride::boolean::int        as isstrategyoverride
    , a.content:lastrecondate::date                     as lastrecondate
    , a.content:expectedrecondate::date                 as expectedrecondate
    , a.content:excludedfrompositiononly::boolean::int  as excludedfrompositiononly
    , a.content:isadvisoronly::boolean::int             as isadvisoronly
    , a.content:dailychangetolerance::double precision  as dailychangetolerance
    , a.content:mscsfundaccountnumber::varchar(20)      as mscsfundaccountnumber
    , a.content:isadvreportable::boolean::int           as isadvreportable
    , a.content:is13freportable::boolean::int           as is13freportable
    , a.content:assetrowversion::varchar(100)           as assetrowversion
    , a.content:isorionvision::boolean::int             as isorionvision
    , a.content:pkbillasset::integer                    as pkbillasset
    , a.content:assetclassid::integer                   as assetclassid
    , a.content:productcategoryid::integer              as productcategoryid
    , a.content:fkfundfamily::integer                   as fkfundfamily
    , a.content:fkpersonalfundfamily::integer           as fkpersonalfundfamily
    , a.content:isrebalance::boolean::int               as isrebalance
    , a.content:iscash::boolean::int                    as iscash
    , a.content:riskcategoryid::integer                 as riskcategoryid
    , a.content:fkassetsma::integer                     as fkassetsma
    , a.content:usedfor::integer                        as usedfor
    , a.content:assetpercentofaccount::double precision as assetpercentofaccount
    , a.content:accounttype::varchar(50)                as accounttype
    , a.content:createddate::timestamp                  as createddate
    --, a.effective_at::date                              as effective_date
    , a._pk::varchar(200)                               as _pk
    , a._extracted_at::timestamp_ntz                    as _extracted_at
    , current_timestamp()                               as _created_at
    , a._created_at::timestamp_ntz                      as _source_loaded_at
    {# , {{ col_is_head(reference=source('orion', 'vw_asset'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }} #}
    , a._source_file                                    as _source_file
    , a._checksum                                       as _checksum
    , a._is_full::int                                   as _is_full
from {{ source('orion', 'vw_asset') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
where 1 = 1
    {% if is_incremental() -%}
        and a.content:createddate::timestamp > (select max(t.createddate) from {{ this }} as t)
    {% endif -%}
order by a.content:fkalclient::int , a.content:fkasset::int
