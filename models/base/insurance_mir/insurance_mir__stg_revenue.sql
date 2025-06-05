select
    case when json:"Revenue Type"::text ilike '%mps%'
            then 'mps'
        else 'mwa'
    end::text                                           as firm_source
    , try_to_date((json:"Date"::text))                  as date
    , nullif(json:"Policy"::text , '')                  as policy
    , nullif(json:"Gross Comm" , '')::number(18 , 2)    as gross_comm
    , nullif(json:"MIR" , '')::number(18 , 2)           as mir
    , nullif(json:"Net Comm" , '')::number(18 , 2)      as net_comm
    , nullif(json:"MPS" , '')::number(18 , 2)           as mps
    , nullif(json:"Carrier" , '')::text                 as carrier
    , nullif(json:"Client" , '')::text                  as client
    , nullif(json:"Revenue Type" , '')::text            as revenue_type
    , nullif(json:"Lead Consultant" , '')::text         as lead_consultant
    , nullif(json:"IC" , '')::text                      as ic
    , nullif(json:"Client Manager 1" , '')::text        as client_manager_1
    , nullif(json:"Client Manager 2" , '')::text        as client_manager_2
    , nullif(json:"Introducer 1" , '')::text            as introducer_1
    , nullif(json:"Introducer 2" , '')::text            as introducer_2
    , nullif(json:"3rd Party Intro" , '')::text         as third_party_intro
    , nullif(json:"Rev Acct" , '')::text                as rev_acct
    , nullif(json:"Household Name" , '')::text          as household_name
    , try_to_date((json:"Salesforce Start Date"::text)) as salesforce_start_date
    , nullif(json:"Referring Office" , '')::text        as referring_office
    , nullif(json:"Account" , '')::text                 as account
    , nullif(json:"Salesforce ID" , '')::text           as salesforce_id
    , nullif(json:"Rev Pmt Quarter" , '')::text         as rev_pmt_quarter
    , _created_at::datetime                             as _created_at
    , _box_file_id::text                                as _box_file_id
    , _box_file_name::text                              as _box_file_name
    , _box_meta::variant                                as _box_meta
    , {{ col_is_head_with_partition(reference 
        , partition_col='_box_file_name'
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('insurance_mir', 'revenue') }}
