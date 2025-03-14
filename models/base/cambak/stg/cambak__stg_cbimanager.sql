select
    imanagerid::int            as i_manager_id
    , imanagername::text       as i_manager_name
    , secnumber::text          as sec_number
    , orgcrdnumber::text       as org_crd_number
    , morningstarbrandid::text as morningstar_brand_id
    , morningstarfirmid::text  as morningstar_firm_id
    , weburl::text             as web_url
    , aliasname::text          as aliasname

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                          as _extracted_at
    , file_type::text          as file_type
    , _created_at::timestamp   as _created_at
    , _source_file::text       as _source_file
from {{ source('cambak', 'cbimanager') }}
