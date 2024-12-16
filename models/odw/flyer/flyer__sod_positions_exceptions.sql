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
    || coalesce(case
        when coalesce(symbol , '') = ''
            then 'missing symbol;'
    end , '')
    || coalesce(case
        when coalesce(product , '') = ''
            then 'missing product;'
    end , '')
    || coalesce(case
        when price is null
            then 'missing price;'
    end , '')
    || coalesce(case
        when quantity is null
            then 'missing quantity;'
    end , '')
    || coalesce(case
        when unitcost is null and coalesce(product , '') != 'CASH'
            then 'missing unitcost;'
    end , '')
    || coalesce(case
        when totalcost is null and coalesce(product , '') != 'CASH'
            then 'missing totalcost;'
    end , '')
        as exception_detail
    , case
        when exception_detail != ''
            then 1
        else 0
    end       as is_exception
from {{ ref('flyer__sod_positions') }}
where 1 = 1
    and is_exception = 1
order by custodiancode , account , symbol
