{%- macro fidelity_secmast_26(src) -%}
select
    RECORD_TYPE                                      as RECORD_TYPE
  , RECORD_NUMBER                                    as RECORD_NUMBER
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src.identifier.split('_')[1].lower() ~ "'" }}                                 as firm_source
  , SECURITY_TYPE                                    as SECURITY_TYPE
  , case
        when nvl(IFM_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(IFM_DATE, 'YYYYMMDD') end::date as IFM_DATE
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}