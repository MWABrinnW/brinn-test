select
    ci.clientname                                      as clientname
    , ci.system_name                                   as system_name
    , ci.system_instance                               as system_instance
    , ci.system_key                                    as system_key
    , ci.firm_source                                   as firm_source
    , a.content:fkalclient::integer                    as fkalclient
    , a.content:sl_pkaccount::integer                  as sl_pkaccount
    , a.content:sl_acctcode::varchar(100)              as sl_acctcode
    , a.content:sl_isactive::boolean::int              as sl_isactive
    , a.content:fkaccount::integer                     as fkaccount
    , a.content:ac_acctcode::varchar(100)              as ac_acctcode
    , a.content:ac_isactive::boolean::int              as ac_isactive
    , a.content:ac_istradingblocked::boolean::int      as ac_istradingblocked
    , a.content:ac_tradinginstr::varchar(512)          as ac_tradinginstr
    , a.content:ac_mincashbalance::double precision    as ac_mincashbalance
    , a.content:ac_dollarmodelamount::double precision as ac_dollarmodelamount
    , a.content:ac_mincashbalancetype::integer         as ac_mincashbalancetype
    , a.content:ac_replenishmincash::boolean::int      as ac_replenishmincash
    , a.content:ac_fkfundfamily::integer               as ac_fkfundfamily
    , a.content:ac_fkplatform::integer                 as ac_fkplatform
    , a.content:pf_name::varchar(150)                  as pf_name
    , a.content:ac_fkcustodian::integer                as ac_fkcustodian
    , a.content:cus_name::varchar(50)                  as cus_name
    , a.content:ac_fkdownloadsource::integer           as ac_fkdownloadsource
    , a.content:ds_desc::varchar(60)                   as ds_desc
    , a.content:ac_fkmodelagg::integer                 as ac_fkmodelagg
    , a.content:mag_name::varchar(300)                 as mag_name
    , a.content:fkregistration::integer                as fkregistration
    , a.content:reg_fkpersonal::integer                as reg_fkpersonal
    , a.content:reg_pers_entityname::varchar(255)      as reg_pers_entityname
    , a.content:reg_isactive::boolean::int             as reg_isactive
    , a.content:reg_sleeveisactive::boolean::int       as reg_sleeveisactive
    , a.content:reg_fksleevestrategy::integer          as reg_fksleevestrategy
    , a.content:ss_name::varchar(60)                   as ss_name
    , a.content:fkclient::integer                      as fkclient
    , a.content:hh_fkpersonal::integer                 as hh_fkpersonal
    , a.content:hh_pers_entityname::varchar(255)       as hh_pers_entityname
    , a.content:hh_pers_encssn::varchar(255)           as hh_pers_encssn
    , a.content:hh_pers_encssnkeyversion::integer      as hh_pers_encssnkeyversion
    , a.content:fkrep::integer                         as fkrep
    , a.content:rep_fkpersonal::integer                as rep_fkpersonal
    , a.content:rep_pers_entityname::varchar(255)      as rep_pers_entityname
    , a.content:rep_fkbrokerdealer::integer            as rep_fkbrokerdealer
    , a.content:bd_fkpersonal::integer                 as bd_fkpersonal
    , a.content:bd_pers_entityname::varchar(255)       as bd_pers_entityname
    , a.content:pkasset::integer                       as pkasset
    , a.content:fkproduct::integer                     as fkproduct
    , a.content:pr_productname::varchar(150)           as pr_productname
    , a.content:pr_ticker::varchar(50)                 as pr_ticker
    , a.content:pr_cusip::varchar(50)                  as pr_cusip
    , a.content:pr_tickeriscusip::integer              as pr_tickeriscusip
    , a.content:pr_fkfundfamily::integer               as pr_fkfundfamily
    , a.content:pr_iscustodialcash::boolean::int       as pr_iscustodialcash
    , a.content:fkproductclass::integer                as fkproductclass
    , a.content:pc_name::varchar(60)                   as pc_name
    , a.content:pc_productclasscategory::varchar(30)   as pc_productclasscategory
    , a.content:pc_color::varchar(60)                  as pc_color
    , a.content:pc_fkproductcategory::integer          as pc_fkproductcategory
    , a.content:pcat_categoryname::varchar(100)        as pcat_categoryname
    , a.content:pcat_color::varchar(50)                as pcat_color
    , a.content:pcat_parentcategory::varchar(20)       as pcat_parentcategory
    , a.content:av_asofdate::date                      as av_asofdate
    , a.content:av_unitbalance::double precision       as av_unitbalance
    , a.content:av_navprice::double precision          as av_navprice
    , a.content:av_calculatedvalue::double precision   as av_calculatedvalue
    , a.effective_at::date                             as effective_date
    , a._pk::varchar(200)                              as _pk

    , a._extracted_at::timestamp_ntz                   as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_d_asset'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                  as _is_full
    , a._created_at::timestamp_ntz                     as _created_at
    , a._source_file                                   as _source_file
    , a._checksum                                      as _checksum
from {{ source('orion', 'vw_d_asset') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
