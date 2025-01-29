{{
  config(
    enabled=false,
    )
}}

select
    to_timestamp(asofdate , 'MM/DD/YYYY HH:MI:SS AM')::date                         as as_of_date
    , customeraccountnumber                                                         as customeraccountnumber
    , customername
    , customertypedesc
    , cusip
    , cusipdescription
    , holdingtypedesc
    , positionid
    , purchaseprice::decimal(20 , 5)                                                as purchaseprice
    , marketpriceaod::decimal(20 , 5)                                               as marketpriceaod
    , fairvalue::decimal(20 , 2)                                                    as fairvalue
    , parvalue::decimal(20 , 2)                                                     as parvalue
    , effective_date
    , record_datetime
    , source_file
    , dense_rank() over (partition by effective_date order by record_datetime desc) as rn
from {{ source('tpg_hfw', 'holdings') }}
