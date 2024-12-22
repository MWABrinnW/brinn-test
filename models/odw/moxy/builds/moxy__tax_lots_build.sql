select
    null::int                                                 as "tranid"
    , portfolio_id                                            as "portfolio"
    , sec_type                                                as "type"
    , 'us'                                                    as "curr"
    , left(symbol, 24)                                        as "symbol"
    -- Negative quantities are indicated by postype = 1
    , iff(quantity < 0 , 1 , 0)::int                          as "postype"
    , to_char(acquired_date , 'YYYYMMDD')                     as "ocdate"
    , to_char(dateadd(year , 1 , acquired_date) , 'YYYYMMDD') as "hldate"
    -- Reduce factor of quantity for options
    , case
        when left(sec_type , 2) in ('cl' , 'pt')
            then abs(quantity) / 100
        else
            abs(quantity)
    end                                                       as "quantity"
    , case
        when coalesce(cost_basis , 0) = 0 and ticker ilike 'MOXYCASH'
            then abs(quantity)
        when coalesce(cost_basis , 0) = 0 and asset_class = 'Cash or Equivalent'
            then abs(quantity)
        else abs(cost_basis)
    end                                                       as "totalcost"
    , iff(current_value > 0 , 1 , 0)::int                     as "iszeromv"
    , null::text                                              as "broker"
    , null::text                                              as "custodian"
    , 'n'                                                     as "pledge"
    , null::decimal(20 , 5)                                   as "pcalc"
    , null::int                                               as "iaction"
    , null::int                                               as "lotnum"
    , lot_id                                                  as "exlotid"
    , lot_id                                                  as "tradematch"
    , null::int                                               as "swaptranid"
    , null::text                                              as "settle"
    , null::text                                              as "ugainm"
    , null::text                                              as "ugainq"
    , null::text                                              as "ugainy"
    , null::text                                              as "userdef1"
    , null::text                                              as "userdef2"
    , null::text                                              as "userdef3"
    , is_intraday_import                                      as is_intraday_import
from {{ ref('moxy__int_tax_lots_build') }}
