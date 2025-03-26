select
    'Intraday Imported Accounts' as "Type"
    , count(*)                   as "Count"
from {{ ref('moxy__rpt_sod_post_intraday_import_portfolios') }}
