select
    null::int                                                           as tranid
    , portfolio_id::text(255)                                           as portfolio
    , sec_type::text(255)                                               as type
    , 'us'::text(3)                                                     as curr
    , left(upper(symbol) , 24)                                          as symbol
    -- Negative quantities are indicated by postype = 1
    , iff(quantity < 0 , 1 , 0)::int                                    as postype
    , to_char(acquired_date , 'YYYYMMDD')::text(10)                     as ocdate
    , to_char(dateadd(year , 1 , acquired_date) , 'YYYYMMDD')::text(10) as hldate
    -- Reduce factor of quantity for options
    , case
        when left(sec_type , 2) in ('cl' , 'pt')
            then abs(quantity) / 100
        else
            abs(quantity)
    end                                                                 as quantity
    , case
        when coalesce(cost_basis , 0) = 0 and ticker ilike 'MOXYCASH'
            then abs(quantity)
        when coalesce(cost_basis , 0) = 0 and asset_class ilike 'Cash and Cash Equivalents'
            then abs(quantity)
        else abs(cost_basis)
    end                                                                 as totalcost
    , case
        when quantity = 0 or current_price = 0
            then 1
        else 0
    end::int                                                            as iszeromv
    , null::text                                                        as broker
    , null::text                                                        as custodian
    , 'n'                                                               as pledge
    , null::decimal(20 , 5)                                             as pcalc
    , null::int                                                         as iaction
    , coalesce(lot_id , record_id * -1)::int::text                      as lotnum
    , coalesce(lot_id , record_id * -1)::int::text                      as exlotid
    , coalesce(to_char(lot_id) , '')::text                              as tradematch
    , null::int                                                         as swaptranid
    , null::text                                                        as settle
    , null::text                                                        as ugainm
    , null::text                                                        as ugainq
    , null::text                                                        as ugainy
    , null::text                                                        as userdef1
    , null::text                                                        as userdef2
    , null::text                                                        as userdef3
    , is_intraday_import                                                as is_intraday_import
    , trading_id                                                        as trading_id
from {{ ref('moxy__int_tax_lots_build') }}
