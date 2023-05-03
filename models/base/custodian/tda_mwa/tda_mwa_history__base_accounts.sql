select *
from {{ ref('tda__int_accounts') }}
where rep_code_firm = 'mwa'