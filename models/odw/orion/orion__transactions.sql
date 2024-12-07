select
    *
    , case
        when type_name ilike '%buy%'
            then 1
        when type_name ilike '%sell%'
            then 1
        else 0
    end::int       as is_trade
    , case
        when type_name ilike '%buy%'
            then 'buy'
        when type_name ilike '%sell%'
            then 'sell'
    end::text(200) as buy_sell
    , {{ col_is_head(
        reference=ref('orion__bld_transactions'),
        source_date_col='date',
        reference_date_col='date'
        ) }}
from {{ ref('orion__bld_transactions') }}
