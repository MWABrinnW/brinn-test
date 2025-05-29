{%-
    set model_list = [
        'custodian_holdings_schwab',
        'custodian_holdings_fidelity',
        'custodian_holdings_fidelity_cgf',
        'custodian_holdings_pershing',
    ]
-%}

{%- set column_list -%}
    a.effective_date, a.custodian, a.firm, a.firm_source, a.account_number, a.account_number_formatted, a.symbol, a.ticker, a.cusip, a.security_name, a.security_type, a.security_name_source
     , a.is_cash, a.is_sweep, a.market_value, a.units_shares, a.quantity, a.quantity_settled, a.quantity_unsettled, a.price, a.price_unfactored, a.factor, a.cost_basis, a.is_13f
     , a.asset_category, a.asset_class, a.cusip_security_type, a.cusip_fund_type, a.cusip_income_type, a.underlying_ticker, a.underlying_cusip, a.underlying_security_id_source
     , a.product_type, a.product_type_source_definition, a.product_type_source_code, a.account_type, a.account_type_source, a.account_type_source_code, a.security_id_source
     , a.isin, a.sedol, a.extra_fields, a.rn_firm_source, a.rn_global, a._source_loaded_at, a._source_file, a._created_at
{%- endset %}

with max_dates as (
    {%- for mdl in model_list %}
        select max(effective_date) as effective_date
        from {{ ref('custodian_holdings_schwab') }}

        {%- if not loop.last %}

            union all

        {%- endif %}
    {%- endfor %}
)

, head_date as (
    select max(effective_date) as effective_date
    from max_dates
)

{%- for mdl in model_list %}


    select
        {{ column_list }}
        , case
            when a.effective_date = b.effective_date
                then 1
            else 0
        end::int as is_head
    from {{ ref(mdl) }} as a
    left join head_date as b
        on a.effective_date = b.effective_date

    {%- if not loop.last %}

        union all

    {%- endif %}
{%- endfor %}


