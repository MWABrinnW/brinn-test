-- depends_on: {{ ref('orion__base_vw_product') }}
{{ config(
    materialized='incremental',
    unique_key='cusip',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

with cte_check as (
    {%- if is_incremental() -%}
        select
            case
                when (select max(_created_at) from {{ ref('cusip_history__base_issues') }})
                    > (select max(_created_at) from {{ this }})
                    then 1
                when
                    (
                        select convert_timezone('America/Chicago' , (max(createddate) || '+00')::timestamp_tz)
                        from {{ ref('orion__base_vw_product') }}
                    )
                    > (select max(_created_at) from {{ this }})
                    then 1
                else 0
            end::int as needs_update
    {%- else -%}
  select 0::int as needs_update
  {%- endif %}
)

, cte_cusips as (
    select
        coalesce(ticker_symbol , cusip)::text(500) as symbol
        , ticker_symbol::text(500)                 as ticker
        , cusip::text(500)                         as cusip
        , isin::text(500)                          as isin

        , issue_description::text(500)             as cusip_security_description
        , security_type_description::text(500)     as cusip_security_type
        , fund_type::text(500)                     as cusip_fund_type
        , income_type::text(500)                   as cusip_income_type
        , bond_form::text(500)                     as cusip_bond_form

        , maturity_date::text(500)                 as maturity_date
        , coupon_rate                              as coupon_rate
        , closing_date::date                       as closing_date

        , try_to_boolean(is_13f)::int              as is_13f

        , where_traded::text(500)                  as where_traded

        , us_cfi_code::text(500)                   as us_cfi_code
        , iso_cfi_code::text(500)                  as iso_cfi_code

        , issuer_num::text(500)                    as cusip_issuer_num
        , issue_num::text(500)                     as cusip_issue_num
        , issue_check::text(500)                   as cusip_issue_check

        , is_head                                  as is_head
        , is_current                               as is_current
        , _created_at                              as _source_loaded_at
        , _source_file::text(500)                  as _source_file
    from {{ ref('cusip_history__base_issues') }}
    where 1 = 1
        and is_head = 1
        {%- if is_incremental() %}
            and 1 = (select max(t.needs_update) from cte_check as t)
        {%- endif -%}
    qualify row_number() over (partition by cusip order by issue_entry_date desc) = 1
    order by cusip
)

, cte_orion_securities as (
    select
        p.symbol                                                                as symbol
        , p.ticker                                                              as ticker
        , p.cusip                                                               as cusip
        , coalesce(p.product_name_override , p.product_name)::text(500)         as product_name
        , p.product_type                                                        as product_type_name
        , (p.product_category || ' (' || p.product_class_category || ')')::text as asset_category
        , p.asset_class::text                                                   as asset_class
        , p.system_key                                                          as orion_instance
        , p._created_at                                                         as orion_loaded_at
    from {{ ref('orion__bld_products') }} as p
    where 1 = 1
        and p.is_head = 1
        and coalesce(p.cusip , '') <> ''
        {%- if is_incremental() %}
            and 1 = (select max(t.needs_update) from cte_check as t)
        {%- endif -%}
    qualify
        row_number() over (
            partition by p.cusip order by
                case
                    when p.fkalclient = 568 then 1
                    when p.fkalclient = 2102 then 2
                    when p.fkalclient = 1945 then 3
                    when p.fkalclient = 2623 then 4
                    when p.fkalclient = 3394 then 5
                    when p.fkalclient = 2878 then 6
                    else 7
                end
        ) = 1
    order by cusip
)

select
    a.symbol                             as symbol
    , a.ticker                           as ticker
    , a.cusip                            as cusip
    , o.product_name                     as product_name
    , o.product_type_name                as product_type
    , o.asset_category                   as asset_category
    , o.asset_class                      as asset_class
    , a.cusip_security_description       as cusip_security_description
    , a.cusip_security_type              as cusip_security_type
    , a.cusip_fund_type                  as cusip_fund_type
    , a.cusip_income_type                as cusip_income_type
    , a.cusip_bond_form                  as cusip_bond_form
    , a.maturity_date                    as maturity_date
    , a.coupon_rate                      as coupon_rate
    , a.closing_date                     as closing_date
    , a.is_13f                           as is_13f
    , a.where_traded                     as where_traded
    , a.isin                             as isin
    , a.us_cfi_code                      as us_cfi_code
    , a.iso_cfi_code                     as iso_cfi_code
    , a.cusip_issuer_num                 as cusip_issuer_num
    , a.cusip_issue_num                  as cusip_issue_num
    , a.cusip_issue_check                as cusip_issue_check
    , o.orion_instance                   as orion_instance_source
    , o.orion_loaded_at::timestamp       as orion_loaded_at

    , row_number() over (
        partition by a.ticker order by
            case when o.orion_instance = 'Mariner, LLC' then 1 else 2 end
            , case when a.where_traded = 'NYSE' then 1 else 2 end
            , case when a.is_13f = 1 then 1 else 2 end
    )                                    as rn_ticker

    , current_timestamp()::timestamp_ltz as _created_at
    , a._source_loaded_at                as _source_loaded_at
    , a._source_file                     as _source_file
from cte_cusips as a
left join cte_orion_securities as o
    on a.cusip = o.cusip
