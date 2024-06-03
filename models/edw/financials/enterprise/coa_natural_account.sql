select
    'oracle_edm'::text(200)   as system_name
    , name::text(200)         as _5_natural_account_id
    , description::text(200)  as natural_account_name
    , is_enabled::int         as is_enabled
    , end_date::date          as end_date
    , account_type::text(200) as account_type
    , attr_01::text(200)      as financial_category
    , attr_02::text(200)      as financial_statement
    , attr_03::text(200)      as financial_statement_category
    , attr_04::text(200)      as financial_statement_section
    , attr_05::text(200)      as financial_statement_line_item_1
    , attr_06::text(200)      as financial_statement_line_item_2
    , effective_date::date    as effective_date
    , is_head::int            as is_head
    , _created_at::timestamp  as _created_at
    , _source_file::text(200) as _source_file
from {{ ref('edm__stg_natural_account') }}
where true
    and try_to_boolean(attr_07)::int = 1
order by effective_date desc
