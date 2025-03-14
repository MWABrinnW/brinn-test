select
    userid::int                                                            as userid
    , firstname::text                                                      as first_name
    , lastname::text                                                       as last_name
    , email::text                                                          as email
    , loginname::text                                                      as login_name
    , password::text                                                       as password
    , firmid::int                                                          as firm_id
    , to_boolean(isactive::text)::int                                      as is_active
    , to_boolean(preference_filterclientsbyuser::text)::int                as preference_filter_clients_by_user
    , to_boolean(preference_notifytaskassign::text)::int                   as preference_notify_task_assign
    , to_boolean(preference_notifymeetinginvite::text)::int                as preference_notify_meeting_invite
    , preference_landingpage::int                                          as preference_landing_page
    , to_boolean(preference_notifyoppteam::text)::int                      as preference_notify_opp_team
    , to_boolean(preference_notifycreateopp::text)::int                    as preference_notify_create_opp
    , to_boolean(preference_notifyupdateopp::text)::int                    as preference_notify_update_opp
    , preference_namesortingformat::int                                    as preference_name_sorting_format
    , preference_namedisplayformat::int                                    as preference_name_display_format
    , to_boolean(preference_notifytaskstepupdates::text)::int              as preference_notify_task_step_updates
    , to_boolean(preference_notifytaskupdate::text)::int                   as preference_notify_task_update
    , to_boolean(preference_notifynewproductflag::text)::int               as preference_notify_new_product_flag
    , to_boolean(preference_notifycustodialrelationshipupdates::text)::int
        as preference_notify_custodial_relationship_updates
    , preference_dateformat::int                                           as preference_date_format
    , oraclepersonid::int                                                  as oracle_person_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                      as _extracted_at
    , file_type::text                                                      as file_type
    , _created_at::timestamp                                               as _created_at
    , _source_file::text                                                   as _source_file
from {{ source('cambak', 'cbuser') }}
