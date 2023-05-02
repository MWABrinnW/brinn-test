{%- macro isrc_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_sequence_identifier
, nullif(nullif(trim(substring(content, 4, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 10, 1), '0'))::varchar(1) as change_indicator
, trim(nullif(substring(content, 11, 3), '000'))::varchar(3) as source_code
, trim(nullif(substring(content, 14, 26), '00000000000000000000000000'))::varchar(26) as source_code_description_line_one
, trim(nullif(substring(content, 40, 26), '00000000000000000000000000'))::varchar(26) as source_code_description_line_two
, trim(nullif(substring(content, 66, 26), '00000000000000000000000000'))::varchar(26) as source_code_description_line_three
, trim(nullif(substring(content, 92, 3), '000'))::varchar(3) as tax_status
-- , trim(nullif(substring(content, 95, 3), '000'))::varchar(3) as not_used
, trim(nullif(substring(content, 98, 8), '00000000'))::varchar(8) as userid_of_person_who_last_addedupdated_record
, try_to_date(nullif(substring(content, 106, 8), '00000000'), 'YYYYMMDD')::date as date_added
, trim(nullif(substring(content, 114, 8), '00000000'))::varchar(8) as date_updated
, trim(nullif(substring(content, 122, 1), '0'))::varchar(1) as ira_income_eligible
, trim(nullif(substring(content, 123, 1), '0'))::varchar(1) as retail_income_eligible
, trim(nullif(substring(content, 124, 1), '0'))::varchar(1) as customerfirm
, trim(nullif(substring(content, 125, 1), '0'))::varchar(1) as creditdebit
, trim(nullif(substring(content, 126, 4), '0000'))::varchar(4) as statement_indicator
, trim(nullif(substring(content, 130, 4), '0000'))::varchar(4) as statement_activity_summary_indicator
, trim(nullif(substring(content, 134, 2), '00'))::varchar(2) as statement_activity_summary_number
, trim(nullif(substring(content, 136, 4), '0000'))::varchar(4) as statement_transaction_summary_indicator
, trim(nullif(substring(content, 140, 2), '00'))::varchar(2) as statement_transaction_number
, trim(nullif(substring(content, 142, 4), '0000'))::varchar(4) as statement_distribution_indicator
, trim(nullif(substring(content, 146, 2), '00'))::varchar(2) as statement_distribution_number
, trim(nullif(substring(content, 148, 1), '0'))::varchar(1) as statement_distribution_taxable_indicator
, trim(nullif(substring(content, 149, 4), '0000'))::varchar(4) as statement_dividend_indicator
, trim(nullif(substring(content, 153, 2), '00'))::varchar(2) as statement_dividend_number
, trim(nullif(substring(content, 155, 1), '0'))::varchar(1) as statement_dividend_taxable_indicator
, trim(nullif(substring(content, 156, 3), '000'))::varchar(3) as pershing_department
, trim(nullif(substring(content, 159, 22), '0000000000000000000000'))::varchar(22) as pershing_group_that_manages_the_source_code
-- , trim(nullif(substring(content, 181, 40), '0000000000000000000000000000000000000000'))::varchar(40) as not_used_2
, trim(nullif(substring(content, 221, 8), '00000000'))::varchar(8) as userid_of_person_who_added_code
, trim(nullif(substring(content, 229, 8), '00000000'))::varchar(8) as userid_of_person_who_updated_code
, trim(nullif(substring(content, 237, 3), '000'))::varchar(3) as for_pershing_internal_use_only
, trim(nullif(substring(content, 240, 1), '0'))::varchar(1) as portfolio_eligible_indicator
, trim(nullif(substring(content, 241, 1), '0'))::varchar(1) as reinvest_indicator
-- , trim(nullif(substring(content, 242, 8), '00000000'))::varchar(8) as not_used_3
, trim(nullif(substring(content, 250, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
