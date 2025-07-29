select
    json:ID::text(500)                                            as id
  , json:PORTAL_ID::text(500)                                     as portal_id
  , json:IS_DELETED::text(500)                                    as is_deleted
  , json:_FIVETRAN_SYNCED::text(500)                              as _fivetran_synced
  , json:PROPERTY_HS_ANALYTICS_SOURCE_DATA_2::text(500)           as property_hs_analytics_source_data_2
  , json:PROPERTY_HS_ANALYTICS_NUM_PAGE_VIEWS::text(500)          as property_hs_analytics_num_page_views
  , json:PROPERTY_HS_ANALYTICS_SOURCE_DATA_1::text(500)           as property_hs_analytics_source_data_1
  , json:PROPERTY_HS_ANALYTICS_FIRST_TIMESTAMP::text(500)         as property_hs_analytics_first_timestamp
  , json:PROPERTY_HS_ANALYTICS_NUM_VISITS::text(500)              as property_hs_analytics_num_visits
  , json:PROPERTY_HS_ANALYTICS_SOURCE::text(500)                  as property_hs_analytics_source
  , json:PROPERTY_HS_DATE_ENTERED_OPPORTUNITY::text(500)          as property_hs_date_entered_opportunity
  , json:PROPERTY_FOUNDED_YEAR::text(500)                         as property_founded_year
  , json:PROPERTY_FIRST_DEAL_CREATED_DATE::text(500)              as property_first_deal_created_date
  , json:PROPERTY_HS_ANALYTICS_LATEST_SOURCE::text(500)           as property_hs_analytics_latest_source
  , json:PROPERTY_HS_ANALYTICS_LATEST_SOURCE_DATA_2::text(500)    as property_hs_analytics_latest_source_data_2
  , json:PROPERTY_HS_ANALYTICS_LATEST_SOURCE_DATA_1::text(500)    as property_hs_analytics_latest_source_data_1
  , json:PROPERTY_HS_ANALYTICS_LATEST_SOURCE_TIMESTAMp::text(500) as property_hs_analytics_latest_source_timestam
  , json:PROPERTY_HS_DATE_ENTERED_CUSTOMER::text(500)             as property_hs_date_entered_customer
  , json:PROPERTY_HS_DATE_ENTERED_LEAD::text(500)                 as property_hs_date_entered_lead
  , json:PROPERTY_HS_LASTMODIFIEDDATE::text(500)                  as property_hs_lastmodifieddate
  , json:PROPERTY_HS_NUM_DECISION_MAKERS::text(500)               as property_hs_num_decision_makers
  , json:PROPERTY_HS_NUM_OPEN_DEALS::text(500)                    as property_hs_num_open_deals
  , json:PROPERTY_NUM_ASSOCIATED_DEALS::text(500)                 as property_num_associated_deals
  , json:PROPERTY_HS_TOTAL_DEAL_VALUE::text(500)                  as property_hs_total_deal_value
  , json:PROPERTY_HS_TARGET_ACCOUNT_PROBABILITY::text(500)        as property_hs_target_account_probability
  , json:PROPERTY_NUM_ASSOCIATED_CONTACTS::text(500)              as property_num_associated_contacts
  , json:PROPERTY_HS_OBJECT_ID::text(500)                         as property_hs_object_id
  , json:PROPERTY_HS_TIME_IN_OPPORTUNITY::text(500)               as property_hs_time_in_opportunity
  , json:PROPERTY_IS_PUBLIC::text(500)                            as property_is_public
  , json:PROPERTY_HS_NUM_BLOCKERS::text(500)                      as property_hs_num_blockers
  , json:PROPERTY_HS_NUM_CONTACTS_WITH_BUYING_ROLES::text(500)    as property_hs_num_contacts_with_buying_roles
  , json:PROPERTY_HS_LAST_LOGGED_CALL_DATE::text(500)             as property_hs_last_logged_call_date
  , json:PROPERTY_HS_TIME_IN_CUSTOMER::text(500)                  as property_hs_time_in_customer
  , json:PROPERTY_HS_DATE_EXITED_OPPORTUNITY::text(500)           as property_hs_date_exited_opportunity
  , json:PROPERTY_HS_LAST_SALES_ACTIVITY_DATE::text(500)          as property_hs_last_sales_activity_date
  , json:PROPERTY_HS_LAST_SALES_ACTIVITY_TIMESTAMP::text(500)     as property_hs_last_sales_activity_timestamp
  , json:PROPERTY_HS_LAST_OPEN_TASK_DATE::text(500)               as property_hs_last_open_task_date
  , json:PROPERTY_HS_PIPELINE::text(500)                          as property_hs_pipeline
  , json:PROPERTY_HS_LAST_SALES_ACTIVITY_TYPE::text(500)          as property_hs_last_sales_activity_type
  , json:PROPERTY_HUBSPOT_OWNER_ASSIGNEDDATE::text(500)           as property_hubspot_owner_assigneddate
  , json:PROPERTY_HS_USER_IDS_OF_ALL_OWNERS::text(500)            as property_hs_user_ids_of_all_owners
  , json:PROPERTY_HS_TIME_IN_LEAD::text(500)                      as property_hs_time_in_lead
  , json:PROPERTY_TOTAL_MONEY_RAISED::text(500)                   as property_total_money_raised
  , json:PROPERTY_CITY::text(500)                                 as property_city
  , json:PROPERTY_DOMAIN::text(500)                               as property_domain
  , json:PROPERTY_INDUSTRY::text(500)                             as property_industry
  , json:PROPERTY_ZIP::text(500)                                  as property_zip
  , json:PROPERTY_WEBSITE::text(500)                              as property_website
  , json:PROPERTY_FACEBOOK_COMPANY_PAGE::text(500)                as property_facebook_company_page
  , json:PROPERTY_STATE::text(500)                                as property_state
  , json:PROPERTY_LIFECYCLESTAGE::text(500)                       as property_lifecyclestage
  , json:PROPERTY_NAME::text(500)                                 as property_name
  , json:PROPERTY_LINKEDINBIO::text(500)                          as property_linkedinbio
  , json:PROPERTY_ADDRESS::text(500)                              as property_address
  , json:PROPERTY_LINKEDIN_COMPANY_PAGE::text(500)                as property_linkedin_company_page
  , json:PROPERTY_COUNTRY::text(500)                              as property_country
  , json:PROPERTY_TIMEZONE::text(500)                             as property_timezone
  , json:PROPERTY_TWITTERHANDLE::text(500)                        as property_twitterhandle
  , json:PROPERTY_ANNUALREVENUE::text(500)                        as property_annualrevenue
  , json:PROPERTY_NUMBEROFEMPLOYEES::text(500)                    as property_numberofemployees
  , json:PROPERTY_PHONE::text(500)                                as property_phone
  , json:PROPERTY_NUM_NOTES::text(500)                            as property_num_notes
  , json:PROPERTY_NUM_CONVERSION_EVENTS::text(500)                as property_num_conversion_events
  , json:PROPERTY_NOTES_LAST_CONTACTED::text(500)                 as property_notes_last_contacted
  , json:PROPERTY_NOTES_LAST_UPDATED::text(500)                   as property_notes_last_updated
  , json:PROPERTY_NUM_CONTACTED_NOTES::text(500)                  as property_num_contacted_notes
  , json:PROPERTY_ADDRESS_2::text(500)                            as property_address_2
  , json:PROPERTY_RECENT_DEAL_AMOUNT::text(500)                   as property_recent_deal_amount
  , json:PROPERTY_TOTAL_REVENUE::text(500)                        as property_total_revenue
  , json:PROPERTY_RECENT_DEAL_CLOSE_DATE::text(500)               as property_recent_deal_close_date
  , json:PROPERTY_NOTES_NEXT_ACTIVITY_DATE::text(500)             as property_notes_next_activity_date
  , json:PROPERTY_HS_SALES_EMAIL_LAST_REPLIED::text(500)          as property_hs_sales_email_last_replied
  , json:PROPERTY_HUBSPOT_TEAM_ID::text(500)                      as property_hubspot_team_id
  , json:PROPERTY_HS_ALL_ACCESSIBLE_TEAM_IDS::text(500)           as property_hs_all_accessible_team_ids
  , json:PROPERTY_HS_ALL_TEAM_IDS::text(500)                      as property_hs_all_team_ids
  , json:PROPERTY_HUBSPOT_OWNER_ID::text(500)                     as property_hubspot_owner_id
  , json:PROPERTY_HS_ALL_OWNER_IDS::text(500)                     as property_hs_all_owner_ids
  , json:PROPERTY_DESCRIPTION::text(500)                          as property_description
  , json:PROPERTY_CREATEDATE::text(500)                           as property_createdate
  , json:PROPERTY_FIRST_CONTACT_CREATEDATE::text(500)             as property_first_contact_createdate
  , json:PROPERTY_WEB_TECHNOLOGIES::text(500)                     as property_web_technologies
  , json:PROPERTY_CLOSEDATE::text(500)                            as property_closedate
  , json:PROPERTY_DAYS_TO_CLOSE::text(500)                        as property_days_to_close
  , json:PROPERTY_HS_NUM_CHILD_COMPANIES::text(500)               as property_hs_num_child_companies
  , json:_FIVETRAN_DELETED::text(500)                             as _fivetran_deleted
  , try_to_timestamp(json:PROPERTY_HS_LATEST_MEETING_ACTIVITY::text) as PROPERTY_HS_LATEST_MEETING_ACTIVITY
  , try_to_timestamp(json:PROPERTY_HS_LAST_BOOKED_MEETING_DATE::text) as PROPERTY_HS_LAST_BOOKED_MEETING_DATE
  , try_to_timestamp(json:PROPERTY_HS_DATE_EXITED_LEAD::text)     as PROPERTY_HS_DATE_EXITED_LEAD
  , json:PROPERTY_HS_UPDATED_BY_USER_ID::FLOAT                    as PROPERTY_HS_UPDATED_BY_USER_ID
  , json:PROPERTY_HS_CREATED_BY_USER_ID::FLOAT                    as PROPERTY_HS_CREATED_BY_USER_ID
  , json:PROPERTY_AUM::FLOAT                                      as PROPERTY_AUM
  , json:PROPERTY_NUMBER_OF_CLIENTS::FLOAT                        as PROPERTY_NUMBER_OF_CLIENTS
  , json:PROPERTY_HS_ANNUAL_REVENUE_CURRENCY_CODE::text(256)      as PROPERTY_HS_ANNUAL_REVENUE_CURRENCY_CODE

  , a.effective_at::timestamp                                     as effective_at
  , a._created_at::timestamp                                      as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'company'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end as is_latest
from {{ source('hubspot_network', 'company') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'company') }}
  group by 1,2
) b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at