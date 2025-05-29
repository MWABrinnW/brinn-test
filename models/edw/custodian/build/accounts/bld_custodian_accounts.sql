{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'custodian']
)}}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set source_models = [
          'nml_schwab_mwa_accounts'
         ,'nml_schwab_mps_accounts'
         ,'nml_schwab_swag_accounts'
         ,'nml_fidelity_baystate_accounts'
         ,'nml_fidelity_mwa_accounts'
         ,'nml_fidelity_mps_accounts'
         ,'nml_fidelity_swag_accounts'
         ,'nml_pershing_mwa_accounts'
         ,'nml_pershing_mps_accounts'
         ,'nml_tda_mwa_accounts'
         ,'nml_tda_mps_accounts'
         ,'nml_tda_swag_accounts'
         ,'nml_fidelitycgf_mwa_accounts'
         ,'nml_fidelitycgf_mps_accounts'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by 1,2,3
    order by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {% for nml_model in source_models -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, {{"'" ~ nml_model ~ "'"}} as model_source
    from {{ ref(nml_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date, custodian, firm_source from source_summary group by all
    union
    select effective_date, custodian, firm_source from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , a.custodian       as custodian
        , a.firm_source     as firm_source
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.custodian = s.custodian
        and a.firm_source = s.firm_source
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.custodian = d.custodian
        and a.firm_source = d.firm_source
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

--------------------------------------------------------------

, cte_accounts as (
    {% for nml_model in source_models -%}
    select
        effective_date
        , custodian
        , firm
        , firm_source
        , account_number
        , account_number_formatted
        , custodian_link
        , custodian_link_detail
        , rep_link
        , rep_link_detail
        , account_type
        , account_type_source_definition
        , account_type_source_code
        , opened_date
        , account_title
        , first_name
        , middle_name
        , last_name
        , irs_id
        , irs_id_type
        , birth_date
        , email_address
        , phone
        , cost_basis_method_mutual_funds
        , cost_basis_method_non_mutual_funds
        , is_taxable
        , is_fee_authorized
        , is_prime_broker
        , is_margin_enabled
        , options_approval_level
        , restrictions_source_code
        , is_multiple_margin_enabled
        , restrictions_source_definition
        , restrictions
        , mailing_address_street
        , mailing_address_city
        , mailing_address_state
        , mailing_address_zip
        , mailing_address_country
        , legal_address_street
        , legal_address_city
        , legal_address_state
        , legal_address_zip
        , legal_address_country
        , _created_at
        , _source_loaded_at
        , _source_file
    from {{ ref(nml_model) }}
    where true
        and effective_date in (select distinct effective_date from dates_to_refresh)

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, cte_cash as (
    select
          effective_date
        , custodian
        , firm
        , firm_source
        , account_number
        , account_number_formatted
        , total_cash_value::decimal(20, 2)   as cash_value
        , money_market_value::decimal(17, 2) as money_market_value
    from {{ ref('bld_custodian_cash_balances') }}
    where true
        and effective_date in (select distinct effective_date from dates_to_refresh)
)

, cte_holdings as (
    select
          effective_date
        , custodian
        , firm
        , firm_source
        , account_number
        , account_number_formatted
        , sum(nvl(market_value,0))::decimal(17, 2)  as total_value
        , sum(case
                when nvl(is_cash,0) = 0
                then nvl(market_value,0)
                else 0 end)::decimal(17, 2)         as holdings_value
        , sum(case
                when nvl(is_cash,0) = 1
                then nvl(market_value,0)
                else 0 end)::decimal(17, 2)         as cash_value
    from {{ ref('custodian_holdings') }}
    where true
        and effective_date in (select distinct effective_date from dates_to_refresh)
    group by effective_date, custodian, firm, firm_source
            , account_number, account_number_formatted
)

, cte_accounts_with_values as (
    select
        a.effective_date                                  as effective_date
        , a.custodian::text(200)                          as custodian
        , a.firm::text(200)                               as firm
        , a.firm_source::text(200)                        as firm_source
        , a.account_number::text(200)                     as account_number
        , a.account_number_formatted::text(200)           as account_number_formatted
        , a.custodian_link::text(200)                     as custodian_link
        , a.custodian_link_detail::text(200)              as custodian_link_detail
        , a.rep_link::text(200)                           as rep_link
        , a.rep_link_detail::text(200)                    as rep_link_detail
        , h.total_value                                   as total_value
        , h.cash_value                                    as cash_value
        , a.account_type::text(200)                       as account_type
        , a.account_type_source_definition::text(200)     as account_type_source_definition
        , a.account_type_source_code::text(200)           as account_type_source_code
        , a.opened_date::date                             as opened_date
        , a.account_title::text(200)                      as account_title
        , a.first_name::text(200)                         as first_name
        , a.middle_name::text(200)                        as middle_name
        , a.last_name::text(200)                          as last_name
        , a.irs_id::text(200)                             as irs_id
        , a.irs_id_type::text(200)                        as irs_id_type
        , a.birth_date::date                              as birth_date
        , a.email_address::text(200)                      as email_address
        , a.phone::text(200)                              as phone
        , a.cost_basis_method_mutual_funds::text(200)     as cost_basis_method_mutual_funds
        , a.cost_basis_method_non_mutual_funds::text(200) as cost_basis_method_non_mutual_funds
        , a.is_taxable::int                               as is_taxable
        , a.is_fee_authorized::int                        as is_fee_authorized
        , a.is_prime_broker::int                          as is_prime_broker
        , a.is_margin_enabled::int                        as is_margin_enabled
        , a.is_multiple_margin_enabled::int               as is_multiple_margin_enabled
        , a.options_approval_level::text(200)             as options_approval_level
        , a.restrictions_source_code::text(200)           as restrictions_source_code
        , a.restrictions_source_definition::text(200)     as restrictions_source_definition
        , a.restrictions::text(200)                       as restrictions
        , a.mailing_address_street::text(200)             as mailing_address_street
        , a.mailing_address_city::text(200)               as mailing_address_city
        , a.mailing_address_state::text(200)              as mailing_address_state
        , a.mailing_address_zip::text(200)                as mailing_address_zip
        , a.legal_address_street::text(200)               as legal_address_street
        , a.legal_address_city::text(200)                 as legal_address_city
        , a.legal_address_state::text(200)                as legal_address_state
        , a.legal_address_zip::text(200)                  as legal_address_zip
        , a.legal_address_country::text(200)              as legal_address_country
        , a._source_loaded_at::timestamp                  as _source_loaded_at
        , a._source_file::text(200)                       as _source_file
    from cte_accounts as a
    left join cte_holdings as h
        on a.effective_date = h.effective_date
        and a.custodian = h.custodian
        and a.firm_source = h.firm_source
        and a.account_number = h.account_number
    )

select
    *
    , row_number() over(
        partition by effective_date, custodian, firm_source, account_number
        order by _source_loaded_at desc
        ) as rn_firm_source
    , row_number() over(partition by effective_date, custodian, account_number
                    order by {{ firm_source_rank() }}
                    ) as rn_global
    , current_timestamp()::timestamp as _created_at
from cte_accounts_with_values
order by effective_date, custodian, firm_source, account_number
