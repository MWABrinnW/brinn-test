select
    effective_date
  , custodiancode
  , account
  , product
  , symbol
  , cusip
  , quantity
  , unitcost
  , totalcost
  , price
  , lotdate
  , ''::text(2000)
        || nvl(case
                   when nvl(symbol, '') = ''
                       then 'missing symbol;' end, '')
        || nvl(case
                   when nvl(product, '') = ''
                       then 'missing product;' end, '')
        || nvl(case
                   when price is null
                       then 'missing price;' end, '')
        || nvl(case
                   when quantity is null
                       then 'missing quantity;' end, '')
        || nvl(case
                   when unitcost is null and nvl(product,'') <> 'CASH'
                       then 'missing unitcost;' end, '')
        || nvl(case
                   when totalcost is null and nvl(product, '') <> 'CASH'
                       then 'missing totalcost;' end, '')
            as exception_detail
  , case
        when exception_detail <> ''
            then 1
        else 0
        end as is_exception
from {{ ref('fixflyer_options__sod_positions') }}
where 1 = 1
  and is_exception = 1
order by custodiancode, account, symbol