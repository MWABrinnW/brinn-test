{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
) }}

{% set start_date = cvar('start_date_custodian') %}
{% set lookback = cvar('lookback') %}

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
        and firm_source not in ('other', 'sma', 'unknown')
    group by 1,2,3
    order by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {%- set src_model = 'fidelity_baystate_history__vw_nabase_101_account' %}
    select effective_date, custodian, firm_source, max(_source_loaded_at) as _created_at, {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Exclude auxillary/bunk firm sources because it muddies up the comparison.
        and firm_source not in ('other', 'sma', 'unknown')
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
)

, date_spine as (
    select effective_date, custodian, firm_source from source_summary group by all
    union
    select effective_date, custodian, firm_source from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date
        , a.custodian
        , a.firm_source
        , s._created_at as source_created_at
        , d._created_at as destination_created_at
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

, cte_mailing_address as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,fixed_format_address_line_1
    ,fixed_format_address_line_2
    ,fixed_format_address_line_3
    ,fixed_format_po_box
    ,fixed_format_city_name
    ,fixed_format_state
    ,fixed_format_postal_code
    ,country_name
  from {{ ref('fidelity_baystate_history__vw_nabase_2x1_mailing_address') }}
  where true
    and record_number = '211'
    and effective_date in (select distinct effective_date from dates_to_refresh)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)

)

, cte_legal_address as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,fixed_format_address_line_1
    ,fixed_format_address_line_2
    ,fixed_format_address_line_3
    ,fixed_format_po_box
    ,fixed_format_city_name
    ,fixed_format_state
    ,fixed_format_postal_code
    ,country_name
  from {{ ref('fidelity_baystate_history__vw_nabase_2x2_legal_address') }}
  where true
    and record_number = '212'
    and effective_date in (select distinct effective_date from dates_to_refresh)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
  order by effective_date
)

, cte_notification as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,email_address
  from {{ ref('fidelity_baystate_history__vw_nabase_3x0_notification') }}
  where true
    and record_number = '310'
    and effective_date in (select distinct effective_date from dates_to_refresh)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
  order by effective_date
)

, cte_customer as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,fixed_name_format_first
    ,fixed_name_format_middle
    ,fixed_name_format_last
    ,telephone_number_1
  from {{ ref('fidelity_baystate_history__vw_nabase_2x0_customer') }}
  where true
    and record_number = '210'
    and effective_date in (select distinct effective_date from dates_to_refresh)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
  order by effective_date
)

, cte_account as (
  select
      a.effective_date
    , 'fidelity' as custodian
    , 'baystate' as firm_source
    , a.account_custodial
    , a.account_custodial_formatted
    , a.registration_type
    , case
        when nvl(a.establish_date, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(a.establish_date, 'yyyymmdd') end::date                      as establish_date
    , a.irs_no
    , a.irs_code
    , case
        when nvl(a.birth_date, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(a.birth_date, 'yyyymmdd') end::date                          as birth_date
    , a.cost_basis_disposal_method_code
    , a.fee_authorization_code
    , a.prime_broker_indicator
    , a.portfolio_margin_indicator
    , a.multiple_margin_indicator
    , a.option_agreement
    , a.restriction_code_partial
    , a._source_loaded_at
    , a._source_file
    , a.proxy_vote_indicator
    from {{ ref('fidelity_baystate_history__vw_raw_nabase_101_account') }} a
    where true
      and a.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
    order by a.effective_date
)

, cte_business as (
  select
    effective_date, account_custodial, fixed_format_business_trust_name_1
    from {{ ref('fidelity_baystate_history__vw_nabase_102_business') }}
    where true
      and effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
    order by effective_date
)

, cte_person as (
  select
    effective_date, account_custodial, fixed_format_first_name_1, fixed_format_middle_name_1, fixed_format_last_name_1
      , fixed_format_first_name_2, fixed_format_middle_name_2, fixed_format_last_name_2
      , fixed_format_first_name_3, fixed_format_middle_name_3, fixed_format_last_name_3
    from {{ ref('fidelity_baystate_history__vw_nabase_102_person') }}
    where true
      and effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
    order by effective_date
)

, cte_all_accounts as
(
  select
      a.effective_date
    , a.custodian
    , a.firm_source
    , a.account_custodial
    , a.account_custodial_formatted
    , a.registration_type
    , a.establish_date
    , a.irs_no
    , a.irs_code
    , a.birth_date
    , a.cost_basis_disposal_method_code
    , a.fee_authorization_code
    , a.prime_broker_indicator
    , a.portfolio_margin_indicator
    , a.multiple_margin_indicator
    , a.option_agreement
    , a.restriction_code_partial
    , a._source_loaded_at
    , a._source_file
    , case
        when b.account_custodial is not null
          then b.fixed_format_business_trust_name_1
        else
          nullif(
            replace(
              regexp_replace(
                case
                    -- when all match (use 1)
                    when concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                          concat(p.fixed_format_first_name_2, p.fixed_format_middle_name_2, p.fixed_format_last_name_2)
                        and concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                            concat(p.fixed_format_first_name_3, p.fixed_format_middle_name_3, p.fixed_format_last_name_3)
                        then concat_ws(' '
                        , nvl(fixed_format_first_name_1, '')
                        , nvl(fixed_format_middle_name_1, '')
                        , nvl(fixed_format_last_name_1, '')
                        )
                    -- when 1 matches 2 (use 1 & 3)
                    when concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                          concat(p.fixed_format_first_name_2, p.fixed_format_middle_name_2, p.fixed_format_last_name_2)
                        then concat_ws(' '
                        , nvl(p.fixed_format_first_name_1, '')
                        , nvl(p.fixed_format_middle_name_1, '')
                        , nvl(p.fixed_format_last_name_1, '')
                        , iff(p.fixed_format_last_name_3 is not null, '&', '')
                        , nvl(p.fixed_format_first_name_3, '')
                        , nvl(p.fixed_format_middle_name_3, '')
                        , nvl(p.fixed_format_last_name_3, '')
                        )
                    -- when 1 matches 3 or when 2 matches 3  (use 1 & 2)
                    when concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                          concat(p.fixed_format_first_name_3, p.fixed_format_middle_name_3, p.fixed_format_last_name_3)
                        or concat(p.fixed_format_first_name_2, p.fixed_format_middle_name_2, p.fixed_format_last_name_2) =
                            concat(p.fixed_format_first_name_3, p.fixed_format_middle_name_3, p.fixed_format_last_name_3)
                        then concat_ws(' '
                        , nvl(p.fixed_format_first_name_1, '')
                        , nvl(p.fixed_format_middle_name_1, '')
                        , nvl(p.fixed_format_last_name_1, '')
                        , iff(p.fixed_format_last_name_2 is not null, '&', '')
                        , nvl(p.fixed_format_first_name_2, '')
                        , nvl(p.fixed_format_middle_name_2, '')
                        , nvl(p.fixed_format_last_name_2, '')
                        )
                    else concat_ws(' '
                        , nvl(p.fixed_format_first_name_1, '')
                        , nvl(p.fixed_format_middle_name_1, '')
                        , nvl(p.fixed_format_last_name_1, '')
                        , case
                              when p.fixed_format_last_name_3 is not null then ','
                              when p.fixed_format_last_name_2 is not null then '&'
                              else '' end
                        , nvl(p.fixed_format_first_name_2, '')
                        , nvl(p.fixed_format_middle_name_2, '')
                        , nvl(p.fixed_format_last_name_2, '')
                        , iff(p.fixed_format_last_name_3 is not null, '&', '')
                        , nvl(p.fixed_format_first_name_3, '')
                        , nvl(p.fixed_format_middle_name_3, '')
                        , nvl(p.fixed_format_last_name_3, '')
                        )
                    end,
              '(\\s{2,})', ' '), ' ,', ','), '')::varchar(500)
          end                                                     as account_title
          , a.proxy_vote_indicator                                as proxy_vote_indicator
    from cte_account a
    left join cte_business b
      on a.effective_date = b.effective_date
      and a.account_custodial = b.account_custodial
      and b.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
    left join cte_person p
      on a.effective_date = p.effective_date
      and a.account_custodial = p.account_custodial
      and p.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
    where true
      and a.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
    order by a.effective_date
)

select
    a.effective_date
  , custodian                                                  as custodian
  , firm_source                                                as firm_source
  , a.account_custodial                                        as account_number
  , a.account_custodial_formatted                              as account_number_formatted

  , null                                                       as custodian_link -- branch/firm/gnumber? primary g number but how?
  , null                                                       as custodian_link_detail
  , a.registration_type                                        as account_type_source_code --account_classification or registration_type
  , a.establish_date                                           as opened_date

  , a.account_title                                            as account_title
  , c.fixed_name_format_first                                  as first_name
  , c.fixed_name_format_middle                                 as middle_name
  , c.fixed_name_format_last                                   as last_name

  , replace(a.irs_no,'-','')::varchar(20)                      as irs_id
  , case
        when a.irs_code = 's'
            then 'ssn'
        when a.irs_code = 't'
            then 'tin'
        end                                                    as irs_id_type
  , a.birth_date                                               as birth_date

  , n.email_address                                            as email_address
  , replace(c.telephone_number_1,'-','')::varchar(20)          as phone
  , a.cost_basis_disposal_method_code                          as cost_basis_method_mutual_funds
  , a.cost_basis_disposal_method_code                          as cost_basis_method_non_mutual_funds
  , null::int                                                  as is_taxable
  , case when a.fee_authorization_code = 'f' then 1 else 0 end as is_fee_authorized
  , case
        when a.prime_broker_indicator in ('0', '7')
            then 1
        else 0 end                                             as is_prime_broker
  , case
       when a.portfolio_margin_indicator = 'P'
            then 1
        else 0 end                                             as is_margin_enabled
  , case
        when a.multiple_margin_indicator = 'Y'
            then 1
        else 0 end                                             as is_multiple_margin_enabled
  , a.option_agreement                                         as options_approval_level
  , a.restriction_code_partial                                 as restrictions_source_code
  , ltrim(regexp_replace(concat_ws(' '
                             , nvl(ma.fixed_format_address_line_1, '')
                             , nvl(ma.fixed_format_address_line_2, '')
                             , nvl(ma.fixed_format_address_line_3, '')
                             , nvl(ma.fixed_format_po_box, '')), '(\s{2,})', ' '), ' ')
                                                               as mailing_address_street
  , ma.fixed_format_city_name                                  as mailing_address_city
  , ma.fixed_format_state                                      as mailing_address_state
  , ma.fixed_format_postal_code                                as mailing_address_zip
  , ma.country_name                                            as mailing_address_country
  , ltrim(regexp_replace(concat_ws(' '
                             , nvl(la.fixed_format_address_line_1, '')
                             , nvl(la.fixed_format_address_line_2, '')
                             , nvl(la.fixed_format_address_line_3, '')
                             , nvl(la.fixed_format_po_box, '')), '(\s{2,})', ' '), ' ')
                                                               as legal_address_street
  , la.fixed_format_city_name                                  as legal_address_city
  , la.fixed_format_state                                      as legal_address_state
  , la.fixed_format_postal_code                                as legal_address_zip
  , la.country_name                                            as legal_address_country
  , current_timestamp()::timestamp                             as _created_at
  , a._source_loaded_at::timestamp                             as _source_loaded_at
  , a._source_file                                             as _source_file
from cte_all_accounts a
left join cte_mailing_address ma
   on a.effective_date = ma.effective_date
   and a.account_custodial = ma.account_custodial
   and ma.record_number = '211'
    and ma.effective_date in (select distinct effective_date from dates_to_refresh)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
left join cte_legal_address la
   on a.effective_date = la.effective_date
   and a.account_custodial = la.account_custodial
   and la.record_number = '212'
      and la.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
left join cte_notification n
  on a.effective_date = n.effective_date
  and a.account_custodial = n.account_custodial
  and n.record_number = '310'
      and n.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
left join cte_customer c
  on a.effective_date = c.effective_date
  and a.account_custodial = c.account_custodial
  and c.record_number = '210'
      and c.effective_date in (select distinct effective_date from dates_to_refresh)
      -- Offer the snowflake query optimizer a chance to prune the query early
      -- if there are no dates to refresh.
      and exists (select 1 from dates_to_refresh)
where true
    and a.effective_date in (select distinct effective_date from dates_to_refresh)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
