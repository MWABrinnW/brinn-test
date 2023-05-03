select
      effective_date
    , custodian
    , custodial_id
    , business_date
    , account_number
    , account_type
    , security_type
    , symbol
    , security_name
    , cost_basis_fully_known::int                               as is_cost_basis_fully_known
    , sum(current_quantity)                                     as quantity
    , (sum(cost_basis) / sum(current_quantity))::decimal(15,2)  as avg_cost_basis
    , sum(cost_basis)                                           as total_cost_basis
    , sum(adjusted_cost_basis)                                  as total_adjusted_cost_basis
    , sum(unrealized_gain_loss)                                 as unrealized_gain_loss
    , min(original_purchase_date)                               as min_original_purchase_date
    , rep_code_firm
    , _rep_code
    , _file_type
    , is_head
    , is_current
    , _source_file
    , _source_loaded_at
from {{ ref('tda__base_cbl') }}
where true
    and effective_date = '4/21/2023'
    and account_number = '918971485'
group by
      effective_date
    , custodian
    , custodial_id
    , business_date
    , account_number
    , account_type
    , security_type
    , symbol
    , security_name
    , cost_basis_fully_known::int
    , rep_code_firm
    , _rep_code
    , _file_type
    , is_head
    , is_current
    , _source_file
    , _source_loaded_at
