select *
from {{ ref('fidelity__int_gnums') }}
where true
    and firm_source = 'baystate'
