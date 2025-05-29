select
    'axys'::text(500)                                         as system_name
    , 'granite'::text(500)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(500) as system_key
    , 'mwa'                                                   as firm_source
    , effective_date::date                                    as effective_date
    , json:"account number"::text(500)                        as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(json:"account number"::text(500)) , '-' , '')) , '0')::text(500)
        , '\\s{2,}' , ' '
    )::text(500)                                              as account_number
    , json:"acct name"::text(500)                             as acct_name
    , json:"acct status"::text(500)                           as acct_status
    , json:"aum"::decimal(20 , 2)                             as aum
    , to_date(json:"beginmgmt"::text(500) , 'MM-DD-YY')       as begin_mgmt_date
    , case
        when (json:"close date"::text(500)) = '??-??-??'
            then null
        else to_date(json:"close date"::text(500) , 'MM-DD-YY')
    end::date                                                 as close_date
    , json:"close value"::decimal(20 , 2)                     as close_value
    , json:"covoff"::text(500)                                as coverage_officer
    , json:"crm id"::text(500)                                as crm_id
    , json:"custodian"::text(500)                             as custodian
    , json:"discretion"::text(500)                            as discretion
    , json:"goal"::text(500)                                  as goal
    , json:"initial value"::decimal(20 , 2)                   as initial_value
    , json:"portfolio code"::text(500)                        as portfolio_code
    , json:"prime enabled"::text(500)                         as prime_enabled
    , json:"proxy vote"::text(500)                            as proxy_vote
    , to_date(json:"report date"::text(500) , 'MM-DD-YY')     as report_date
    , json:"type"::text(500)                                  as account_type
    , {{ col_is_head(reference=source('axys_granite', 'accounts')) }}
    , _source_file::text(500)                                 as _source_file
    , _created_at::datetime                                   as _created_at
    , _id::int                                                as _id
from {{ source('axys_granite', 'accounts') }}
