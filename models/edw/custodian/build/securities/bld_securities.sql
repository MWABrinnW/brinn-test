{{config(enabled=false)}}

with cte_dates as
(
    select '10/25/2023'::date as effective_date
)
, cte_cusips as
(
    select
        effective_date                            as effective_date
      , coalesce(ticker_symbol, cusip)::text(200) as symbol
      , ticker_symbol::text(200)                  as ticker
      , cusip::text(200)                          as cusip
      , isin::text(200)                           as isin

      , issue_description::text(200)              as security_description
      , security_type_description::text(200)      as cusip_security_type
      , fund_type::text(200)                      as cusip_fund_type
      , income_type::text(200)                    as cusip_income_type
      , bond_form::text(200)                      as cusip_bond_form

      , maturity_date::text(200)                  as maturity_date
      , coupon_rate                               as coupon_rate
      , closing_date::date                        as closing_date

      , try_to_boolean(is_13f)::int               as is_13f

      , where_traded::text(200)                   as where_traded

      , us_cfi_code::text(200)                    as us_cfi_code
      , iso_cfi_code::text(200)                   as iso_cfi_code

      , issuer_num::text(200)                     as cusip_issuer_num
      , issue_num::text(200)                      as cusip_issue_num
      , issue_check::text(200)                    as cusip_issue_check

      , is_head                                   as is_head
      , is_current                                as is_current
      , record_datetime                           as _source_loaded_at
      , source_file::text(200)                    as _source_file
    from {{ ref('cusip_history__base_issues') }}
    where 1 = 1
      and effective_date in (
                                select effective_date
                                from cte_dates
                            )
)

-- get orion security names
-- get schwab/fidelity product types and normalization
-- get schwab/fidelity option symbols
-- get schwab/fidelity security names (prefer fidelity)