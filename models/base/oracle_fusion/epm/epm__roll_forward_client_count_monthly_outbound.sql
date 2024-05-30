select
    _id
    , location_code
    , location_name
    , office_name
    , accounting_id
    , division
    , client_manager
    , employee_num
    , lead_source
    , flows_and_market_model_status
    , month_end_date
    , change_desc
    , value
    , record_date
from {{ source('reporting_int', 'roll_forward_client_count_monthly_transposed') }}
