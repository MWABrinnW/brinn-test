select *
from {{ source('investments', 'model_master_monthly') }}
qualify row_number() over (partition by model order by month_end_date desc , record_datetime desc) = 1
