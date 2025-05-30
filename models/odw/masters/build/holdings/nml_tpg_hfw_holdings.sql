select
    --- [system] ---------------------------------------------------------------------
    a.effective_date::date                  as effective_date
    , a.system_name::text(200)              as system_name
    , a.system_instance::text(200)          as system_instance
    , a.system_key::text(200)               as system_key
    , a.firm_source::text(200)              as firm_source
    --- [account + holdings] ---------------------------------------------------------
    , a.account_number::text(200)           as account_id
    , a.account_number_formatted::text(200) as account_number_formatted
    , a.account_number::text(200)           as account_number
    , null::text(200)                       as client_id
    , a.client_name::text(200)              as client_name
    , null::text(200)                       as custodian
    , a.cusip::text(200)                    as cusip
    , null::text(200)                       as ticker
    , null::int                             as is_ticker_cusip
    , null::int                             as is_custodial_cash
    , null::text(200)                       as security_id
    , a.cusip_type_desc::text(200)          as security_name
    , a.security_type::text(200)            as security_type
    , null::text(200)                       as security_subtype
    , null::text(200)                       as asset_class
    , a.market_value::number(19 , 9)        as market_value
    , null::number(19 , 9)                  as quantity
    , a.price::number(19 , 9)               as price
    , null::number(19 , 9)                  as price_unfactored
    , null::number(19 , 9)                  as factor
    , a.cost_basis::number(19 , 9)          as cost_basis
    --- [meta] ----------------------------------------------------------------------
    , a.is_head::int                        as is_head
    , a.is_current::int                     as is_current
    , a._created_at::datetime               as _created_at
    , a._created_at::datetime               as _source_loaded_at
    , a._source_file::text(200)             as _source_file
from {{ ref('tpg_hfw__stg_holdings') }} as a
inner join {{ ref('dates') }} as dt
    on a.effective_date = dt.date_key
    and dt.is_market_day = 1
-- dedupes holdings records found in multiple files for the same effective date
where 1 = 1
    and is_head_for_day = 1
-- Pick only one record per position_id, just in case there is duplication.
qualify row_number() over (
        partition by a.effective_date , a._created_at , a.account_number , a.position_id
        order by a._created_at desc , a._source_file desc
    ) = 1
