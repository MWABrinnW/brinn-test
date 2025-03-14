select
    invoiceid::int                                                         as invoice_id
    , billingdefinitionid::int                                             as billing_definition_id
    , to_timestamp_ntz(invoicedate::text , 'MM/DD/YYYY HH12:MI:SS AM')     as invoice_date
    , to_timestamp_ntz(calculationdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as calculation_date
    , to_timestamp_ntz(creationdate::text , 'MM/DD/YYYY HH12:MI:SS AM')    as creation_date
    , invoicenumber::int                                                   as invoice_number
    , invoicetotal::number(20 , 2)                                         as invoice_total
    , to_timestamp_ntz(changedate::text , 'MM/DD/YYYY HH12:MI:SS AM')      as change_date
    , changeuserid::int                                                    as change_user_id
    , changereason::text                                                   as change_reason
    , to_boolean(hasadjustments::text)::int                                as has_adjustments
    , to_boolean(firmpulled::text)::int                                    as firm_pulled
    , rkname::text                                                         as rk_name
    , to_boolean(rkpaid::text)::int                                        as rk_paid

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                      as _extracted_at
    , file_type::text                                                      as file_type
    , _created_at::timestamp                                               as _created_at
    , _source_file::text                                                   as _source_file
from {{ source('cambak', 'cbinvoice') }}
