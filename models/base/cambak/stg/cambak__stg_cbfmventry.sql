select
    planid::int                                                        as plan_id
    , fmv::number(20 , 2)                                              as fmv
    , year::int                                                        as year
    , month::int                                                       as month
    , to_timestamp_ntz(createddate::text , 'MM/DD/YYYY HH12:MI:SS AM') as created_date
    , createdby::int                                                   as created_by
    , to_boolean(istrueup::text)::int                                  as is_true_up
    , invoiceid::int                                                   as invoice_id
    , note::text                                                       as note
    , fmventryid::int                                                  as fmv_entry_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                  as _extracted_at
    , file_type::text                                                  as file_type
    , _created_at::timestamp                                           as _created_at
    , _source_file::text                                               as _source_file
from {{ source('cambak', 'cbfmventry') }}
