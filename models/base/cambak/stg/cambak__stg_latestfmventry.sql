select
    calculationdate::text             as calculation_date
    , createdby::text                 as created_by
    , createddate::text               as created_date
    , fmv::float                      as fmv
    , fmventryid::integer             as fmv_entry_id
    , invoicedate::text               as invoice_date
    , invoiceid::text                 as invoice_id
    , invoicenumber::text             as invoice_number
    , invoicetotal::text              as invoice_total
    , to_boolean(istrueup::text)::int as is_true_up
    , month::integer                  as month
    , noofhistory::integer            as no_of_history
    , note::text                      as note
    , planid::integer                 as plan_id
    , year::integer                   as year
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                 as _extracted_at
    , file_type::text                 as file_type
    , _created_at::timestamp          as _created_at
    , _source_file::text              as _source_file
from {{ source('cambak', 'latestfmventry') }}
