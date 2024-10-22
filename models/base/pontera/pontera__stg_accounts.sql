{% set src = source('pontera', 'accounts') %}
select
    _data:"custodian name"::text(200)          as custodian_name
    , _data:"account balance"::number(28 , 10) as account_balance
    , _data:"account id"::text(200)            as account_id
    , _data:"cash security"::text(200)         as cash_security
    , _data:"as of date"::date                 as as_of_date
    , _data:"data availability"::text(200)     as data_availability
    , _data:"account name"::text(200)          as account_name
    , _data:"account type"::text(200)          as account_type
    , _data:"plan account id"::text(200)       as plan_account_id
    , _data:"client id"::int                   as client_id
    , _data:"notes"::text(500)                 as notes

    , effective_date::date                     as effective_date
    , _created_at::timestamp                   as _created_at
    , _source_file::text(200)                  as _source_file

    , dense_rank() over (
        partition by effective_date order by _created_at desc
    )                                          as is_head_for_day
    , case
        when is_head_for_day = 1 and effective_date = (select max(effective_date) from {{ src }})
            then 1
        else 0
    end::int                                   as is_head
from {{ src }}
