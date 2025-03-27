select
    billingdefinitiondetail::text                       as billing_definition_detail
    , billingdefinitionid::integer                      as billing_definition_id
    , billingfrequencyid::integer                       as billingfrequency_id
    , billingfrequencystring::text                      as billing_frequency_string
    , billingstyleid::integer                           as billing_style_id
    , billingstylestring::text                          as billing_style_string
    , billingtimingid::integer                          as billing_timing_id
    , billingtimingstring::text                         as billing_timing_string
    , billingtypeid::integer                            as billing_type_id
    , billingtypestring::text                           as billing_type_string
    , clientids::text                                   as client_ids
    , clientnames::text                                 as client_names
    , clientsubtypes::text                              as client_subtypes
    , clienttypes::text                                 as client_types
    , createdbyfirst::text                              as created_by_first
    , createdbyid::text                                 as created_by_id
    , createdbylast::text                               as created_by_last
    , creationdate::text                                as creation_date
    , description::text                                 as description
    , effectivedate::text                               as effective_date
    , expirationdate::text                              as expiration_date
    , externalclassid::integer                          as external_class_id
    , externalcustomerid::integer                       as external_customer_id
    , firmid::integer                                   as firm_id
    , to_boolean(firmpulled::text)::int                 as firm_pulled
    , fmvsourceid::text                                 as fmv_source_id
    , fmvsourcemonth::text                              as fmv_source_month
    , to_boolean(hasannualextremum::text)::int          as has_annual_extremum
    , to_boolean(hasrenewaloptions::text)::int          as has_renewal_options
    , to_boolean(isactive::text)::int                   as is_active
    , to_boolean(isexpensebillpermitted::text)::int     as is_expense_bill_permitted
    , to_boolean(istrueupenabled::text)::int            as is_true_up_enabled
    , lineitemsplittypeid::integer                      as line_item_split_type_id
    , lineitemssplittypestring::text                    as line_items_split_type_string
    , notes::text                                       as notes
    , planids::text                                     as plan_ids
    , plannames::text                                   as plan_names
    , plansubtypes::text                                as plan_subtypes
    , plantypes::text                                   as plan_types
    , poenddate::text                                   as po_end_date
    , ponumber::text                                    as po_number
    , postartdate::text                                 as po_start_date
    , povalue::text                                     as po_value
    , qboclass::text                                    as qbo_class
    , qbocustomer::text                                 as qbo_customer
    , recordkeepernames::text                           as record_keeper_names
    , to_boolean(requiresmanualintervention::text)::int as requires_manual_intervention
    , to_boolean(rkpaid::text)::int                     as rkpa_id
    , salesforceclientids::text                         as salesforce_client_ids
    , salesforceplanids::text                           as salesforce_plan_ids
    , to_boolean(showponumoninvoice::text)::int         as show_ponum_on_in_voice
    , terminationdate::text                             as termination_date
    , torchids::text                                    as torch_ids
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                   as _extracted_at
    , file_type::text                                   as file_type
    , _created_at::timestamp                            as _created_at
    , _source_file::text                                as _source_file
from {{ source('cambak', 'billingdefinitionex') }}
