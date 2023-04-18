select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , account_id
    , account_number
    , security_id
    , cusip
    , ticker
    , sales_date
    , proceeds
    , sales_units
    , total_cost
    , purchase_date
    , unsupervised_indicator
    , short_position_indicator
    , tax_currency
    , {{ col_is_head(reference=source('envestnet_mps', 'gainloss_gain_loss')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'gainloss_gain_loss') }}


