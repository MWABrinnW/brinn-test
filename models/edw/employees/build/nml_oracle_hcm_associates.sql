{{ config(
    grants = {'select': ['engineering', 'security', 'datamanagement']}
) }}

select
    *
    , {{ col_is_head(
        reference=ref('nml_oracle_hcm_associates_history'),
        source_date_col='effective_at',
        reference_date_col='effective_at'
        ) }}
from {{ ref('nml_oracle_hcm_associates_history') }}
