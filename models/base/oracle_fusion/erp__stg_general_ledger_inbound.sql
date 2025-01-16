select
    nullif(replace(split(content , '"|"')[0] , '"' , '') , '')::date                as gl_entry_date
    , nullif(replace(split(content , '"|"')[1] , '"' , '') , '')::date              as gl_effective_date
    , nullif(replace(split(content , '"|"')[2] , '"' , '') , '')::date              as gl_je_posted_date
    , nullif(replace(split(content , '"|"')[3] , '"' , '') , '')::text              as gl_je_batch_id
    , nullif(replace(split(content , '"|"')[4] , '"' , '') , '')::text              as gl_je_batch_name
    , nullif(replace(split(content , '"|"')[5] , '"' , '') , '')::text              as gl_je_batch_description
    , nullif(replace(split(content , '"|"')[6] , '"' , '') , '')::text              as gl_je_header_id
    , nullif(trim(replace(split(content , '"|"')[7] , '"' , '')) , '')::text        as gl_je_name
    , nullif(trim(replace(split(content , '"|"')[8] , '"' , '')) , '')::text        as gl_je_description
    , nullif(replace(split(content , '"|"')[9] , '"' , '') , '')::text              as gl_je_line_id
    , nullif(replace(split(content , '"|"')[10] , '"' , '') , '')::text             as gl_je_line_description
    , nullif(replace(split(content , '"|"')[11] , '"' , '') , '')::text             as gl_reversed_je_header_id
    , nullif(replace(split(content , '"|"')[12] , '"' , '') , '')::text             as gl_reversed_je_header_name
    , nullif(replace(split(content , '"|"')[13] , '"' , '') , '')::text             as _0_account_number
    , nullif(replace(split(content , '"|"')[14] , '"' , '') , '')::text             as _1_legal_entity_id
    , nullif(replace(split(content , '"|"')[15] , '"' , '') , '')::text             as _2_product_id
    , nullif(replace(split(content , '"|"')[16] , '"' , '') , '')::text             as _3_accounting_id
    , nullif(replace(split(content , '"|"')[17] , '"' , '') , '')::text             as _4_team_id
    , nullif(replace(split(content , '"|"')[18] , '"' , '') , '')::text             as _5_natural_account_id
    , nullif(replace(split(content , '"|"')[19] , '"' , '') , '')::text             as _6_initiative_id
    , nullif(replace(split(content , '"|"')[20] , '"' , '') , '')::text             as _7_intercompany_id
    , nullif(replace(split(content , '"|"')[21] , '"' , '') , '')::text             as _8_future_id
    , nullif(replace(split(content , '"|"')[22] , '"' , '') , '')::text             as legal_entity_name
    , nullif(replace(split(content , '"|"')[23] , '"' , '') , '')::text             as product_name
    , nullif(replace(split(content , '"|"')[24] , '"' , '') , '')::text             as accounting_id_name
    , nullif(replace(split(content , '"|"')[25] , '"' , '') , '')::text             as team_name
    , nullif(replace(split(content , '"|"')[26] , '"' , '') , '')::text             as natural_account_name
    , nullif(replace(split(content , '"|"')[27] , '"' , '') , '')::text             as initiative_name
    , nullif(replace(split(content , '"|"')[28] , '"' , '') , '')::text             as intercompany_name
    , nullif(replace(split(content , '"|"')[29] , '"' , '') , '')::text             as future_name
    , nullif(replace(split(content , '"|"')[30] , '"' , '') , '')::text             as account_type
    , nullif(replace(split(content , '"|"')[31] , '"' , '') , '')::text             as journal_source
    , nullif(replace(split(content , '"|"')[32] , '"' , '') , '')::text             as journal_category
    , zeroifnull(nullif(replace(split(content , '"|"')[33] , '"' , '') , ''))::text as entered_debit_amount
    , zeroifnull(nullif(replace(split(content , '"|"')[34] , '"' , '') , ''))::text as entered_credit_amount
    , zeroifnull(nullif(replace(split(content , '"|"')[35] , '"' , '') , ''))::text as converted_debit_amount
    , zeroifnull(nullif(replace(split(content , '"|"')[36] , '"' , '') , ''))::text as converted_credit_amount
    , nullif(replace(split(content , '"|"')[37] , '"' , '') , '')::text             as gl_je_created_by
    , nullif(replace(split(content , '"|"')[38] , '"' , '') , '')::timestamp_ntz    as extract_datetime
    , nullif(replace(split(content , '"|"')[39] , '"' , '') , '')::text             as mariner_gl_record_id
    , effective_date
    , _created_at
    , _source_file
    , coalesce(gl_je_batch_id , '')
    || '_' || coalesce(gl_je_header_id , '')
    || '_' || coalesce(gl_je_line_id , '')                                          as _record_id
from {{ source('oracle_erp', 'erp_general_ledger') }}
