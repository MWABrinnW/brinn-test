select
    "ACQUISITION NAME"::varchar(150)                                  as acquisition_name
  , "INTEGRATION MILESTONE"::varchar(2000)                            as integration_milestone
  , "STANDARD APPROACH"::varchar(2000)                                as standard_approach
  , strategy::varchar(5000)                                           as strategy
  , status::varchar(2000)                                             as status
  , try_to_date("TARGET START", 'MM/DD/YY')                           as target_start
  , try_to_date("TARGET END", 'MM/DD/YY')                             as target_end
  , loe::varchar(500)                                                 as level_of_effort
  , risk                                                              as risk
  , "BUSINESS PRIORITY/RATIONALE"::varchar(2000)                      as business_priority
  , "ESS AND OPS TEAMS NEEDED FOR PROJECT"::varchar(2000)             as ess_and_ops_teams_needed_for_project
  , "ESS & OPS RESOURCE NAMES (LIGHT SUPPORT)"::varchar(2000)         as ess_and_ops_resource_names_light_support
  , "ESS & OPS TEAM RESOURCE NAMES (HEAVY SUPPORT)"::varchar(2000)    as ess_and_ops_resource_names_heavy_support
  , health::varchar(2000)                                             as health
  , "ALERTED HEALTH REASON"::varchar(2000)                            as alerted_health_reason
  , "ADDITIONAL HEALTH COMMENTS"::varchar(2000)                       as additional_health_comments
  , "LINKS TO ADD'L DETAIL (IF APPLICABLE)"::varchar(2000)            as links_to_additional_detail
  , "LEGACY SYSTEM (IF APPLICABLE)"::varchar(2000)                    as legacy_system
  , "LEGACY SYSTEM CONTRACT TERM DATE (IF APPLICABLE)"::varchar(2000) as legacy_system_contract_term_date
  , owner::varchar(2000)                                              as owner
  , _created_at::timestamp                                            as _created_at
from {{ source('aux', 'integration_roadmap') }}