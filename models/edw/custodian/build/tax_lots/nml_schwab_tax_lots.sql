select
    t.effective_date                             as effective_date
    , t.custodian                                as custodian
    , cf.firm                                    as firm
    , t.firm_source                              as firm_source
    , t.account_number                           as account_number
    , left(t.account_number , 4)
    || '-'
    || right(t.account_number , 4)               as account_number_formatted

    -- Convenience lookup id.
    , coalesce(
        t.symbol_ticker
        , t.cusip
        , s.security_description_line_1
        , cmpt.definition
    )::text(500)                                 as symbol
    , t.symbol_ticker                            as ticker
    , t.cusip                                    as cusip
    , t.current_quantity                         as quantity
    , t.cost_per_share_share_cost_amount         as cost_per_share
    , t.cost_basis_unamortized_cost_basis_amount as cost_basis
    , s.closing_price::decimal(20 , 5)           as current_price
    , t.current_market_value::decimal(20 , 5)    as current_value

    -- Date the lot was acquired.
    , t.acquired_date::date                      as trade_date
    , null::date                                 as settlement_date
    -- Date the source system entered the lot.
    , t.original_purchase_date::date             as entry_date_source

    , case
        when t.symbol_ticker = 'SWGXX'
            then 1
        else 0
    end::int                                     as is_cash
    , case
        when t.symbol_ticker = 'SWGXX'
            then 1
        else 0
    end::int                                     as is_sweep
    , case
        when t.long_short_indicator ilike 'S'
            then 1
        else 0
    end::int                                     as is_short
    , try_to_boolean(t.wash_sale_impacted)::int  as is_wash_sale

    , null::varchar(500)                         as lot_id_source
    , t.item_issue_id::text(500)                 as security_id_source

    , t.options_display_symbol::text(500)        as option_ticker
    , s.option_call_or_put_code::text(500)       as option_indicator
    , s.option_expiration_date::date             as option_expiration_date
    , s.strike_price_amount::decimal(20 , 5)     as option_strike_price

    , t.isin::text(500)                          as isin
    , t.sedol::text(500)                         as sedol

    , cmpt.normalized::text(500)                 as product_type
    , cmpt.definition::text(500)                 as product_type_source_definition
    , t.product_code::text(500)                  as product_type_source_code

    , cmsd.normalized::text(500)                 as legacy_product_type
    , cmsd.definition::text(500)                 as legacy_product_type_source_definition
    , t.product_code::text(500)                  as legacy_product_type_source_code

    , t.is_head                                  as is_head
    , t.is_current                               as is_current
    , greatest(
        t._source_loaded_at
        , s._source_loaded_at
    )                                            as _source_loaded_at
    , t._source_file::text(500)                  as _source_file
    , object_construct(
        'product_category_code' , t.product_category_code
    )::variant                                   as _extra_fields
from {{ ref('schwab__base_tax_lots') }} as t
left join {{ ref('custodian_firms') }} as cf
    on t.firm_source = cf.firm_source
left join {{ ref('schwab__base_securities') }} as s
    on t.effective_date = s.effective_date
    and t.item_issue_id = s.item_issue_id
    and t.firm_source = s.firm_source
    and s.rn = 1
left join {{ ref('custodian_mappings') }} as cmpt
    on t.custodian = cmpt.custodian
    and cmpt.field = 'product_type'
    and t.product_code = cmpt.source
left join {{ ref('custodian_mappings') }} as cmsd
    on t.custodian = cmsd.custodian
    and cmsd.field = 'legacy_product_type'
    and s.legacy_security_type = cmsd.source
where 1 = 1
    and t.rn_firm_source = 1
