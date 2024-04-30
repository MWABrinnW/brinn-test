select
    jobid::int                                                                   as job_id
    , queuename::text(200)                                                       as que_name
    , queuepriority::int                                                         as que_priority
    , templatejobid::int                                                         as template_job_id
    , jobname::text(200)                                                         as job_name
    , originalqueuename::text(200)                                               as orginal_queue_name
    , type::int                                                                  as type
    , state::int                                                                 as state
    , substate::int                                                              as sub_state
    , executionreason::int                                                       as execution_reason
    , lasteventid::int                                                           as last_event_id
    , nullif(username , '')::text(200)                                           as user_name
    , submittinguser::text(200)                                                  as submitting_user
    , to_timestamp_ntz(jobsubmissiontime , 'MM/DD/YYYY HH12:MI:SS AM')           as job_submission_time
    , to_timestamp_ntz(jobeligibilitytime , 'MM/DD/YYYY HH12:MI:SS AM')          as job_eligibility_time
    , to_timestamp_ntz(starttime , 'MM/DD/YYYY HH12:MI:SS AM')                   as start_time
    , try_to_timestamp_ntz(jsscompletiontime , 'MM/DD/YYYY HH12:MI:SS AM')       as jss_completion_time
    , try_to_timestamp_ntz(execagentcompletiontime , 'MM/DD/YYYY HH12:MI:SS AM') as exec_agent_completion_time
    , to_timestamp_ntz(revisiontime , 'MM/DD/YYYY HH12:MI:SS AM')                as revision_time
    , try_to_timestamp_ntz(restarttime , 'MM/DD/YYYY HH12:MI:SS AM')             as restart_time
    , nullif(standardoutputfile , '')::text(200)                                 as standard_output_file
    , nullif(standarderrorfile , '')::text(200)                                  as standard_error_file
    , jobstepstodo::int                                                          as job_steps_to_do
    , jobstepsdone::int                                                          as job_steps_done
    , nullif(joblogfile , '')::text(200)                                         as job_log_file
    , nullif(workingdirectory , '')::text(200)                                   as working_directory
    , jobstatus::int                                                             as job_status
    , lastjobid::int                                                             as last_job_id
    , successfulinstances::int                                                   as successful_instances
    , failedinstances::int                                                       as failed_instances
    , multiinstancecount::int                                                    as multi_instance_count
    , cpudays::int                                                               as cpu_days
    , cpuhours::int                                                              as cpu_hours
    , cpuminutes::int                                                            as cpu_minutes
    , cpuseconds::int                                                            as cpu_seconds
    , cpumilliseconds::int                                                       as cpu_milliseconds
    , revisionid::int                                                            as revision_id
    , nullif(executionmachine , '')::text(200)                                   as execution_machine
    , nullif(successcompletioncodes , '')::text(200)                             as success_completion_codes
    , description::text                                                          as description
    , nullif(category , '')::text(200)                                           as category
    , nullif(documentation , '')::text(200)                                      as documentation
    , revisedby::text(200)                                                       as revised_by
    , nullif(triggeredby , '')::text(200)                                        as triggered_by
    , nullif(successcodestring , '')::text(200)                                  as success_code_string
    , nullif(exitcodedescription , '')::text(200)                                as exit_code_description
    , instancetype::int                                                          as instance_type
    , nullif(jobtype , '')::text(200)                                            as job_type
    , path::text(200)                                                            as path
    , statetext::text(200)                                                       as state_text
    , nullif(statedetailtext , '')::text(200)                                    as state_detail_text
    , _created_at::timestamp_ntz                                                 as _created_at
    , _updated_at::timestamp_ntz                                                 as _updated_at
from {{ source('activebatch','executions') }}
