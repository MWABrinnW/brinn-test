select
    ci.clientname                                  as clientname
  , content:fkalclient::integer                    as fkalclient
  , content:sl_pkaccount::integer                  as sl_pkaccount
  , content:sl_acctcode::varchar(100)              as sl_acctcode
  , content:sl_isactive::boolean::int              as sl_isactive
  , content:pkaccount::integer                     as pkaccount
  , content:ac_acctcode::varchar(100)              as ac_acctcode
  , content:ac_isactive::boolean::int              as ac_isactive
  , content:ac_istradingblocked::boolean::int      as ac_istradingblocked
  , content:ac_tradinginstr::varchar(512)          as ac_tradinginstr
  , content:ac_mincashbalance::double precision    as ac_mincashbalance
  , content:ac_dollarmodelamount::double precision as ac_dollarmodelamount
  , content:ac_mincashbalancetype::integer         as ac_mincashbalancetype
  , content:ac_replenishmincash::boolean::int      as ac_replenishmincash
  , content:ac_fkfundfamily::integer               as ac_fkfundfamily
  , content:ac_fkplatform::integer                 as ac_fkplatform
  , content:pf_name::varchar(150)                  as pf_name
  , content:ac_fkcustodian::integer                as ac_fkcustodian
  , content:cus_name::varchar(50)                  as cus_name
  , content:ac_fkdownloadsource::integer           as ac_fkdownloadsource
  , content:ds_desc::varchar(60)                   as ds_desc
  , content:ac_fkmodelagg::integer                 as ac_fkmodelagg
  , content:mag_name::varchar(300)                 as mag_name
  , content:fkregistration::integer                as fkregistration
  , content:reg_fkpersonal::integer                as reg_fkpersonal
  , content:reg_pers_entityname::varchar(255)      as reg_pers_entityname
  , content:reg_isactive::boolean::int             as reg_isactive
  , content:reg_sleeveisactive::boolean::int       as reg_sleeveisactive
  , content:reg_fksleevestrategy::integer          as reg_fksleevestrategy
  , content:ss_name::varchar(60)                   as ss_name
  , content:fkclient::integer                      as fkclient
  , content:hh_fkpersonal::integer                 as hh_fkpersonal
  , content:hh_pers_entityname::varchar(255)       as hh_pers_entityname
  , content:hh_pers_encssn::varchar(255)           as hh_pers_encssn
  , content:hh_pers_encssnkeyversion::integer      as hh_pers_encssnkeyversion
  , content:fkrep::integer                         as fkrep
  , content:rep_fkpersonal::integer                as rep_fkpersonal
  , content:rep_pers_entityname::varchar(255)      as rep_pers_entityname
  , content:rep_fkbrokerdealer::integer            as rep_fkbrokerdealer
  , content:bd_fkpersonal::integer                 as bd_fkpersonal
  , content:bd_pers_entityname::varchar(255)       as bd_pers_entityname
  , a.effective_at::date                           as effective_date
  , a._pk::varchar(200)                            as _pk
  , a._client::int                                 as _client
  , a._extracted_at                                as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_d_account'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                as _is_full
  , a._created_at                                  as _created_at
  , a._source_file                                 as _source_file
  , a._checksum                                    as _checksum
from {{ source('orion', 'stg_vw_d_account') }} a
join {{ ref('orion__base_vw_clientinfo') }}    ci
     on a._client::int = ci.pkalclient
