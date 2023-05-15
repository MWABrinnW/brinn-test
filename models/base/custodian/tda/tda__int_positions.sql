select
     pos.custodian
    ,pos.account_number
    ,pos.account_type
    ,pos.security_type
    ,pos.symbol
    ,case
        when pri.factor > 0
            then (pos.quantity * (pri.price::float * (pri.factor::float * .01::float)))
        else 
            (pos.quantity * pri.price)::decimal(15,2) 
        end::decimal(15,2)                 as market_value
    ,pos.quantity
    ,case
        when pri.factor > 0
            then (pri.price::float * (pri.factor::float * .01::float))
        else
            pri.price
        end::decimal(19,9)                 as price
    ,pri.price                             as price_unfactored
    ,pri.factor
    ,pos.rep_code_firm
    ,pos.firm_source
    ,pos.firm
    ,pos.effective_date
    ,pos._rep_code
    ,pos._file_type
    ,pos._source_file 
    ,pos._source_loaded_at
    ,pos.is_head
    ,pos.is_current
from {{ ref('tda__base_pos') }} pos
left join {{ ref('tda__base_pri') }} pri
    on pos.effective_date = pri.effective_date
    and pos._rep_code = pri._rep_code
    and pos.symbol = pri.symbol
where true
