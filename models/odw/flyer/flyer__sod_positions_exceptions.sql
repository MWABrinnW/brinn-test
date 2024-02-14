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
    || COALESCE(case
        when COALESCE(symbol , '') = ''
            then 'missing symbol;'
    end , '')
    || COALESCE(case
        when COALESCE(product , '') = ''
            then 'missing product;'
    end , '')
    || COALESCE(case
        when price is null
            then 'missing price;'
    end , '')
    || COALESCE(case
        when quantity is null
            then 'missing quantity;'
    end , '')
    || COALESCE(case
        when unitcost is null and COALESCE(product , '') != 'CASH'
            then 'missing unitcost;'
    end , '')
    || COALESCE(case
        when totalcost is null and COALESCE(product , '') != 'CASH'
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
