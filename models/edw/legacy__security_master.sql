{{ config(materialized='table', grants = {'+select': ['db_edw_general_mwa_r']}) }}

with cusip_morningstar as (
    select
        coalesce(issue.cusip , issue.ticker_symbol , ms.ticker) as cusip
        , coalesce(issue.ticker_symbol , ms.ticker)             as ticker
        , issue.maturity_date                                   as maturity
        , issue.security_type_description                       as iso_cfi_type
        , issue.iso_cfi_code                                    as iso_cfi_code
        , cfi_map.cfi_category                                  as cfi_category
        , cfi_map.cfi_attribute                                 as cfi_attribute
        , issuer.issuer_name                                    as name
        , coalesce(ms.fundname , issue.fisn)                    as mstar_name
        , ms.globalcategoryname                                 as mstar_globalcategoryname
        , ms.categoryname                                       as mstar_categoryname
        , ms.mtype                                              as mstar_mtype
        , ms.securitytype                                       as mstar_securitytype
        , ms.equitystyleboxname                                 as style_box_equity
        , ms.fixedincomestyleboxname                            as style_box_fixedincome
        , ms.shareclasstype                                     as share_class
        , ms.fundstandardname                                   as fund_family_name
        , 'cgs'                                                 as record_source
        , current_timestamp()                                   as _created_at

    from {{ ref('cusip_history__base_issues') }} as issue
    left join {{ ref('cusip_history__base_cfi_map') }} as cfi_map
        on substring(issue.iso_cfi_code , 1 , 2) = cfi_map.iso_cfi_prefix
    left join {{ ref('cusip_history__base_issuers') }} as issuer
        on issue.issuer_num = issuer.issuer_number
        and issue.effective_date = issuer.effective_date
    left join {{ ref('morningstar_history__stg_fund') }} as ms
        on issue.cusip = ms.cusip
        and issue.effective_date = ms.effective_date
    where issue.effective_date = (select max(temp.effective_date) from {{ ref('cusip_history__base_issues') }} as temp)
        and issue.iso_cfi_code is not null
        and coalesce(issue.cusip , issue.ticker_symbol , ms.ticker) is not null
        and issue.is_head = 1
    qualify row_number() over (
            partition by coalesce(issue.cusip , issue.ticker_symbol , ms.ticker)
            order by coalesce(issue.cusip , issue.ticker_symbol , ms.ticker)
        ) = 1
)

, fidelity as (
    select
        s.cusip                                                                 as cusip
        , s.symbol                                                              as ticker
        , concat(s.security_description_line_1 , s.security_description_line_2) as name
        , m.security_type                                                       as security_type
        , m.security_subtype                                                    as security_subtype
        , trim(s.isin)                                                          as isin
        , 'fidelity'                                                            as record_source

    from {{ ref('fidelity_mwa_history__vw_raw_secmast_1_security') }} as s
    left join {{ ref('fidelity_mwa_history__stg_security_map') }} as m
        on s.security_type = m.security_type_code
        and s.security_type_modifier = m.security_modifier_code
        and m.security_type <> 'Option'
    where s.is_head = 1
    qualify row_number() over (
            partition by s.cusip
            order by s.cusip
        ) = 1
)

, orion as (
    select
        product_name                as orn_product_name
        , ticker                    as orn_ticker
        , cusip                     as cusip
        , product_type              as orn_product_type
        , product_subtype           as orn_product_subtype
        , product_class             as orn_asset_class
        , product_class_description as orn_product_desc
        , product_class_category    as category
        , product_category          as orn_product_category
        , is_custodial_cash         as orn_is_cash
        , 'orion'                   as record_source
    from {{ ref('orion__products') }}
    where true
        and fkalclient = '568'
        and cusip is not null
        and (
            len(cusip) = 9
            or (ticker = cusip and product_type <> 'Option')
        )
    qualify row_number() over (
            partition by cusip
            order by cusip
        ) = 1
)

, schwab as (
    select
        s.cusip                                                  as cusip
        , s.ticker_symbol                                        as ticker
        , s.legacy_security_type                                 as security_type
        , concat(s.product_category_code , '-' , s.product_code) as security_subtype
        , concat(
            s.security_description_line_1
            , s.security_description_line_2
            , s.security_description_line_3
        )                                                        as name
        , trim(s.isin)                                           as isin
        , 'schwab'                                               as record_source

    from {{ ref('schwab__base_securities') }} as s
    where s.cusip is not null
        and s.is_head = 1
    qualify row_number() over (
            partition by cusip
            order by cusip
        ) = 1
)

, cusip_spine as (
    select cusip from cusip_morningstar
    union distinct
    select cusip from orion
    union distinct
    select cusip from fidelity
    union distinct
    select cusip from schwab
)

select
    coalesce(m.cusip , o.cusip , f.cusip , s.cusip)                                   as cusip
    , coalesce(m.ticker , o.orn_ticker , f.ticker , s.ticker)                         as ticker
    , m.iso_cfi_type                                                                  as iso_cfi_type
    , m.iso_cfi_code                                                                  as iso_cfi_code
    , coalesce(m.name , o.orn_product_name , f.name , s.name)                         as name
    , m.cfi_category                                                                  as cfi_category
    , m.cfi_attribute                                                                 as cfi_attribute
    , m.mstar_globalcategoryname                                                      as mstar_globalcategoryname
    , m.mstar_categoryname                                                            as mstar_categoryname
    , m.mstar_mtype                                                                   as mstar_mtype
    , m.mstar_securitytype                                                            as mstar_securitytype
    , m.style_box_equity                                                              as style_box_equity
    , m.style_box_fixedincome                                                         as style_box_fixedincome
    , m.share_class                                                                   as share_class
    , m.maturity                                                                      as maturity
    , null::text                                                                      as fund_family_id
    , m.fund_family_name                                                              as fund_family_name
    , m.mstar_name                                                                    as mstar_name
    , o.orn_product_name                                                              as orn_product_name
    , o.orn_product_subtype                                                           as orn_product_subtype
    , o.orn_product_type                                                              as orn_product_type
    , o.orn_asset_class                                                               as orn_asset_class
    , o.orn_product_category                                                          as orn_product_category
    , null::text                                                                      as orn_adv_category
    , null::text                                                                      as orn_risk_category
    , coalesce(f.security_type , s.security_type)                                     as fid_security_type
    , coalesce(f.security_subtype , s.security_subtype)                               as fid_security_subtype
    , coalesce(f.name , s.name)                                                       as fid_name
    , coalesce(m.record_source , o.record_source , f.record_source , s.record_source) as record_source
    , current_timestamp()                                                             as record_datetime
    , current_date()                                                                  as record_date
    , o.orn_product_desc                                                              as orn_product_desc
    , o.orn_is_cash::boolean                                                          as orn_is_cash
    , coalesce(f.isin , s.isin)                                                       as isin
from cusip_spine as a
left join cusip_morningstar as m
    on a.cusip = m.cusip
left join orion as o
    on a.cusip = o.cusip
left join fidelity as f
    on a.cusip = f.cusip
left join schwab as s
    on a.cusip = s.cusip
