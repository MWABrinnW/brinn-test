select
    gl_entry_date
    , gl_effective_date
    , gl_je_posted_date
    , gl_je_batch_id
    , gl_je_batch_name
    , gl_je_batch_description
    , gl_je_header_id
    , gl_je_name
    , gl_je_description
    , gl_je_line_id
    , gl_je_line_description
    , gl_reversed_je_header_id
    , gl_reversed_je_header_name
    , _0_account_number
    , _1_legal_entity_id
    , _2_product_id
    , _3_accounting_id
    , _4_team_id
    , _5_natural_account_id
    , _6_initiative_id
    , _7_intercompany_id
    , _8_future_id
    , legal_entity_name
    , product_name
    , accounting_id_name
    , team_name
    , natural_account_name
    , initiative_name
    , intercompany_name
    , future_name
    , account_type
    , journal_source
    , journal_category
    , entered_debit_amount
    , entered_credit_amount
    , converted_debit_amount
    , converted_credit_amount
    , gl_je_created_by
    , extract_datetime
    , mariner_gl_record_id
    , effective_date
    , _created_at
    , _source_file
    , _record_id
from {{ ref('erp__stg_general_ledger_inbound') }}
qualify
    row_number() over (partition by _record_id order by _created_at desc) = 1
