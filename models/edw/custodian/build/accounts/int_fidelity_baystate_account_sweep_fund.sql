select
      effective_date    as effective_date
    , custodian         as custodian
    , firm_source       as firm_source
    , account_custodial as account_number
    , core_symbol       as ticker
    , is_head           as is_head
    , is_current        as is_current
    , record_datetime   as _source_loaded_at
    , _source_file      as _source_file
from {{ ref('fidelity_baystate_history__vw_nabase_104_telephone_and_bank') }}
