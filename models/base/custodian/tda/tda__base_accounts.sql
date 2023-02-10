{{ config(materialized = 'table', enabled = false) }}
-- depends_on: {{ ref('tda_mwa_history__vw_demographics') }}
-- depends_on: {{ ref('tda_mwa_history__vw_positions') }}
-- depends_on: {{ ref('dates') }}

{# Prepare the query we'll use to determine if new data from the source is available #}
{% set qry_check_for_new_data %}
select
    case
        when (select count(*) from {{ this }}) = 0
            then 1
        when (select top 1 1
              from {{ ref('tda_mwa_history__vw_demographics') }}
              where effective_date > (select max(effective_date) from {{ this }})
              ) = 1
            then 1
        else 0
        end
{% endset %}

{# Execute the query to determine if new data is ready. 1=yes 0=no#}
{% if execute %}
  {% set result = dbt_utils.get_single_value(qry_check_for_new_data) %}
{% else %}
  {{ dbt_utils.log_info('setting result from default')}}
  {% set result = 0 %}
{% endif %}

{% if result == 0 %}
  select *
  from {{ this }}
{% else %}
with cte_accounts as
(
    select
        account_number
        ,file_type
        ,effective_date
        ,min(effective_date) over(partition by account_number) as min_effective_date
        ,max(effective_date) over(partition by account_number) as max_effective_date
        ,count(*) over(partition by account_number) as cnt
    from {{ ref('tda_mwa_history__vw_demographics') }}
    where true
    group by 1,2,3
    order by 1,3
)
,cte_date_spine as
(
    select
      dateadd(day, '-' || seq4(), current_date()) as date_key
    from table(generator(rowcount => 10000))
    where date_key between 
        (select min(effective_date) from {{ ref('tda_mwa_history__vw_demographics') }}) and (select max(effective_date) from {{ ref('tda_mwa_history__vw_demographics') }})
)
,cte_spined as
(
    select
        a.account_number
        ,a.min_effective_date
        ,ds.date_key
        ,case when acc.account_number is not null then 1 else 0 end as is_exists
        ,iff(is_exists = 1
            , ds.date_key
            , coalesce(last_value(case when is_exists = 1 then ds.date_key end) ignore nulls
                over(partition by a.account_number order by ds.date_key asc rows between unbounded preceding and 1 preceding)
                , ds.date_key
                )
            )
            as last_effective_date
    from (select account_number, min(min_effective_date) as min_effective_date
          from cte_accounts group by 1) a
    cross join cte_date_spine ds
    left join cte_accounts acc
        on a.account_number = acc.account_number
        and ds.date_key = acc.effective_date
    where 1=1
        and ds.date_key >= a.min_effective_date
)

select
    s.date_key as effective_date
  , s.account_number
  , d.file_type
  , d.advisor_id
  , d.account_type
  , d.taxable
  , case when p.account_number is not null then 1 else 0 end as has_positions
  , d.objective
  , nullif(trim(d.company_name), '') as company_name
  , d.last_name
  , d.first_name
  , d.street
  , d.address_2
  , d.address_3
  , d.address_4
  , d.address_5
  , d.address_6
  , d.city
  , d.state
  , d.zip_code
  , d.ssn
  , d.phone_number
  , d.fax_number
  , d.billing_account_number
  , d.default_account
  , d.state_of_primary_residence
  , d.performance_inception_date
  , d.billing_inception_date
  , d.federal_tax_rate
  , d.state_tax_rate
  , d.months_in_short_term_holding_period
  , d.fiscal_year_end
  , d.use_average_cost_accounting
  , d.display_accrued_interest
  , d.display_accrued_dividends
  , d.display_accrued_gains
  , d.birth_date
  , d.discount_rate
  , d.payout_rate
  , {{ col_is_head(reference='cte_spined', reference_date_col='date_key', source_date_col='s.date_key') }}
  , {{ col_is_current(date_col='s.date_key') }}
  , null::timestamp                as _source_loaded_at
  , current_timestamp()::timestamp as _created_at
from cte_spined                           s
left join {{ ref('tda_mwa_history__vw_demographics') }} d
    on s.last_effective_date = d.effective_date
    and s.account_number = d.account_number
left join (
            select effective_date, account_number
            from {{ ref('tda_mwa_history__vw_positions') }}
            group by effective_date, account_number
          )p
    on s.account_number = p.account_number
    and s.date_key = p.effective_date
where s.date_key in (select date_key from {{ ref('dates') }} where is_market_day = 1)
order by s.account_number, s.date_key
{% endif %}