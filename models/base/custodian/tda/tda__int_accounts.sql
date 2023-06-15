{{
    config(
        materialized='incremental',
        unique_key='effective_date',
        incremental_strategy='delete+insert',
        on_schema_change='sync_all_columns'
    )
}}
-- depends_on: {{ ref('tda__base_accounts') }}
-- depends_on: {{ ref('tda__base_pos') }}
-- depends_on: {{ ref('dates') }}


with cte_accounts as
(
    select
        *
        ,min(effective_date) over(partition by account_number) as min_effective_date
        ,max(effective_date) over(partition by account_number) as max_effective_date
        ,row_number() over(partition by account_number, effective_date order by case when _file_type = 'TRF' then 1 else 0 end desc, _source_loaded_at desc) as rn
        ,row_number() over(partition by account_number order by case when _file_type = 'TRF' then 1 else 0 end desc, _source_loaded_at desc) as rn_account
    from {{ ref('tda__base_accounts') }}
    {% if is_incremental() %}
    where true
        -- Check if the upstream model has newer data. If not then we don't need to waste time processing
        and (
            select max(_source_loaded_at)
            from {{ ref('tda__base_accounts') }}
            ) > (select max(_created_at) from {{ this }})
    {% endif %}
    qualify row_number() over(partition by account_number, effective_date order by case when _file_type = 'TRF' then 1 else 0 end desc, _source_loaded_at desc) = 1
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
        and ds.date_key >= a.min_effective_date
)
,cte_positions_summary as
(
    select 
        effective_date
        , account_number
        , sum(amount)                                             as market_value
        , min(effective_date) over(partition by account_number)   as first_positions_date
        , max(effective_date) over(partition by account_number)   as last_positions_date
    from {{ ref('tda__base_pos') }}
    group by effective_date, account_number
)
,cte_spined_accounts as 
(
    select
          s.date_key                                                  as effective_date
        , d.custodian                                                 as custodian
        , s.account_number                                            as account_number
        , d.advisor_id                                                as advisor_id
        , d.account_type                                              as account_type
        , d.taxable                                                   as taxable
        , case when p.account_number is not null then 1 else 0 end    as has_positions
        , p.first_positions_date                                      as first_positions_date
        , p.last_positions_date                                       as last_positions_date
        , p.market_value                                              as account_value
        , case
            when p.account_number is not null
                then 1
            when ab.status = 'Active'
                then 1
            when ab.status in ('Closed', 'Blocked')
                then 0
            else 0
            end                                                       as is_active
        ,case
            when p.account_number is not null
                then 'Active'
            else ab.status
            end                                                       as status
        ,ab.status                                                    as source_status
        ,case
            when ab.status in ('Closed', 'Blocked')
                then nvl(last_positions_date, ab.open_date)
            when ab.status = 'Active'
                then null
            when p.account_number is null
                then last_positions_date
            else null
            end                                                       as closed_date
        , d.objective                                                 as objective
        , nullif(trim(d.company_name), '')                            as company_name
        , d.last_name                                                 as last_name
        , d.first_name                                                as first_name
        , d.street                                                    as street
        , d.address_2                                                 as address_2
        , d.address_3                                                 as address_3
        , d.address_4                                                 as address_4
        , d.address_5                                                 as address_5
        , d.address_6                                                 as address_6
        , d.city                                                      as city
        , d.state                                                     as state
        , d.zip_code                                                  as zip_code
        , d.ssn                                                       as ssn
        , d.phone_number                                              as phone_number
        , d.fax_number                                                as fax_number
        , d.billing_account_number                                    as billing_account_number
        , d.default_account                                           as default_account
        , d.state_of_primary_residence                                as state_of_primary_residence
        , d.performance_inception_date                                as performance_inception_date
        , d.billing_inception_date                                    as billing_inception_date
        , d.federal_tax_rate                                          as federal_tax_rate
        , d.state_tax_rate                                            as state_tax_rate
        , d.months_in_short_term_holding_period                       as months_in_short_term_holding_period
        , d.fiscal_year_end                                           as fiscal_year_end
        , d.use_average_cost_accounting                               as use_average_cost_accounting
        , d.display_accrued_interest                                  as display_accrued_interest
        , d.display_accrued_dividends                                 as display_accrued_dividends
        , d.display_accrued_gains                                     as display_accrued_gains
        , d.birth_date                                                as birth_date
        , d.discount_rate                                             as discount_rate
        , d.payout_rate                                               as payout_rate
        , rc.firm                                                     as rep_code_firm
        , case when ab.account_number is not null then 1 else 0 end   as exists_in_accounts_balances_file
        {# , rc.status                      as rep_code_status
        , rc.description                 as rep_code_description #}
        , d._rep_code                                                 as _rep_code
        , d._file_type                                                as _file_type
        , d._source_file                                              as _source_file
        , d._source_loaded_at                                         as _source_loaded_at
    from cte_spined                           s
    left join cte_accounts d
        on s.last_effective_date = d.effective_date
        and s.account_number = d.account_number
        and d.rn = 1
    left join cte_positions_summary p
        on s.account_number = p.account_number
        and s.date_key = p.effective_date
    left join {{ ref('tda__base_accounts_balances') }} ab
        on d.account_number = ab.account_number
        and ab.is_head = 1
    left join {{ ref('tda_rep_codes') }} rc
    on d._rep_code = rc.rep_code
    where s.date_key in (select date_key from {{ ref('dates') }} where is_market_day = 1)
    order by s.account_number, s.date_key
)
,cte_missing_accounts as
(
    select 
          p.effective_date
        , p.custodian
        , p.account_number
        , p.account_type
        , p.rep_code_firm
        , p.firm_source
        , p.firm
        , p._rep_code
        , p._file_type
        , p._source_file
        , max(p._source_loaded_at)  as _source_loaded_at
        , sum(p.amount)             as market_value
    from {{ ref('tda__base_pos') }} p
    left join cte_spined_accounts sa
        on p.effective_date = sa.effective_date
        and p.account_number = sa.account_number
    where sa.account_number is null
    {{ dbt_utils.group_by(n=10) }}
)

select
      effective_date
    , custodian
    , account_number
    , advisor_id
    , account_type
    , taxable
    , has_positions
    , first_positions_date
    , last_positions_date
    , account_value
    , is_active
    , status
    , source_status
    , closed_date
    , objective
    , company_name
    , last_name
    , first_name
    , street
    , address_2
    , address_3
    , address_4
    , address_5
    , address_6
    , city
    , state
    , zip_code
    , ssn
    , phone_number
    , fax_number
    , billing_account_number
    , default_account
    , state_of_primary_residence
    , performance_inception_date
    , billing_inception_date
    , federal_tax_rate
    , state_tax_rate
    , months_in_short_term_holding_period
    , fiscal_year_end
    , use_average_cost_accounting
    , display_accrued_interest
    , display_accrued_dividends
    , display_accrued_gains
    , birth_date
    , discount_rate
    , payout_rate
    , rep_code_firm
    , exists_in_accounts_balances_file
    , _rep_code
    , _file_type
    , {{ col_is_head(reference='cte_spined_accounts', reference_date_col='effective_date', source_date_col='effective_date') }}
    , _source_file
    , _source_loaded_at
    , current_timestamp()::timestamp as _created_at
from cte_spined_accounts

union all

select
      p.effective_date                                              as effective_date
    , p.custodian                                                   as custodian
    , p.account_number                                              as account_number
    , p._rep_code                                                   as advisor_id
    , p.account_type                                                as account_type
    , null                                                          as taxable
    , 1::int                                                        as has_positions
    , pos.first_positions_date::date                                as first_positions_date
    , pos.last_positions_date::date                                 as last_positions_date
    , p.market_value                                                as account_value
    , 1::int                                                        as is_active
    , case
        when p.account_number is not null
            then 'Active'
        else ab.status
        end                                                         as status
    , ab.status                                                     as source_status
    , null::date                                                    as closed_date
    , null                                                          as objective
    , null                                                          as company_name
    , null                                                          as last_name
    , null                                                          as first_name
    , null                                                          as street
    , null                                                          as address_2
    , null                                                          as address_3
    , null                                                          as address_4
    , null                                                          as address_5
    , null                                                          as address_6
    , null                                                          as city
    , null                                                          as state
    , null                                                          as zip_code
    , null                                                          as ssn
    , null                                                          as phone_number
    , null                                                          as fax_number
    , null                                                          as billing_account_number
    , null                                                          as default_account
    , null                                                          as state_of_primary_residence
    , null                                                          as performance_inception_date
    , null                                                          as billing_inception_date
    , null                                                          as federal_tax_rate
    , null                                                          as state_tax_rate
    , null                                                          as months_in_short_term_holding_period
    , null                                                          as fiscal_year_end
    , null                                                          as use_average_cost_accounting
    , null                                                          as display_accrued_interest
    , null                                                          as display_accrued_dividends
    , null                                                          as display_accrued_gains
    , null::date                                                    as birth_date
    , null                                                          as discount_rate
    , null                                                          as payout_rate
    , p.rep_code_firm                                               as rep_code_firm
    , case when ab.account_number is not null then 1 else 0 end     as exists_in_accounts_balances_file
    , p._rep_code                                                   as _rep_code
    , p._file_type                                                  as _file_type
    , {{ col_is_head(reference='cte_missing_accounts', reference_date_col='effective_date', source_date_col='p.effective_date') }}
    , p._source_file                                                as _source_file
    , p._source_loaded_at                                           as _source_loaded_at
    , current_timestamp()::timestamp                                as _created_at
from cte_missing_accounts p
left join cte_positions_summary pos
    on p.account_number = pos.account_number
    and p.effective_date = pos.effective_date
left join {{ ref('tda__base_accounts_balances') }} ab
    on p.account_number = ab.account_number
    and ab.is_head = 1
where true
    and p.effective_date in (select distinct effective_date from cte_spined_accounts)
