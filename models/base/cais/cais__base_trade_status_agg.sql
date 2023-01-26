select
    order_status
    ,number_of_orders::int  as number_of_orders
    ,effective_date::date   as effective_date
    , {{ col_is_head(reference=source('cais', 'trade_status_agg')) }}
    ,_created_at::timestamp as _created_at
    ,_source_file
from {{ source('cais','trade_status_agg') }}