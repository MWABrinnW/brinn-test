select *
from {{ ref('tda__accounts') }}
where rep_code_firm = 'mwa'