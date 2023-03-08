select *
from {{ ref('tda__base_trd') }}
where rep_code_firm = 'mwa'