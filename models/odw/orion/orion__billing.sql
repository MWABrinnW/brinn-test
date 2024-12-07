select
    *
    , {{ col_is_head(
        reference=ref('orion__bld_billing'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
        ) }}
from {{ ref('orion__bld_billing') }}
