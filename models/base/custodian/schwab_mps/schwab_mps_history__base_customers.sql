
select
    accountnumber
    ,accountdesc
    ,accountaddr1
    ,accountaddr2
    ,accountaddr3
    ,accountaddr4
    ,phone1
    ,phone2
    ,accountopendate
    ,branchid
    ,taxid
    ,mmf
    ,cashinstructions
    ,margininstructions
    ,restrictions
    ,optionlevel
    ,case when effective_date::date = (select max(effective_date::date) from {{ source('schwab_mps', 'customer') }}) then 1 else 0 end as is_current
    ,effective_date::date           as effective_date
    ,record_datetime::timestamp     as record_datetime
    ,record_date::date              as record_date
    ,record_datetime::timestamp     as _source_loaded_at
from {{ source('schwab_mps', 'customer') }}