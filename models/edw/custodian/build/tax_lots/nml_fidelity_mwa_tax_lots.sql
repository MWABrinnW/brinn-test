select
    t.effective_date                                                             as effective_date
    , t.custodian                                                                as custodian
    , cf.firm                                                                    as firm
    , t.firm_source                                                              as firm_source
    , t.account_custodial                                                        as account_number
    , t.account_custodial_formatted                                              as account_number_formatted

    -- Convenience lookup id.
    , coalesce(
        s.symbol , s.option_symbol_id_occ
        , t.cusip
        , s.security_description_line_1
        , t.security_description_lines_1_6
    )::text(200
    )                                                                            as symbol
    , coalesce(s.symbol , s.option_symbol_id_occ)::text(200)                     as ticker
    , t.cusip::text(200)                                                         as cusip

    , case
        when t.long_short_code ilike 'S'
            then -1 * t.lot_quantity
        else t.lot_quantity
    end::decimal(22 , 5)                                                         as quantity
    , case
        when coalesce(t.lot_quantity , 0) <> 0
            then (t.current_cost_unadjusted_wash / nullif(t.lot_quantity , 0))
        else
            t.current_cost_unadjusted_wash / quantity
    end::decimal(20 , 5)                                                         as cost_per_share
    , t.current_cost_unadjusted_wash                                             as cost_basis
    -- Closing price on the day of lot purchase.
    , coalesce(t.closing_market_price , s.closing_market_price)::decimal(20 , 5) as current_price
    , t.lot_market_value                                                         as current_value

    -- Date the lot was acquired.
    , t.tas_lot_acquired_date                                                    as trade_date
    , t.open_lot_settlement_date                                                 as settlement_date
    -- Date the source system entered the lot.
    , t.lot_received_date                                                        as entry_date_source

    , case
        when t.product_code = 'SEMYM' or sf.ticker is not null
            then 1
        else 0
    end::int                                                                     as is_cash
    , case
        when sf.ticker is not null
            then 1
        else 0
    end::int                                                                     as is_sweep
    , case
        when t.long_short_code ilike 'S'
            then 1
        else 0
    end::int                                                                     as is_short
    , try_to_boolean(t.wash_sale_indicator)::int                                 as is_wash_sale

    , t.open_lot_identifier::text(200)                                           as lot_id_source
    , t.cusip::text(200)                                                         as security_id_source

    , s.option_symbol_id_occ::text(200)                                          as option_ticker
    , t.option_call_put_indicator::text(200)                                     as option_indicator
    , t.option_expiration_date::date                                             as option_expiration_date
    , t.option_strike_price::decimal(20 , 5)                                     as option_strike_price

    , s.isin::text(200)                                                          as isin
    , t.sedol::text(200)                                                         as sedol

    , cmpt.normalized                                                            as product_type
    , cmpt.definition                                                            as product_type_source_definition
    , t.product_code::text(200)                                                  as product_type_source_code

    , cmsd.normalized                                                            as legacy_product_type
    , cmsd.definition                                                            as legacy_product_type_source_definition
    , t.product_code::text(200)                                                  as legacy_product_type_source_code

    , t.is_head                                                                  as is_head
    , t.is_current                                                               as is_current
    , t._source_loaded_at                                                        as _source_loaded_at
    , t._source_file                                                             as _source_file
    , object_construct(
        'nigo_out_of_balance_exception_indicator' , try_to_boolean(t.nigo_out_of_balance_exception_indicator)::int
        , 'nigo_tech_short_exception_indicator' , try_to_boolean(t.nigo_tech_short_exception_indicator)::int
        , 'nigo_cost_exception_indicator' , try_to_boolean(t.nigo_cost_exception_indicator)::int
    )                                                                            as _extra_fields
from {{ ref('fidelity_mwa_history__vw_tlaopen_tax_accounting') }} as t
left join {{ ref('custodian_firms') }} as cf
    on t.firm_source = cf.firm_source
left join {{ ref('fidelity_mwa_history__vw_secmast_1_security') }} as s
    on t.effective_date = s.effective_date
    and t.cusip = s.cusip
left join {{ ref('custodian_mappings') }} as cmpt
    on t.custodian = cmpt.custodian
    and cmpt.field = 'product_type'
    and t.product_code = cmpt.source
left join {{ ref('custodian_mappings') }} as cmsd
    on t.custodian = cmsd.custodian
    and cmsd.field = 'legacy_product_type'
    and t.product_code = cmsd.source
left join {{ ref('int_fidelity_mwa_account_sweep_fund') }} as sf
    on t.effective_date = sf.effective_date
    and t.account_custodial = sf.account_number
    and s.symbol = sf.ticker
where 1 = 1
