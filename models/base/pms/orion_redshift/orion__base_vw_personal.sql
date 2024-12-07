select
    ci.clientname                                     as clientname
    , ci.system_name                                  as system_name
    , ci.system_instance                              as system_instance
    , ci.system_key                                   as system_key
    , ci.firm_source                                  as firm_source
    , a.content:fkalclient::integer                   as fkalclient
    , a.content:pkpersonal::integer                   as pkpersonal
    , a.content:fname::varchar(30)                    as fname
    , a.content:lname::varchar(255)                   as lname
    , a.content:entityname::varchar(255)              as entityname
    , a.content:addr1::varchar(255)                   as addr1
    , a.content:addr2::varchar(255)                   as addr2
    , a.content:addr3::varchar(255)                   as addr3
    , a.content:city::varchar(30)                     as city
    , a.content:state::char(2)                        as state
    , a.content:zip::varchar(10)                      as zip
    , a.content:phhome::varchar(15)                   as phhome
    , a.content:phhomeext::varchar(10)                as phhomeext
    , a.content:phbus::varchar(15)                    as phbus
    , a.content:phbusext::varchar(10)                 as phbusext
    , a.content:phmobile::varchar(15)                 as phmobile
    , a.content:phfax::varchar(15)                    as phfax
    , a.content:phfaxext::varchar(10)                 as phfaxext
    , a.content:phother::varchar(15)                  as phother
    , a.content:photherext::varchar(10)               as photherext
    , a.content:phpager::varchar(15)                  as phpager
    , a.content:phpagerext::varchar(10)               as phpagerext
    , a.content:email::varchar(200)                   as email
    , a.content:webaddress::varchar(255)              as webaddress
    , a.content:salutation::varchar(50)               as salutation
    , a.content:ssn_taxid::varchar(15)                as ssn_taxid
    , a.content:dob::varchar(20)                      as dob
    , a.content:issmoker::boolean::int                as issmoker
    , a.content:sex::char(1)                          as sex
    , a.content:marital::varchar(50)                  as marital
    , a.content:prefix::varchar(50)                   as prefix
    , a.content:suffix::varchar(50)                   as suffix
    , a.content:entitytype::integer                   as entitytype
    , a.content:personalcreateddate::date             as personalcreateddate
    , a.content:personalcreatedby::varchar(40)        as personalcreatedby
    , a.content:editeddate::date                      as editeddate
    , a.content:editedby::varchar(40)                 as editedby
    , a.content:fkparent::integer                     as fkparent
    , a.content:personaldesc::varchar(50)             as personaldesc
    , a.content:isactive::boolean::int                as isactive
    , a.content:jobtitle::varchar(200)                as jobtitle
    , a.content:isblockedpersonoverride::boolean::int as isblockedpersonoverride
    , a.content:isuscitizen::boolean::int             as isuscitizen
    , a.content:company::varchar(255)                 as company
    , a.content:twitterusername::varchar(50)          as twitterusername
    , a.content:facebookurl::varchar(8000)            as facebookurl
    , a.content:fkblobphoto::integer                  as fkblobphoto
    , a.content:reportname::varchar(255)              as reportname
    , a.content:isusresident::boolean::int            as isusresident
    , a.content:country::varchar(150)                 as country
    , a.content:ismobileverified::boolean::int        as ismobileverified
    , a.content:fkpersonalglobal::integer             as fkpersonalglobal
    , a.content:jsonpayload::varbinary                as jsonpayload
    , a.content:hashvalue::varbinary                  as hashvalue
    , a.content:deceasedssn_taxid::varchar(15)        as deceasedssn_taxid
    , a.content:createddate::timestamp                as createddate
    , a.effective_at::date                            as effective_date
    , a._pk::varchar(200)                             as _pk

    , a._extracted_at::timestamp_ntz                  as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_personal'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                 as _is_full
    , a._created_at::timestamp_ntz                    as _created_at
    , a._source_file                                  as _source_file
    , a._checksum                                     as _checksum
from {{ source('orion', 'vw_personal') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
