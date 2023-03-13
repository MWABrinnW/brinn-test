select *
from {{ ref('tda__base_pri') }}
where rep_code_firm = 'mwa'