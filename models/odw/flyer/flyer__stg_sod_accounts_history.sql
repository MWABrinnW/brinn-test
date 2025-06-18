select
    a.effective_date::date                   as effective_date
    , a.account_no::text(200)                as account_no
    , a.account_name::text(200)              as account_name
    , a.custodian::text(200)                 as custodian
    , a.description::text(200)               as description
    , a.notes::text(200)                     as notes
    , a.model_name::text(200)                as model_name
    , a.closing_method::text(200)            as closing_method
    , a.long_term_tax_rate::decimal(19 , 6)  as long_term_tax_rate
    , a.short_term_tax_rate::decimal(19 , 6) as short_term_tax_rate
    , a.use_account_cash::text(200)          as use_account_cash
    , a.cash_reserve_type::text(200)         as cash_reserve_type
    , a.cash_reserve::text(200)              as cash_reserve
    , a.taxable::text(200)                   as taxable
    , a.cashreserveexpiry::text(200)         as cashreserveexpiry
    , a.disablesleeves::text(200)            as disablesleeves
    , a.portfoliocode1::text(200)            as portfoliocode1
    , a.portfoliocode2::text(200)            as portfoliocode2
    , a.portfoliocode3::text(200)            as portfoliocode3
    , a.accounttype::text(200)               as accounttype
    , a.advisorname::text(200)               as advisorname
    , a.associated_users::text(600)          as associated_users
    , case
        when a._created_at = (
                select max(_created_at)
                from {{ source('flyer', 'sod_accounts_history') }}
            )
            then 1
        else 0
    end::int                                 as is_head
    , case
        when a._created_at = b.max_created_at
            then 1
        else 0
    end::int                                 as is_head_for_day
    , a._created_at::timestamp_ntz           as _created_at
from {{ source('flyer', 'sod_accounts_history') }} as a
left join (
    select
        _created_at::date  as _created_date
        , max(_created_at) as max_created_at
    from {{ source('flyer', 'sod_accounts_history') }}
    group by 1
) as b
    on a._created_at::date = b._created_date::date
    and a._created_at = b.max_created_at
