{{ config(
    tags=["financials"]
) }}

select
    cli.*
    , {{ col_is_head(
        reference=ref('bld_salesforce_compass_accounts'), 
        source_date_col='effective_date', 
        reference_date_col='effective_date'
    ) }}
    , dense_rank() over (partition by cli.effective_date order by date_trunc('second' , cli._source_loaded_at) desc)::int
        as is_latest
from {{ ref('bld_salesforce_compass_accounts') }} as cli
where true
qualify is_latest = 1
