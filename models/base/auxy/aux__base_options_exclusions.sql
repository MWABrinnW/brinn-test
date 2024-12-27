select
    json:start_date::date                as start_date
    , json:end_date::date                as end_date
    , json:account_number::varchar(100)  as account_number
    , json:ticker_or_cusip::varchar(100) as ticker_or_cusip
    , json:notes::varchar(100)           as notes
    , _created_at::timestamp             as _created_at
    , _box_file_id::varchar(200)         as _box_file_id
    , {{ col_is_head(
      reference=source('raw_aux', 'options_exclusions'),
      reference_date_col='_created_at',
      source_date_col='_created_at'
      ) }}

from {{ source('raw_aux', 'options_exclusions') }}
