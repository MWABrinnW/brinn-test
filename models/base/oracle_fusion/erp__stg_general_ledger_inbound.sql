select
    nullif(replace(split(content , '"|"')[0] , '"' , '') , '')::date                     as gl_entry_date
    , nullif(replace(split(content , '"|"')[1] , '"' , '') , '')::date                   as gl_effective_date
    , nullif(replace(split(content , '"|"')[2] , '"' , '') , '')::date                   as gl_je_posted_date
    , nullif(replace(split(content , '"|"')[3] , '"' , '') , '')::text(200)              as gl_je_batch_id
    , nullif(replace(split(content , '"|"')[4] , '"' , '') , '')::text(200)              as gl_je_batch_name
    , nullif(replace(split(content , '"|"')[5] , '"' , '') , '')::text(200)              as gl_je_batch_description
    , nullif(replace(split(content , '"|"')[6] , '"' , '') , '')::text(200)              as gl_je_header_id
    , nullif(trim(replace(split(content , '"|"')[7] , '"' , '')) , '')::text(200)        as gl_je_name
    , nullif(trim(replace(split(content , '"|"')[8] , '"' , '')) , '')::text(200)        as gl_je_description
    , nullif(replace(split(content , '"|"')[9] , '"' , '') , '')::text(200)              as gl_je_line_id
    , nullif(replace(split(content , '"|"')[10] , '"' , '') , '')::text(200)             as gl_je_line_description
    , nullif(replace(split(content , '"|"')[11] , '"' , '') , '')::text(200)             as gl_reversed_je_header_id
    , nullif(replace(split(content , '"|"')[12] , '"' , '') , '')::text(200)             as gl_reversed_je_header_name
    , nullif(replace(split(content , '"|"')[13] , '"' , '') , '')::text(200)             as _0_account_number
    , nullif(replace(split(content , '"|"')[14] , '"' , '') , '')::text(200)             as _1_legal_entity_id
    , nullif(replace(split(content , '"|"')[15] , '"' , '') , '')::text(200)             as _2_product_id
    , nullif(replace(split(content , '"|"')[16] , '"' , '') , '')::text(200)             as _3_accounting_id
    , nullif(replace(split(content , '"|"')[17] , '"' , '') , '')::text(200)             as _4_team_id
    , nullif(replace(split(content , '"|"')[18] , '"' , '') , '')::text(200)             as _5_natural_account_id
    , nullif(replace(split(content , '"|"')[19] , '"' , '') , '')::text(200)             as _6_initiative_id
    , nullif(replace(split(content , '"|"')[20] , '"' , '') , '')::text(200)             as _7_intercompany_id
    , nullif(replace(split(content , '"|"')[21] , '"' , '') , '')::text(200)             as _8_future_id
    , nullif(replace(split(content , '"|"')[22] , '"' , '') , '')::text(200)             as legal_entity_name
    , nullif(replace(split(content , '"|"')[23] , '"' , '') , '')::text(200)             as product_name
    , nullif(replace(split(content , '"|"')[24] , '"' , '') , '')::text(200)             as accounting_id_name
    , nullif(replace(split(content , '"|"')[25] , '"' , '') , '')::text(200)             as team_name
    , nullif(replace(split(content , '"|"')[26] , '"' , '') , '')::text(200)             as natural_account_name
    , nullif(replace(split(content , '"|"')[27] , '"' , '') , '')::text(200)             as initiative_name
    , nullif(replace(split(content , '"|"')[28] , '"' , '') , '')::text(200)             as intercompany_name
    , nullif(replace(split(content , '"|"')[29] , '"' , '') , '')::text(200)             as future_name
    , nullif(replace(split(content , '"|"')[30] , '"' , '') , '')::text(200)             as account_type
    , nullif(replace(split(content , '"|"')[31] , '"' , '') , '')::text(200)             as journal_source
    , nullif(replace(split(content , '"|"')[32] , '"' , '') , '')::text(200)             as journal_category
    , zeroifnull(nullif(replace(split(content , '"|"')[33] , '"' , '') , ''))::text(200) as entered_debit_amount
    , zeroifnull(nullif(replace(split(content , '"|"')[34] , '"' , '') , ''))::text(200) as entered_credit_amount
    , zeroifnull(nullif(replace(split(content , '"|"')[35] , '"' , '') , ''))::text(200) as converted_debit_amount
    , zeroifnull(nullif(replace(split(content , '"|"')[36] , '"' , '') , ''))::text(200) as converted_credit_amount
    , nullif(replace(split(content , '"|"')[37] , '"' , '') , '')::text(200)             as gl_je_created_by
    , nullif(replace(split(content , '"|"')[38] , '"' , '') , '')::timestamp_ntz         as extract_datetime
    , nullif(replace(split(content , '"|"')[39] , '"' , '') , '')::text(200)             as mariner_gl_record_id
    , effective_date
    , _created_at
    , _source_file
    , coalesce(gl_je_batch_id , '')
    || '_' || coalesce(gl_je_header_id , '')
    || '_' || coalesce(gl_je_line_id , '')                                               as _record_id
from {{ source('oracle', 'erp_general_ledger') }}
