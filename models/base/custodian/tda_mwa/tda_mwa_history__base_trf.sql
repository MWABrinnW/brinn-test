select *
from {{ ref('tda__base_trf') }}
where rep_code_firm = 'mwa'