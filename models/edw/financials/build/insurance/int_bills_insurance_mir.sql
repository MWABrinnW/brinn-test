select
    system_name::text             as system_name
    , system_instance::text       as system_instance
    , system_key::text            as system_key
    , case
        when lower(revenue_type) in ('mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic') then 'mwa'
        when lower(revenue_type) = 'mps revenue' then 'mps'
        else null
    end::text                     as firm_source
    , date::date                  as date
    , policy::text                as policy
    , gross_comm::number(18 , 2)  as gross_comm
    , case
        when lower(revenue_type) in ('mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic') then net_comm
        when lower(revenue_type) = 'mps revenue' then mps
        else null
    end::number(18 , 2)           as net_comm
    , carrier::text               as carrier
    , client::text                as client
    , revenue_type::text          as revenue_type
    , lead_consultant::text       as lead_consultant
    , ic::text                    as ic
    , client_manager_1::text      as client_manager_1
    , client_manager_2::text      as client_manager_2
    , introducer_1::text          as introducer_1
    , introducer_2::text          as introducer_2
    , third_party_intro::text     as third_party_intro
    , rev_acct::text              as rev_acct
    , household_name::text        as household_name
    , salesforce_start_date::date as salesforce_start_date
    , referring_office::text      as referring_office
    , account::text               as account
    , salesforce_id::text         as salesforce_id
    , rev_pmt_quarter::text       as rev_pmt_quarter
    , is_head::text               as is_head
    , _created_at::datetime       as _created_at
    , _box_file_id::text          as _box_file_id
    , _box_file_name::text        as _box_file_name
    , _box_meta::variant          as _box_meta
from {{ ref('insurance_mir__stg_revenue') }}
where
    lower(revenue_type) in ('mps revenue' , 'mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic')
    and is_head = 1
    and year(date) >= '2025'

union all

select
    system_name::text             as system_name
    , system_instance::text       as system_instance
    , system_key::text            as system_key
    , 'mir'::text                 as firm_source
    , date::date                  as date
    , policy::text                as policy
    , gross_comm::number(18 , 2)  as gross_comm
    , mir::number(18 , 2)         as net_comm
    , carrier::text               as carrier
    , client::text                as client
    , revenue_type::text          as revenue_type
    , lead_consultant::text       as lead_consultant
    , ic::text                    as ic
    , client_manager_1::text      as client_manager_1
    , client_manager_2::text      as client_manager_2
    , introducer_1::text          as introducer_1
    , introducer_2::text          as introducer_2
    , third_party_intro::text     as third_party_intro
    , rev_acct::text              as rev_acct
    , household_name::text        as household_name
    , salesforce_start_date::date as salesforce_start_date
    , referring_office::text      as referring_office
    , account::text               as account
    , salesforce_id::text         as salesforce_id
    , rev_pmt_quarter::text       as rev_pmt_quarter
    , is_head::text               as is_head
    , _created_at::datetime       as _created_at
    , _box_file_id::text          as _box_file_id
    , _box_file_name::text        as _box_file_name
    , _box_meta::variant          as _box_meta
from {{ ref('insurance_mir__stg_revenue') }}
where
    lower(revenue_type) in ('mps revenue' , 'mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic')
    and is_head = 1
    and year(date) >= '2025'

union all

select
    system_name::text             as system_name
    , system_instance::text       as system_instance
    , system_key::text            as system_key
    , case
        when split_part(account , '-' , 3) = '6603' then 'mir'
        else 'mwa'
    end::text                     as firm_source
    , date::date                  as date
    , policy::text                as policy
    , gross_comm::number(18 , 2)  as gross_comm
    , gross_comm::number(18 , 2)  as net_comm
    , carrier::text               as carrier
    , client::text                as client
    , revenue_type::text          as revenue_type
    , lead_consultant::text       as lead_consultant
    , ic::text                    as ic
    , client_manager_1::text      as client_manager_1
    , client_manager_2::text      as client_manager_2
    , introducer_1::text          as introducer_1
    , introducer_2::text          as introducer_2
    , third_party_intro::text     as third_party_intro
    , rev_acct::text              as rev_acct
    , household_name::text        as household_name
    , salesforce_start_date::date as salesforce_start_date
    , referring_office::text      as referring_office
    , account::text               as account
    , salesforce_id::text         as salesforce_id
    , rev_pmt_quarter::text       as rev_pmt_quarter
    , is_head::text               as is_head
    , _created_at::datetime       as _created_at
    , _box_file_id::text          as _box_file_id
    , _box_file_name::text        as _box_file_name
    , _box_meta::variant          as _box_meta
from {{ ref('insurance_mir__stg_revenue') }}
where
    lower(revenue_type) not in ('mps revenue' , 'mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic')
    and is_head = 1
    and year(date) >= '2025'
