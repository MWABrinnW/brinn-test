select
    'Undefined Moxy Securites - Total Held' as "Type"
    , count(*)                              as "Count"
from {{ ref('moxy__stg_securities_postimport') }}
where sec_type like 'x%'
    and is_head = 1
    and sec_key in (
        select distinct sec_key
        from {{ ref('moxy__stg_positions') }}
        where is_head = 1
    )

union all

select
    'Undefined Moxy Securities - Last Import' as "Type"
    , count(*)                                as "Count"
from {{ ref('moxy__rpt_sod_post_import_new_securities') }}

union all

select
    'Account Issues' as "Type"
    , count(*)       as "Count"
from {{ ref('moxy__rpt_sod_post_import_portfolios') }}
