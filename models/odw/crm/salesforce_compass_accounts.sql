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
    , case
        when row_number() over (partition by cli.effective_date order by cli._created_at desc) = 1
            then 1
        else 0
    end as is_latest
from {{ ref('bld_salesforce_compass_accounts') }} as cli
where true
