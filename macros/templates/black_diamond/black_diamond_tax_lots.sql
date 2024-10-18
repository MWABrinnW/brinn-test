{%- macro black_diamond_tax_lots(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}

select
    'black_diamond'::text(200)                     as system_name
    , '{{ instance }}'::text(200)                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , '{{ firm_source }}'::text(200)               as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , h.value:AccountID::string                    as account_id
    , h.value:TaxLotID::string                     as tax_lot_id
    , h.value:Ticker::string                       as ticker
    , h.value:DisplayCusip::string                 as display_cusip
    , h.value:AssetName::string                    as asset_name
    , h.value:AssetId::number                      as asset_id
    , h.value:TradeDate::date                      as trade_date
    , h.value:OpenDate::date                       as open_date
    , h.value:EMV::decimal(20 , 6)                 as emv
    , h.value:Units::decimal(20 , 6)               as units
    , h.value:CostBasis::decimal(20 , 6)           as cost_basis
    , h.value:UnitCost::decimal(20 , 6)            as unit_cost
    , h.value:PriceFactor::decimal(20 , 6)         as price_factor
    , h.value:PaydownFactor::decimal(20 , 6)       as paydown_factor
    , h.value:Cash::boolean                        as cash
    , a.record_id                                  as record_id
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                            as _source_loaded_at
    {%- if extra_columns -%}
    {{ extra_columns }}
    {%- endif %}
from {{ src }} as a
, lateral flatten(input => a.json:TaxLots) as h
{%- if extra_joins %}
{{ extra_joins }}
{% endif -%}

{%- endmacro -%}