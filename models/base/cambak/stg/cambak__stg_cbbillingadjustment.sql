select
    billingadjustmentid::int                                              as billing_adjustment_id
    , adjustmenttiming::int                                               as adjustment_timing
    , to_timestamp_ntz(effectivedate::text , 'MM/DD/YYYY HH12:MI:SS AM')  as effective_date
    , to_timestamp_ntz(expirationdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as expiration_date
    , adjustmenttype::int                                                 as adjustment_type
    , adjustmentfactor::number(20 , 4)                                    as adjustment_factor
    , onetimeinvoicenumber::int                                           as one_time_invoice_number
    , billingdefinitionid::int                                            as billing_definition_id
    , externalitemid::int                                                 as external_item_id
    , invoicedescription::text                                            as invoice_description
    , adjustmentnote::text                                                as adjustment_note
    , to_boolean(appliestoplanbreakdown::text)::int                       as applies_to_plan_breakdown
    , to_boolean(commissionable::text)::int                               as commissionable

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                     as _extracted_at
    , file_type::text                                                     as file_type
    , _created_at::timestamp                                              as _created_at
    , _source_file::text                                                  as _source_file
from {{ source('cambak', 'cbbillingadjustment') }}
