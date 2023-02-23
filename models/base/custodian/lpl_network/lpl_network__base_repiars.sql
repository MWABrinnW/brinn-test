
select
    repid                               as rep_id
  , state                               as state
  , isstateregistered::int              as is_state_registered
  , isiarregistered::int                as is_iar_registered
  , to_date(approveddate, 'MM/DD/YYYY') as approved_date
  , to_date(updateddate, 'MM/DD/YYYY')  as updated_date
  , {{ col_is_head(reference=source('lpl_network', 'repiar')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                as effective_date
  , _created_at::timestamp              as _source_loaded_at
  , _source_file
from {{ source('lpl_network', 'repiar') }}
