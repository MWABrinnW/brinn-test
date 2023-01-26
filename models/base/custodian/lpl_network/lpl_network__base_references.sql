
select
    referencetype                     as reference_type
  , code                              as code
  , description                       as description
  , shortdescription                  as short_description
  , {{ col_is_head(reference=source('lpl_network', 'reference')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date              as effective_date
  , _created_at::timestamp            as _created_at
  , _source_file
from {{ source('lpl_network', 'reference') }}
