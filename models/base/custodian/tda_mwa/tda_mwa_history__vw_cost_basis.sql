select *
from {{ ref('tda__base_cbl') }}
where rep_code_firm = 'mwa'