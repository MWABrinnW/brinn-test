select *
from {{ ref('tda__base_trn') }}
where rep_code_firm = 'mwa'