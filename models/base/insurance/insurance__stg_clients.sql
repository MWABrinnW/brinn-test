select
    case when json:"Revenue Type"::text ilike '%mps%'
            then 'mps'
        else 'mwa'
    end::text                                            as firm_source
    , try_to_date((json:"Date Added"::text))             as date_added
    , nullif(json:"Policy" , '')::text                   as policy
    , nullif(json:"Carrier" , '')::text                  as carrier
    , nullif(json:"Client" , '')::text                   as client
    , nullif(json:"Revenue Type" , '')::text             as revenue_type
    , nullif(json:"Commissions Revenue Type" , '')::text as commissions_revenue_type
    , nullif(json:"Lead Consultant" , '')::text          as lead_consultant
    , nullif(json:"IC" , '')::text                       as ic
    , nullif(json:"Client Manager 1" , '')::text         as client_manager_1
    , nullif(json:"Client Manager 2" , '')::text         as client_manager_2
    , nullif(json:"Introducer 1" , '')::text             as introducer_1
    , nullif(json:"Introducer 2" , '')::text             as introducer_2
    , nullif(json:"Client Manager Override" , '')::text  as client_manager_override
    , nullif(json:"Introducer Override" , '')::text      as introducer_override
    , nullif(json:"Lead Consultant ID" , '')::text       as lead_consultant_id
    , nullif(json:"IC ID" , '')::text                    as ic_id
    , nullif(json:"CM Override ID" , '')::text           as cm_override_id
    , nullif(json:"Intro Override ID" , '')::text        as intro_override_id
    , nullif(json:"3rd Party Intro" , '')::text          as third_party_intro
    , nullif(json:"3rd Party Override Rate" , '')::text  as third_party_override_rate
    , nullif(json:"Rev Acct" , '')::text                 as rev_acct
    , nullif(json:"Household Name" , '')::text           as household_name
    , try_to_date((json:"Salesforce Start Date"::text))  as salesforce_start_date
    , nullif(json:"Salesforce ID" , '')::text            as salesforce_id
    , _created_at::datetime                              as _created_at
    , _box_file_id::text                                 as _box_file_id
    , _box_file_name::text                               as _box_file_name
    , _box_meta::variant                                 as _box_meta
    , {{ col_is_head_with_partition(reference 
        , partition_col='_box_file_name'
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('insurance', 'clients') }}
