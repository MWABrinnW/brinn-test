select *
from {{ ref('tda__base_pos') }}
where rep_code_firm = 'mwa'