
select
    subadvisorid
  , acctcode
  , reg_name
  , transdate::timestamp       as transdate
  , trandesc
  , transtotal::number(19, 6)  as transtotal
  , ticker
  , productname
  , par_value::number(19, 6)   as par_value
  , real_price::number(19, 6)  as real_price
  , navprice::number(19, 6)    as navprice
  , fundname
  , mgmtstyle
  , acct_id
  , rep_name
  , subadvisor
  , record_datetime::timestamp as record_datetime
  , record_date::date          as record_date
from {{ source('moxy', 'pending_transactions') }}
where record_datetime = (select max(record_datetime) from {{ source('moxy', 'pending_transactions') }})
