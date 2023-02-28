{{ config(materialized = 'table') }}
-- depends_on: {{ ref('tda__base_accounts') }}
-- depends_on: {{ ref('tda__base_pos') }}
-- depends_on: {{ ref('dates') }}

with cte_accounts as
(
    select
        *
        ,min(effective_date) over(partition by account_number) as min_effective_date
        ,max(effective_date) over(partition by account_number) as max_effective_date
        ,row_number() over(partition by account_number, effective_date order by case when _file_type = 'TRF' then 1 else 0 end desc, _created_at desc) as rn
        ,row_number() over(partition by account_number order by case when _file_type = 'TRF' then 1 else 0 end desc, _created_at desc) as rn_account
    from {{ ref('tda__base_accounts') }}
    where true
    qualify row_number() over(partition by account_number, effective_date order by case when _file_type = 'TRF' then 1 else 0 end desc, _created_at desc) = 1
    order by 1,3,2
)
,cte_date_spine as
(
    select
      dateadd(day, '-' || seq4(), current_date()) as date_key
    from table(generator(rowcount => 10000))
    where date_key between 
        (select min(effective_date) from {{ ref('tda__base_accounts') }}) and (select max(effective_date) from {{ ref('tda__base_accounts') }})
)
,cte_spined as
(
    select distinct
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
    from cte_accounts a
    cross join cte_date_spine ds
    left join cte_accounts acc
        on a.account_number = acc.account_number
        and ds.date_key = acc.effective_date
    where 1=1
        and a.rn = 1
        {# and a.rn_account = 1 #}
        and ds.date_key >= a.min_effective_date
)

select
    s.date_key as effective_date
  , s.account_number
  , d.advisor_id
  , d.account_type
  , d.taxable
  , case when p.account_number is not null then 1 else 0 end    as has_positions
  , min(p.effective_date) over(partition by s.account_number)   as first_positions_date
  , max(p.effective_date) over(partition by s.account_number)   as last_positions_date
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
  , rc.firm                        as rep_code_firm
  , rc.status                      as rep_code_status
  , rc.description                 as rep_code_description
  , {{ col_is_head(reference='cte_spined', reference_date_col='date_key', source_date_col='s.date_key') }}
  , {{ col_is_current(date_col='s.date_key') }}
  , d._rep_code                    as _rep_code
  , d._file_type                   as _file_type
  , d._source_file                 as _source_file
  , d._created_at                  as _source_loaded_at
  , current_timestamp()::timestamp as _created_at
from cte_spined                           s
left join cte_accounts d
    on s.last_effective_date = d.effective_date
    and s.account_number = d.account_number
    and d.rn = 1
left join (
            select effective_date, account_number
            from {{ ref('tda__base_pos') }}
            group by effective_date, account_number
          )p
    on s.account_number = p.account_number
    and s.date_key = p.effective_date
left join {{ref('tda__rep_codes')}} rc
  on d._rep_code = rc.rep_code
where s.date_key in (select date_key from {{ ref('dates') }} where is_market_day = 1)
order by s.account_number, s.date_key