select
    split_part(content , ',' , 1)::int        as calendar_year
    , split_part(content , ',' , 2)::int      as quarter
    , split_part(content , ',' , 3)::date     as run_date
    , split_part(content , ',' , 4)::time     as run_time
    , split_part(content , ',' , 5)::varchar  as cusip_no
    , split_part(content , ',' , 6)::varchar  as has_listed_options
    , split_part(content , ',' , 7)::varchar  as issuer_name
    , split_part(content , ',' , 8)::varchar  as issuer_description
    , split_part(content , ',' , 9)::varchar  as status
    , split_part(content , ',' , 10)::varchar as cusip
    , split_part(content , ',' , 11)::int     as record_number
    , split_part(content , ',' , 12)::int     as pdf_page_number
    , split_part(content , ',' , 13)::int     as pdf_row_number


    , effective_date                          as effective_date
    , _created_at                             as _created_at
    , _source_file                            as _source_file
from {{ source('sec', 'form_13f') }}
where regexp_like(content , '[0-9]{1}.*')-- include only rows that start with a digit, filter out header rows
