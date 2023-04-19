{%- macro isca_c(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 17, 1), '0'))::varchar(1) as state_tax_indicator
, trim(nullif(substring(content, 18, 1), '0'))::varchar(1) as federal_taxable_status_indicator
, trim(nullif(substring(content, 19, 1), '0'))::varchar(1) as alternative_minimum_tax_amt_indicator
, trim(nullif(substring(content, 20, 1), '0'))::varchar(1) as regulated_investment_company_ric_indicator
, trim(nullif(substring(content, 21, 1), '0'))::varchar(1) as number_of_description_lines
, trim(nullif(substring(content, 22, 20), '00000000000000000000'))::varchar(20) as security_description_line_1
, trim(nullif(substring(content, 42, 20), '00000000000000000000'))::varchar(20) as security_description_line_2
, trim(nullif(substring(content, 62, 20), '00000000000000000000'))::varchar(20) as security_description_line_3
, trim(nullif(substring(content, 82, 20), '00000000000000000000'))::varchar(20) as security_description_line_4
, trim(nullif(substring(content, 102, 20), '00000000000000000000'))::varchar(20) as security_description_line_5
, trim(nullif(substring(content, 122, 2), '00'))::varchar(2) as user_cusip_identifier
, {{target.schema}}.YYYYDDD_to_date(nullif(substring(content, 124, 7), '0000000'))::date as price_purge_date
, trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as taxable_indicator
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'C'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
