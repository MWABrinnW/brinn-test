{% set src = source('center', 'users') %}

select
    s.json:id::varchar                          as id
    , s.json:employeeId::varchar                as employee_id
    , s.json:emailAddress::varchar              as email_address
    , s.json:firstName::varchar                 as first_name
    , s.json:lastName::varchar                  as last_name
    , s.json:isEnrolledInFraudAlerts::int       as is_enrolled_in_fraud_alerts
    , s.json:title::varchar                     as title
    , s.json:phoneNumber::varchar               as phone_number
    , s.json:dateOfBirth::varchar               as date_of_birth
    , s.json:cards::varchar                     as cards
    , s.json:defaultApprover::variant           as default_approver
    , s.json:delegateOf::variant                as delegate_of
    , s.json:travelArrangerOf::variant          as travel_arranger_of
    , s.json:roles::variant                     as roles
    , s.json:costCenters::variant               as cost_centers

    , s.json:billingAddress:address::varchar    as billing_address
    , s.json:billingAddress:city::varchar       as billing_city
    , s.json:billingAddress:state::varchar      as billing_state
    , s.json:billingAddress:postalCode::varchar as billing_postal_code
    , s.json:billingAddress:country::varchar    as billing_country

    , s.json:defaultCostCenter:id::varchar      as default_cost_center_id
    , s.json:defaultCostCenter:name::varchar    as default_cost_center_name

    , {{ col_is_head(
        reference=src,
        reference_date_col='_created_at',
        source_date_col='s._created_at'
        ) }}
    , s._created_at::timestamp_ntz              as _created_at
    , s._source_file::varchar                   as _source_file

from {{ src }} as s
