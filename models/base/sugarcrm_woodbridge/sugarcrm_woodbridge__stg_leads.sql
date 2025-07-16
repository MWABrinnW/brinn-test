{% set src = source('sugarcrm_woodbridge', 'lead') %}

select
    json:"ACCOUNT_DESCRIPTION"::text                          as account_description
    , json:"ACCOUNT_ID"::text                                 as account_id
    , json:"ACCOUNT_TO_LEAD"::text                            as account_to_lead
    , json:"AI_CONV_BIN_ACCURACY"::int                        as ai_conv_bin_accuracy
    , json:"AI_CONV_MULTIPLIER"::int                          as ai_conv_multiplier
    , json:"AI_CONV_SCORE_ABSOLUTE"::float                    as ai_conv_score_absolute
    , json:"AI_CONV_SCORE_CLASSIFICATION"::text               as ai_conv_score_classification
    , json:"ALT_ADDRESS_CITY"::text                           as alt_address_city
    , json:"ALT_ADDRESS_COUNTRY"::text                        as alt_address_country
    , json:"ALT_ADDRESS_POSTALCODE"::int                      as alt_address_postal_code
    , json:"ALT_ADDRESS_STATE"::text                          as alt_address_state
    , json:"ALT_ADDRESS_STREET"::text                         as alt_address_street
    , json:"ASSIGNED_USER_ID"::text                           as assigned_userid
    , json:"ASSIGNED_USER_NAME"::text                         as assigned_username
    , json:"CONTACT_ID"::text                                 as contact_id
    , try_to_boolean(json:"CONVERTED"::text)::int             as converted
    , json:"CONVERTED_OPP_NAME"::text                         as converted_opp_name
    , json:"CREATED_BY_ID"::text                              as created_by_id
    , json:"CREATED_BY_NAME"::text                            as created_by_name
    , json:"CUSTOM_ACCOUNT_NAME"::text                        as custom_account_name
    , json:"CUSTOM_ACCOUNT_TYPE_C"::text                      as custom_account_type_c
    , json:"CUSTOM_ANNUALREVENUE_C"::int                      as custom_annual_revenue_c
    , json:"CUSTOM_BASE_RATE"::int                            as custom_base_rate
    , json:"CUSTOM_BD_EMAIL_LAST_SENT_C"::date                as custom_bd_email_last_sent_c
    , json:"CUSTOM_CALLRAILANSWEREDCALL_C"::text              as custom_call_rail_answered_call_c
    , json:"CUSTOM_CALLRAILDEVICETYPE_C"::text                as custom_call_rail_device_type_c
    , json:"CUSTOM_CALLRAILDURATION_C"::int                   as custom_call_rail_duration_c
    , json:"CUSTOM_CALLRAILGCLID_C"::text                     as custom_call_rail_gcl_id_c
    , json:"CUSTOM_CALLRAILGOOGLECAMPAIGN_C"::text            as custom_call_rail_google_campaign_c
    , json:"CUSTOM_CALLRAILKEYWORDS_C"::text                  as custom_call_rail_keywords_c
    , json:"CUSTOM_CALLRAILREFERRINGURL_C"::text              as custom_call_rail_referring_url_c
    , json:"CUSTOM_CALLRAILSOURCENUMBER_C"::text              as custom_call_rail_source_number_c
    , json:"CUSTOM_CALLRAILTAG_C"::text                       as custom_call_rail_tag_c
    , json:"CUSTOM_CONTACT_ID_C"::text                        as custom_contact_id_c
    , json:"CUSTOM_CONTACT_NAME"::text                        as custom_contact_name
    , json:"CUSTOM_CONVERTEDDATE_C"::date                     as custom_converted_date_c
    , json:"CUSTOM_CO_TYPE_C"::text                           as custom_co_type_c
    , json:"CUSTOM_CURRENCY_ID"::text                         as custom_currency_id
    , json:"CUSTOM_DATE_LEAD_REFERRED_TO_MWA_C"::date         as custom_date_lead_referred_to_mwa_c
    , json:"CUSTOM_DATE_LEAD_STATUS_CHANGED_C"::date          as custom_date_lead_status_changed_c
    , try_to_boolean(json:"CUSTOM_DO_NOT_EMAIL_C"::text)::int as custom_do_not_email_c
    , json:"CUSTOM_EBITDA_C"::int                             as custom_ebitda_c
    , json:"CUSTOM_EBITDA_LOCAL_CURRENCY_C"::int              as custom_ebitda_local_currency_c
    , json:"CUSTOM_EMAILBOUNCEDDATE_C"::text                  as custom_email_bounced_date_c
    , json:"CUSTOM_EMAILBOUNCEDREASON_C"::text                as custom_email_bounced_reason_c
    , json:"CUSTOM_EMAILED_BY_BD_C"::text                     as custom_emailed_by_bd_c
    , json:"CUSTOM_EOS_STATUS_C"::text                        as custom_eos_status_c
    , try_to_boolean(json:"CUSTOM_FINS_REC_D_C"::text)::int   as custom_fins_rec_d_c
    , try_to_boolean(json:"CUSTOM_FINS_REQ_C"::text)::int     as custom_fins_req_c
    , try_to_boolean(
        json:"CUSTOM_FIRST_THURSDAY_C"::text
    )::int                                                    as custom_first_thursday_c
    , json:"CUSTOM_FORM_ANNUAL_REVENUE_C"::text               as custom_form_annual_revenue_c
    , json:"CUSTOM_FORM_ENTRY_ID_C"::int                      as custom_form_entry_id_c
    , json:"CUSTOM_FORM_LOCALE_C"::text                       as custom_form_locale_c
    , json:"CUSTOM_FORM_REVENUE_RANGE_C"::text                as custom_form_revenue_range_c
    , json:"CUSTOM_FORM_SOURCE_URL_C"::text                   as custom_form_source_url_c
    , json:"CUSTOM_FORM_USER_IP_C"::text                      as custom_form_user_ip_c
    , try_to_boolean(
        json:"CUSTOM_HASOPTEDOUTOFEMAIL_C"::text
    )::int                                                    as custom_has_opted_out_of_email_c
    , json:"CUSTOM_HINT_ACCOUNT_FACEBOOK_HANDLE"::text        as custom_hint_account_facebook_handle
    , json:"CUSTOM_HINT_ACCOUNT_FOUNDED_YEAR"::int            as custom_hint_account_founded_year
    , json:"CUSTOM_HINT_ACCOUNT_INDUSTRY"::text               as custom_hint_account_industry
    , json:"CUSTOM_HINT_ACCOUNT_LOCATION"::text               as custom_hint_account_location
    , json:"CUSTOM_HINT_ACCOUNT_NAICS_CODE_LBL"::text         as custom_hint_account_naics_code_lbl
    , json:"CUSTOM_HINT_ACCOUNT_SIZE"::int                    as custom_hint_account_size
    , json:"CUSTOM_HINT_INDUSTRY_TAGS"::text                  as custom_hint_industry_tags
    , json:"CUSTOM_INDUSTRY_C"::text                          as custom_industry_c
    , try_to_boolean(
        json:"CUSTOM_ISUNREADBYOWNER_C"::text
    )::int                                                    as custom_is_unread_by_owner_c
    , json:"CUSTOM_LEADS_BD_TARGET_1_BD_TARGET_IDB"::text     as custom_leads_bd_target_1_bd_target_idb
    , json:"CUSTOM_LEADS_BD_TARGET_1_NAME"::text              as custom_leads_bd_target_1_name
    , json:"CUSTOM_LEAD_REFERRED_TO_MWA_C"::text              as custom_lead_referred_to_mwa_c
    , json:"CUSTOM_LINKEDIN_URL_C"::text                      as custom_linkedin_url_c
    , json:"CUSTOM_LINK_TO_CONTACT_C"::text                   as custom_link_to_contact_c
    , json:"CUSTOM_MARINER_CHANNEL_C"::text                   as custom_mariner_channel_c
    , json:"CUSTOM_MARINER_REFERRAL_STAGE_C"::text            as custom_mariner_referral_stage_c
    , json:"CUSTOM_MC_IMPORT_TAG_C"::text                     as custom_mc_import_tag_c
    , try_to_boolean(json:"CUSTOM_MY_FAVORITE"::text)::int    as custom_my_favorite
    , json:"CUSTOM_NEXT_STEP_DATE_LEAD_C"::date               as custom_next_step_date_lead_c
    , json:"CUSTOM_NUMBEROFEMPLOYEES_C"::int                  as custom_number_of_employees_c
    , json:"CUSTOM_OPPORTUNITY_NAME"::text                    as custom_opportunity_name
    , json:"CUSTOM_OWNERSHIP_C"::int                          as custom_ownership_c
    , json:"CUSTOM_QUALIFIED_AGE_C"::int                      as custom_qualified_age_c
    , json:"CUSTOM_QUALIFIED_DATE_1_C"::text                  as custom_qualified_date_1_c
    , json:"CUSTOM_RATING_C"::text                            as custom_rating_c
    , json:"CUSTOM_RELATED_ACCOUNT_C"::text                   as custom_related_account_c
    , json:"CUSTOM_REPORT_DATE_CREATED_C"::date               as custom_report_date_created_c
    , json:"CUSTOM_REVENUE_LOCAL_CURRENCY_C"::int             as custom_revenue_local_currency_c
    , json:"CUSTOM_SF_CREATED_AT_C"::text                     as custom_sf_created_at_c
    , json:"CUSTOM_SF_CREATED_BY_C"::text                     as custom_sf_created_by_c
    , json:"CUSTOM_SF_LAST_MODIFIED_AT_C"::text               as custom_sf_last_modified_at_c
    , json:"CUSTOM_SF_LAST_MODIFIED_BY_C"::text               as custom_sf_last_modified_by_c
    , json:"CUSTOM_SF_OBJECT_TYPE_C"::text                    as custom_sf_object_type_c
    , json:"CUSTOM_SIC_CODE_C"::text                          as custom_sic_code_c
    , json:"CUSTOM_SIC_DESCRIPTION_C"::text                   as custom_sic_description_c
    , json:"CUSTOM_STATE_FROM_AREA_CODE_C"::text              as custom_state_from_area_code_c
    , json:"CUSTOM_TIME_TO_QUALIFY_C"::int                    as custom_time_to_qualify_c
    , json:"CUSTOM_TIME_TO_SELL_C"::text                      as custom_time_to_sell_c
    , json:"CUSTOM_TTM_CHECK_C"::text                         as custom_ttm_check_c
    , json:"CUSTOM_USER_ID_C"::text                           as custom_userid_c
    , json:"CUSTOM_WEALTH_VALUATION_C"::variant               as custom_wealth_valuation_c
    , json:"DATE_ENTERED"::text                               as date_entered
    , json:"DATE_MODIFIED"::text                              as date_modified
    , try_to_boolean(json:"DELETED"::text)::int               as deleted
    , json:"DESCRIPTION"::text                                as description
    , try_to_boolean(json:"DO_NOT_CALL"::text)::int           as do_not_call
    , json:"DP_BUSINESS_PURPOSE"::variant                     as dp_business_purpose
    , json:"DP_CONSENT_LAST_UPDATED"::date                    as dp_consent_last_updated
    , try_to_boolean(json:"EMAIL_OPT_OUT"::text)::int         as email_opt_out
    , json:"FIRST_NAME"::text                                 as first_name
    , try_to_boolean(json:"FOLLOWING"::text)::int             as is_following
    , json:"FULL_NAME"::text                                  as full_name
    , json:"GEOCODE_STATUS"::text                             as geocode_status
    , json:"HINT_ACCOUNT_ANNUAL_REVENUE"::text                as hint_account_annual_revenue
    , json:"HINT_ACCOUNT_DESCRIPTION"::text                   as hint_account_description
    , json:"HINT_ACCOUNT_SIC_CODE_LABEL"::text                as hint_account_sic_code_label
    , json:"HINT_ACCOUNT_TWITTER_HANDLE"::text                as hint_account_twitter_handle
    , json:"HINT_ACCOUNT_WEBSITE"::text                       as hint_account_website
    , json:"HINT_CONTACT_PIC"::text                           as hint_contact_pic
    , json:"HINT_EDUCATION"::text                             as hint_education
    , json:"HINT_EDUCATION_2"::text                           as hint_education_2
    , json:"HINT_FACEBOOK"::text                              as hint_facebook
    , json:"HINT_JOB_2"::text                                 as hint_job_2
    , json:"HINT_PHONE_1"::text                               as hint_phone_1
    , json:"HINT_TWITTER"::text                               as hint_twitter
    , json:"ID"::text                                         as id
    , try_to_boolean(json:"INVALID_EMAIL"::text)::int         as invalid_email
    , json:"LAST_NAME"::text                                  as last_name
    , json:"LEAD_SOURCE"::text                                as lead_source
    , json:"LEAD_SOURCE_DESCRIPTION"::text                    as lead_source_description
    , json:"LOCKED_FIELDS"::variant                           as locked_fields
    , try_to_boolean(json:"MKTO_SYNC"::text)::int             as mk_to_sync
    , json:"MODIFIED_BY_NAME"::text                           as modified_by_name
    , json:"MODIFIED_USER_ID"::text                           as modified_userid
    , json:"NAME"::text                                       as name
    , json:"OPPORTUNITY_ID"::text                             as opportunity_id
    , try_to_boolean(
        json:"PERFORM_SUGAR_ACTION"::text
    )::int                                                    as perform_sugar_action
    , json:"PHONE_HOME"::text                                 as phone_home
    , json:"PHONE_MOBILE"::text                               as phone_mobile
    , json:"PHONE_OTHER"::text                                as phone_other
    , json:"PHONE_WORK"::text                                 as phone_work
    , json:"PREFERRED_LANGUAGE"::text                         as preferred_language
    , json:"PRIMARY_ADDRESS_CITY"::text                       as primary_address_city
    , json:"PRIMARY_ADDRESS_COUNTRY"::text                    as primary_address_country
    , json:"PRIMARY_ADDRESS_POSTALCODE"::text                 as primary_address_postal_code
    , json:"PRIMARY_ADDRESS_STATE"::text                      as primary_address_state
    , json:"PRIMARY_ADDRESS_STREET"::text                     as primary_address_street
    , json:"REFERED_BY"::text                                 as refered_by
    , json:"SALUTATION"::text                                 as salutation
    , json:"STATUS"::text                                     as status
    , json:"SYNC_KEY"::text                                   as sync_key
    , json:"TITLE"::text                                      as title
    , json:"WEBSITE"::text                                    as website
    , try_to_boolean(json:"_FIVETRAN_DELETED"::text)::int     as fivetran_deleted
    , json:"_FIVETRAN_SYNCED"::text                           as fivetran_synced
    , json:"_hash"::text                                      as hash
    , try_to_boolean(json:"cpd"::text)::int                   as cpd
    , json:"featureImportance"::variant                       as feature_importance
    , json:"fields"::variant                                  as fields
    , json:"importance"::float                                as importance
    , json:"type"::text                                       as type
    , json:"None"::text                                       as none_col

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(reference=src
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ src }}
