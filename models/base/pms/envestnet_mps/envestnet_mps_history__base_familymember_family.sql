select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , "FileName"                                   as filename
    , record_type
    , customer_id
    , family_name
    , split_rep_code
    , disable_qpr_download_to_professsional_printer_flag
    , disable_access_to_qpr_on_client_web_site_flag
    , sample_client_flag
    , {{ col_is_head(reference=source('envestnet_mps', 'familymember_family')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'familymember_family') }}
