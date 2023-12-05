select *
from {{ ref('int_fidelity_mwa_account_sweep_fund') }}

union all

select *
from {{ ref('int_fidelity_mps_account_sweep_fund') }}

union all

select *
from {{ ref('int_fidelity_swag_account_sweep_fund') }}
