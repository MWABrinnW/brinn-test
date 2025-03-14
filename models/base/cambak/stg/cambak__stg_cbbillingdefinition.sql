select
    billingdefinitionid::int                                               as billing_definition_id
    , description::text                                                    as description
    , billingtypeid::int                                                   as billing_type_id
    , billingtimingid::int                                                 as billing_timing_id
    , billingfrequencyid::int                                              as billing_frequency_id
    , to_timestamp_ntz(effectivedate::text , 'MM/DD/YYYY HH12:MI:SS AM')   as effective_date
    , to_timestamp_ntz(expirationdate::text , 'MM/DD/YYYY HH12:MI:SS AM')  as expirationd_ate
    , to_timestamp_ntz(creationdate::text , 'MM/DD/YYYY HH12:MI:SS AM')    as creation_date
    , createdbyid::int                                                     as created_by_id
    , to_boolean(isexpensebillpermitted::text)::int                        as is_expense_bill_permitted
    , billingdefinitiondetail::text                                        as billing_definition_detail
    , firmid::int                                                          as firm_id
    , notes::text                                                          as notes
    , to_boolean(isactive::text)::int                                      as is_active
    , billingstyleid::int                                                  as billing_style_id
    , lineitemsplittypeid::int                                             as line_item_split_type_id
    , fmvsourceid::text                                                    as fmv_source_id
    , fmvsourcemonth::int                                                  as fmv_source_month
    , externalcustomerid::int                                              as external_customer_id
    , externalclassid::text                                                as external_class_id
    , to_boolean(hasannualextremum::text)::int                             as has_annual_extremum
    , to_boolean(requiresmanualintervention::text)::int                    as requires_manual_intervention
    , to_timestamp_ntz(terminationdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as termination_date
    , ponumber::text                                                       as po_number
    , to_timestamp_ntz(postartdate::text , 'MM/DD/YYYY HH12:MI:SS AM')     as po_start_date
    , to_timestamp_ntz(poenddate::text , 'MM/DD/YYYY HH12:MI:SS AM')       as po_end_date
    , povalue::number(20 , 2)                                              as po_value
    , to_boolean(showponumoninvoice::text)::int                            as show_po_num_on_invoice
    , to_boolean(istrueupenabled::text)::int                               as is_trueup_enabled
    , to_boolean(hasrenewaloptions::text)::int                             as has_renewal_options
    , to_boolean(rkpaid::text)::int                                        as rk_paid
    , to_boolean(firmpulled::text)::int                                    as firm_pulled
    , compensationnotes::text                                              as compensation_notes

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                      as _extracted_at
    , file_type::text                                                      as file_type
    , _created_at::timestamp                                               as _created_at
    , _source_file::text                                                   as _source_file
from {{ source('cambak', 'cbbillingdefinition') }}
