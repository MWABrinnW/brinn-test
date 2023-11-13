select fkasset                as fkasset
     , effective_date         as effective_date
     , _client                as _client
     , sum(longtermcost + shorttermcost) as cost_basis
from {{ ref('orion__base_vw_costbasisunrealized') }}
group by all
