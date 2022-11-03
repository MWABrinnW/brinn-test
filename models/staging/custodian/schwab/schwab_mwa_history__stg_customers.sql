
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
    ,effective_date
    ,record_datetime
    ,record_date
from {{ source('schwab_mwa', 'customer') }}