select
    nullif(replace(split(content , '|')[0] , '"' , '') , '')::varchar(200)    as status
    , nullif(replace(split(content , '|')[1] , '"' , '') , '')::varchar(200)  as accounting_date
    , nullif(replace(split(content , '|')[2] , '"' , '') , '')::varchar(200)  as source
    , nullif(replace(split(content , '|')[3] , '"' , '') , '')::varchar(200)  as je_category
    , nullif(replace(split(content , '|')[4] , '"' , '') , '')::varchar(200)  as je_batch
    , nullif(replace(split(content , '|')[5] , '"' , '') , '')::varchar(200)  as journal_description
    , nullif(replace(split(content , '|')[6] , '"' , '') , '')::varchar(200)  as gl_account
    , nullif(replace(split(content , '|')[7] , '"' , '') , '')::varchar(200)  as l_number
    , nullif(replace(split(content , '|')[8] , '"' , '') , '')::varchar(200)  as debits
    , nullif(replace(split(content , '|')[9] , '"' , '') , '')::varchar(200)  as credits
    , nullif(replace(split(content , '|')[10] , '"' , '') , '')::varchar(200) as mariner_gl_record_id
    , effective_date                                                          as effective_date
    , _created_at                                                             as _created_at
    , _source_file                                                            as _source_file
from {{ source('oracle', 'erp_general_ledger_exceptions') }}
