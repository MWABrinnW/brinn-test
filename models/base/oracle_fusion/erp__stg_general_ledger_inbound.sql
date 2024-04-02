select
    nullif(replace(split(content , '|')[0] , '"' , '') , '')::date                        as gl_entry_date
    , nullif(replace(split(content , '|')[1] , '"' , '') , '')::date                      as gl_effective_date
    , nullif(replace(split(content , '|')[2] , '"' , '') , '')::date              as gl_je_posted_date
    , nullif(replace(split(content , '|')[3] , '"' , '') , '')::varchar(200)              as gl_je_batch_id
    , nullif(replace(split(content , '|')[4] , '"' , '') , '')::varchar(200)              as gl_je_batch_name
    , nullif(replace(split(content , '|')[5] , '"' , '') , '')::varchar(200)              as gl_je_batch_description
    , nullif(replace(split(content , '|')[6] , '"' , '') , '')::varchar(200)              as gl_je_header_id
    , nullif(trim(replace(split(content , '|')[7] , '"' , '')) , '')::varchar(200)        as gl_je_name
    , nullif(trim(replace(split(content , '|')[8] , '"' , '')) , '')::varchar(200)        as gl_je_description
    , nullif(replace(split(content , '|')[9] , '"' , '') , '')::varchar(200)              as gl_je_line_id
    , nullif(replace(split(content , '|')[10] , '"' , '') , '')::varchar(200)             as gl_je_line_description
    , nullif(replace(split(content , '|')[11] , '"' , '') , '')::varchar(200)             as gl_reversed_je_header_id
    , nullif(replace(split(content , '|')[12] , '"' , '') , '')::varchar(200)             as gl_reversed_je_header_name
    , nullif(replace(split(content , '|')[13] , '"' , '') , '')::varchar(200)             as _0_account_number
    , nullif(replace(split(content , '|')[14] , '"' , '') , '')::varchar(200)             as _1_legal_entity_id
    , nullif(replace(split(content , '|')[15] , '"' , '') , '')::varchar(200)             as _2_product_id
    , nullif(replace(split(content , '|')[16] , '"' , '') , '')::varchar(200)             as _3_accounting_id
    , nullif(replace(split(content , '|')[17] , '"' , '') , '')::varchar(200)             as _4_team_id
    , nullif(replace(split(content , '|')[18] , '"' , '') , '')::varchar(200)             as _5_natural_account_id
    , nullif(replace(split(content , '|')[19] , '"' , '') , '')::varchar(200)             as _6_initiative_id
    , nullif(replace(split(content , '|')[20] , '"' , '') , '')::varchar(200)             as _7_intercompany_id
    , nullif(replace(split(content , '|')[21] , '"' , '') , '')::varchar(200)             as _8_future_id
    , nullif(replace(split(content , '|')[22] , '"' , '') , '')::varchar(200)             as legal_entity_name
    , nullif(replace(split(content , '|')[23] , '"' , '') , '')::varchar(200)             as product_name
    , nullif(replace(split(content , '|')[24] , '"' , '') , '')::varchar(200)             as accounting_id_name
    , nullif(replace(split(content , '|')[25] , '"' , '') , '')::varchar(200)             as team_name
    , nullif(replace(split(content , '|')[26] , '"' , '') , '')::varchar(200)             as natural_account_name
    , nullif(replace(split(content , '|')[27] , '"' , '') , '')::varchar(200)             as initiative_name
    , nullif(replace(split(content , '|')[28] , '"' , '') , '')::varchar(200)             as intercompany_name
    , nullif(replace(split(content , '|')[29] , '"' , '') , '')::varchar(200)             as future_name
    , nullif(replace(split(content , '|')[30] , '"' , '') , '')::varchar(200)             as account_type
    , nullif(replace(split(content , '|')[31] , '"' , '') , '')::varchar(200)             as journal_source
    , nullif(replace(split(content , '|')[32] , '"' , '') , '')::varchar(200)             as journal_category
    , zeroifnull(nullif(replace(split(content , '|')[33] , '"' , '') , ''))::varchar(200) as entered_debit_amount
    , zeroifnull(nullif(replace(split(content , '|')[34] , '"' , '') , ''))::varchar(200) as entered_credit_amount
    , zeroifnull(nullif(replace(split(content , '|')[35] , '"' , '') , ''))::varchar(200) as converted_debit_amount
    , zeroifnull(nullif(replace(split(content , '|')[36] , '"' , '') , ''))::varchar(200) as converted_credit_amount
    , nullif(replace(split(content , '|')[37] , '"' , '') , '')::varchar(200)             as gl_je_created_by
    , nullif(replace(split(content , '|')[38] , '"' , '') , '')::timestamp_ntz            as extract_datetime
    , nullif(replace(split(content , '|')[39] , '"' , '') , '')::varchar(200)             as mariner_gl_record_id
    , effective_date                                                                      as effective_date
    , _created_at                                                                         as _created_at
    , _source_file                                                                        as _source_file
from {{ source('oracle', 'erp_general_ledger') }}
