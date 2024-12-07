select
    ci.clientname                                      as clientname
    , ci.system_name                                   as system_name
    , ci.system_instance                               as system_instance
    , ci.system_key                                    as system_key
    , ci.firm_source                                   as firm_source
    , a.content:fkalclient::integer                    as fkalclient
    , a.content:pkclient::integer                      as pkclient
    , a.content:fkrep::integer                         as fkrep
    , a.content:fkpersonal::integer                    as fkpersonal
    , a.content:fkclientcat::integer                   as fkclientcat
    , a.content:fkria::integer                         as fkria
    , a.content:isactive::boolean::int                 as isactive
    , a.content:startdate::date                        as startdate
    , a.content:hhcreateddate::date                    as hhcreateddate
    , a.content:hhcreatedby::varchar(40)               as hhcreatedby
    , a.content:editeddate::date                       as editeddate
    , a.content:editedby::varchar(40)                  as editedby
    , a.content:fkbilltransmitmethod::integer          as fkbilltransmitmethod
    , a.content:laststatementsent::date                as laststatementsent
    , a.content:laststatementsentto::varchar(255)      as laststatementsentto
    , a.content:importkey::varchar(15)                 as importkey
    , a.content:storeperformance::integer              as storeperformance
    , a.content:videostatement::integer                as videostatement
    , a.content:isqualifiedinvestor::boolean::int      as isqualifiedinvestor
    , a.content:riskscore::double precision            as riskscore
    , a.content:logincount::integer                    as logincount
    , a.content:cctype::varchar(50)                    as cctype
    , a.content:ccnum::varchar(50)                     as ccnum
    , a.content:cctoken::varchar(100)                  as cctoken
    , a.content:ccisvalid::boolean::int                as ccisvalid
    , a.content:probabilityofsuccess::double precision as probabilityofsuccess
    , a.content:fkadvclientcategory::integer           as fkadvclientcategory
    , a.content:isrtqlocked::boolean::int              as isrtqlocked
    , a.content:createddate::timestamp                 as createddate
    , a.effective_at::date                             as effective_date
    , a._pk::varchar(200)                              as _pk

    , a._extracted_at::timestamp_ntz                   as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_household'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                  as _is_full
    , a._created_at::timestamp_ntz                     as _created_at
    , a._source_file                                   as _source_file
    , a._checksum                                      as _checksum
from {{ source('orion', 'vw_household') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
