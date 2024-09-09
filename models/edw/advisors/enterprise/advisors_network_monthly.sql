with cte_dates as (
    select distinct effective_date
    from {{ source('reporting_ext', 'vw_network_advisor_master_monthly') }}
    order by effective_date
)

, cte_lpl_emails as (
    select distinct
        effective_date
        , rep_id
        , email_address
    from {{ ref('lpl_network__base_reps') }}
    where 1 = 1
        and is_head = 1
        and email_address is not null
        and effective_date in (select effective_date from cte_dates)
    qualify dense_rank() over (partition by effective_date , rep_id order by _source_loaded_at desc) = 1
)

, cte_lpl_emails_all_time as (
    select distinct
        rep_id
        , email_address
    from {{ ref('lpl_network__base_reps') }}
    where 1 = 1
        and email_address is not null
    qualify dense_rank() over (partition by rep_id order by _source_loaded_at desc) = 1
)

, cte_redtail_emails as (
    select distinct
        contact_id
        , email_address
        /*
        debugging fields: support deduplication
        --, email_type_description
        --, email_type
        --, is_primary
        --, custom_type_title
        */
        , dense_rank() over (partition by contact_id order by _source_loaded_at desc , is_primary desc , email_type desc) as rn
    from {{ ref('redtail_network__base_contact_email_addresses') }}
    where 1 = 1
        and is_head = 1
)

select
    a.record_id::varchar(500)                                                     as record_id
    , a.system_name::varchar(500)                                                 as system_name
    , a.system_details::varchar(500)                                              as system_details
    , a.redtail_id::varchar(500)                                                  as redtail_id
    , a.advisor_full_name::varchar(500)                                           as advisor_full_name
    , a.advisor_first_name::varchar(500)                                          as advisor_first_name
    , a.advisor_last_name::varchar(500)                                           as advisor_last_name
    , a.advisor_active_ind::boolean                                               as advisor_active_ind
    , a.advisor_firm_name::varchar(500)                                           as advisor_firm_name
    , a.advisor_start_date::date                                                  as advisor_start_date
    , a.advisor_termination_date::varchar(500)                                    as advisor_termination_date
    , a.advisor_age_band::varchar(500)                                            as advisor_age_band
    , a.advisor_years_of_service::varchar(500)                                    as advisor_years_of_service
    , a.work_site_address_1::varchar(500)                                         as work_site_address_1
    , a.work_site_address_2::varchar(500)                                         as work_site_address_2
    , a.work_site_city::varchar(500)                                              as work_site_city
    , a.work_site_state::varchar(500)                                             as work_site_state
    , a.work_site_zip_code::varchar(500)                                          as work_site_zip_code
    , a.work_phone::varchar(500)                                                  as work_phone
    , a.work_email::varchar(500)                                                  as work_email
    , a.redtail_category::varchar(500)                                            as redtail_category
    , a.redtail_status::varchar(500)                                              as redtail_status
    , a.service_tier::varchar(500)                                                as service_tier
    , a.house_accounts_ind::boolean                                               as house_accounts_ind
    , a.legacy_mps_advisor_ind::boolean                                           as legacy_mps_advisor_ind
    , a.affiliation_model::varchar(500)                                           as affiliation_model
    , a.start_this_month::int                                                     as start_this_month
    , a.end_this_month::int                                                       as end_this_month
    , a.new_this_month::int                                                       as new_this_month
    , a.lost_this_month::int                                                      as lost_this_month
    , a.other_adj_this_month::int                                                 as other_adj_this_month
    , a.affiliation_model_change::int                                             as affiliation_model_change
    , a.prior_affiliation_model::varchar(500)                                     as prior_affiliation_model
    , a.advisor_status_change_date::varchar(500)                                  as advisor_status_change_date
    , a.advisor_status_notes::varchar(500)                                        as advisor_status_notes
    , a.termination_type::varchar(500)                                            as termination_type
    , a.termination_reason::varchar(500)                                          as termination_reason
    , a.firm_id::varchar(500)                                                     as firm_id
    , a.lpl_master_rep_id::varchar(500)                                           as lpl_master_rep_id
    , a.individual_crd::varchar(500)                                              as individual_crd
    , a.broker_dealer::varchar(500)                                               as broker_dealer
    , a.custodian::varchar(500)                                                   as custodian
    , a.pms_system::varchar(500)                                                  as pms_system
    , a.crm_system::varchar(500)                                                  as crm_system
    , a.location_code::varchar(500)                                               as location_code
    , a.source_system_client_manager::varchar(500)                                as source_system_client_manager
    , a.portfolio_consulting_ind::varchar(500)                                    as portfolio_consulting_ind
    , a.hubspot_deal_id::varchar(500)                                             as hubspot_deal_id
    , a.source_created_datetime::varchar(500)                                     as source_created_datetime
    , a.added_by_name::varchar(500)                                               as added_by_name
    , a.effective_date::date                                                      as effective_date
    , a.month_end_date::date                                                      as month_end_date
    , a.record_date::date                                                         as record_date
    , a.record_datetime::timestamp_ntz                                            as record_datetime
    , coalesce(lpl.email_address , redtail.email_address , lpl_all.email_address) as advisor_email
    , {{ col_is_head(
        reference=source('reporting_ext', 'vw_network_advisor_master_monthly')
        , source_date_col='a.effective_date'
        ) }}
    , current_timestamp()                                                         as _created_at
from {{ source('reporting_ext', 'vw_network_advisor_master_monthly') }} as a
left join cte_lpl_emails as lpl
    on a.effective_date = lpl.effective_date
    and a.lpl_master_rep_id = lpl.rep_id
left join cte_redtail_emails as redtail
    on a.redtail_id = redtail.contact_id
    and redtail.rn = 1
left join cte_lpl_emails_all_time as lpl_all
    on a.lpl_master_rep_id = lpl_all.rep_id
qualify row_number() over (partition by a.record_id order by advisor_email desc) = 1
