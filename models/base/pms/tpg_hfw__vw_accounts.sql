select
    customeraccountnumber
    ,customername
    ,customertypedesc
    ,sum(fairvalue) as fairvalue
    ,sum(parvalue) as parvalue
    ,effective_date
    ,record_datetime
    ,source_file
from  {{ ref('tpg_hfw__vw_holdings') }}
group by 1,2,3,6,7,8