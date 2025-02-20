select
    department   as name
    , 'Root'     as parent
    , cost_seg_3 as externalid
from {{ ref('nml_oracle_hcm_associates') }}
where department is not null
group by all
