select *
from {{ ref('tda__base_sec') }}
where rep_code_firm = 'mwa'