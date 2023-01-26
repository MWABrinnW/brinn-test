select
    cais_order_id
    ,order_status
    ,close_date::date       as close_date
    ,amount::decimal(15,2)  as amount
    ,user_name
    ,userid
    ,firm_name
    ,firm_id
    ,fund_name
    {# ,fund_id #}
    ,share_class
    ,investment_entity_name
    ,investment_entity_id
    ,third_party_account
    ,effective_date::date   as effective_date
    , {{ col_is_head(reference=source('cais', 'trade_status')) }}
    ,_created_at::timestamp as _created_at
    ,_source_file
from {{ source('cais', 'trade_status') }}