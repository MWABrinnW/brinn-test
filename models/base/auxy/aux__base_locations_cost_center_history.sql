select
    case
        when nvl(json:start_date, '1900-01-01') in ('1900-01-01', '2199-12-31')
            then null
        else json:start_date
        end::date                   as start_date
  , case
        when nvl(json:end_date, '1900-01-01') in ('1900-01-01', '2199-12-31')
            then null
        else json:end_date
        end::date                   as end_date
  , json:old_code::varchar(25)      as old_code
  , json:current_code::varchar(25)  as current_code
  , {{ col_is_head(reference=source('aux', 'locations'), reference_date_col='_created_at', source_date_col='_created_at') }}
  , _created_at::timestamp     as _created_at
from {{ source('aux', 'locations') }}
where json:dataset = 'cost_center_history'