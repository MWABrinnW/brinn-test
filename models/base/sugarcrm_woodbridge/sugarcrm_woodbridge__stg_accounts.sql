{% set src = source('sugarcrm_woodbridge', 'account') %}

select
    json:"ANNUAL_REVENUE"::text                                  as annual_revenue
    , json:"ASSIGNED_USER_ID"::text                              as assigned_userid
    , json:"ASSIGNED_USER_NAME"::text                            as assigned_username
    , json:"BASE_RATE"::int                                      as base_rate
    , json:"BILLING_ADDRESS_CITY"::text                          as billing_address_city
    , json:"BILLING_ADDRESS_COUNTRY"::text                       as billing_address_country
    , json:"BILLING_ADDRESS_POSTALCODE"::text                    as billing_address_postal_code
    , json:"BILLING_ADDRESS_STATE"::text                         as billing_address_state
    , json:"BILLING_ADDRESS_STREET"::text                        as billing_address_street
    , json:"CREATED_BY_ID"::text                                 as created_by_id
    , json:"CREATED_BY_NAME"::text                               as created_by_name
    , json:"CURRENCY_ID"::text                                   as currency_id
    , try_to_boolean(json:"CUSTOM_ACCOUNT_NO_MAIL_C"::text)::int as custom_account_no_mail_c
    , json:"CUSTOM_ANNUALREVENUE_C"::int                         as custom_annual_revenue_c
    , try_to_boolean(json:"CUSTOM_COMPANY_SOLD_C"::text)::int    as custom_company_sold_c
    , try_to_boolean(
        json:"CUSTOM_CONFIRMED_REVENUE_C"::text
    )::int                                                       as custom_confirmed_revenue_c
    , json:"CUSTOM_DATE_REFERRED_C"::date                        as custom_date_referred_c
    , json:"CUSTOM_DATE_REFERRED_MWA_REPORTS_C"::date            as custom_date_referred_mwa_reports_c
    , json:"CUSTOM_EBITDA_C"::int                                as custom_ebitda_c
    , json:"CUSTOM_ESTIMATED_LIQUIDITY_C"::int                   as custom_estimated_liquidity_c
    , json:"CUSTOM_FINANCING_TYPE_C"::text                       as custom_financing_type_c
    , json:"CUSTOM_INDUSTRY_DESCRIPTION_C"::text                 as custom_industry_description_c
    , json:"CUSTOM_LASTACTIVITYDATE_C"::date                     as custom_last_activity_date_c
    , json:"CUSTOM_MC_IMPORT_TAG_C"::text                        as custom_mc_import_tag_c
    , json:"CUSTOM_MWA_ACCOUNT_REFERRAL_STAGE_C"::text           as custom_mwa_account_referral_stage_c
    , try_to_boolean(json:"CUSTOM_MY_FAVORITE"::text)::int       as custom_my_favorite
    , try_to_boolean(
        json:"CUSTOM_NDA_PRE_NEGOTIATED_C"::text
    )::int                                                       as custom_nda_pre_negotiated_c
    , json:"CUSTOM_NUMBEROFEMPLOYEES_C"::int                     as custom_number_of_employees_c
    , json:"CUSTOM_OWNERSHIP_C"::text                            as custom_ownership_c
    , json:"CUSTOM_OWNERSHIP_PERCENTAGE_C"::int                  as custom_ownership_percentage_c
    , json:"CUSTOM_PEG_FUNDING_C"::text                          as custom_peg_funding_c
    , try_to_boolean(
        json:"CUSTOM_PE_BACKED_STRATEGIC_C"::text
    )::int                                                       as custom_pe_backed_strategic_c
    , json:"CUSTOM_PE_BACKED_STRATEGIC_COMMENTS_C"::text         as custom_pe_backed_strategic_comments_c
    , json:"CUSTOM_PORTFOLIO_COS_C"::text                        as custom_portfolio_cos_c
    , json:"CUSTOM_POTENTIAL_LIQUIDITY_ACC_C"::int               as custom_potential_liquidity_acc_c
    , json:"CUSTOM_PUBLIC_COMPANY_C"::text                       as custom_public_company_c
    , json:"CUSTOM_REFERRED_BY_C"::text                          as custom_referred_by_c
    , json:"CUSTOM_REFERRED_TO_C"::variant                       as custom_referred_to_c
    , try_to_boolean(
        json:"CUSTOM_REFERRED_TO_MWA_C"::text
    )::int                                                       as custom_referred_to_mwa_c
    , json:"CUSTOM_REFERRED_TO_MWA_DROPDOWN_C"::text             as custom_referred_to_mwa_drop_down_c
    , json:"CUSTOM_SF_CREATED_AT_C"::text                        as custom_sf_created_at_c
    , json:"CUSTOM_SF_CREATED_BY_C"::text                        as custom_sf_created_by_c
    , json:"CUSTOM_SF_LAST_MODIFIED_AT_C"::text                  as custom_sf_last_modified_at_c
    , json:"CUSTOM_SF_LAST_MODIFIED_BY_C"::text                  as custom_sf_last_modified_by_c
    , json:"CUSTOM_SF_OBJECT_TYPE_C"::text                       as custom_sf_object_type_c
    , json:"CUSTOM_SICDESC_C"::text                              as custom_sicdesc_c
    , json:"CUSTOM_SITE_C"::text                                 as custom_site_c
    , json:"CUSTOM_SUB_INDUSTRY_C"::text                         as custom_sub_industry_c
    , try_to_boolean(
        json:"CUSTOM_ULTIMATE_BUYER_C"::text
    )::int                                                       as custom_ultimate_buyer_c
    , json:"CUSTOM_UPSERT_DEDUPLICATE_PROCESSED_DATE_C"::text    as custom_upsert_deduplicate_processed_date_c
    , try_to_boolean(json:"CUSTOM_WG_CLIENT_C"::text)::int       as custom_wg_client_c
    , json:"DATE_ENTERED"::text                                  as date_entered
    , json:"DATE_MODIFIED"::text                                 as date_modified
    , try_to_boolean(json:"DELETED"::text)::int                  as deleted
    , json:"DESCRIPTION"::text                                   as description
    , json:"EMAIL"::variant                                      as email
    , json:"EMAIL_1"::text                                       as email_1
    , try_to_boolean(json:"EMAIL_OPT_OUT"::text)::int            as email_opt_out
    , json:"EMPLOYEES"::int                                      as employees
    , try_to_boolean(json:"FOLLOWING"::text)::int                as is_following
    , json:"GEOCODE_STATUS"::text                                as geocode_status
    , json:"HINT_ACCOUNT_FACEBOOK_HANDLE"::text                  as hint_account_facebook_handle
    , json:"HINT_ACCOUNT_FISCAL_YEAR_END"::int                   as hint_account_fiscal_year_end
    , json:"HINT_ACCOUNT_FOUNDED_YEAR"::int                      as hint_account_founded_year
    , json:"HINT_ACCOUNT_INDUSTRY"::text                         as hint_account_industry
    , json:"HINT_ACCOUNT_INDUSTRY_TAGS"::text                    as hint_account_industry_tags
    , json:"HINT_ACCOUNT_LOCATION"::text                         as hint_account_location
    , json:"HINT_ACCOUNT_NAICS_CODE_LBL"::text                   as hint_account_naics_code_lbl
    , json:"HINT_ACCOUNT_PIC"::text                              as hint_account_pic
    , json:"HINT_ACCOUNT_SIZE"::text                             as hint_account_size
    , json:"ID"::text                                            as id
    , json:"INDUSTRY"::text                                      as industry
    , try_to_boolean(json:"INVALID_EMAIL"::text)::int            as is_invalid_email
    , try_to_boolean(json:"IS_ESCALATED"::text)::int             as is_escalated
    , json:"LOCKED_FIELDS"::variant                              as locked_fields
    , json:"MEMBER_OF_ID"::text                                  as member_of_id
    , json:"MEMBER_OF_NAME"::text                                as member_of_name
    , json:"MODIFIED_BY_NAME"::text                              as modified_by_name
    , json:"MODIFIED_USER_ID"::text                              as modified_userid
    , json:"NAME"::text                                          as name
    , json:"PARENT_ID"::text                                     as parentid
    , json:"PARENT_NAME"::text                                   as parent_name
    , try_to_boolean(json:"PERFORM_SUGAR_ACTION"::text)::int     as perform_sugar_action
    , json:"PHONE_ALTERNATE"::text                               as phone_alternate
    , json:"PHONE_FAX"::text                                     as phone_fax
    , json:"PHONE_OFFICE"::text                                  as phone_office
    , json:"RATING"::text                                        as rating
    , json:"SERVICE_LEVEL"::text                                 as service_level
    , json:"SHIPPING_ADDRESS_CITY"::text                         as shipping_address_city
    , json:"SHIPPING_ADDRESS_COUNTRY"::text                      as shipping_address_country
    , json:"SHIPPING_ADDRESS_POSTALCODE"::text                   as shipping_address_postal_code
    , json:"SHIPPING_ADDRESS_STATE"::text                        as shipping_address_state
    , json:"SHIPPING_ADDRESS_STREET"::text                       as shipping_address_street
    , json:"SIC_CODE"::text                                      as sic_code
    , json:"SYNC_KEY"::text                                      as sync_key
    , json:"TICKER_SYMBOL"::text                                 as ticker_symbol
    , json:"TWITTER"::text                                       as twitter
    , json:"TYPE"::text                                          as type
    , json:"WEBSITE"::text                                       as website
    , try_to_boolean(json:"_FIVETRAN_DELETED"::text)::int        as fivetran_deleted
    , json:"_FIVETRAN_SYNCED"::text                              as fivetran_synced
    , json:"email_address"::text                                 as email_address
    , json:"email_address_id"::text                              as email_address_id
    , try_to_boolean(json:"opt_out"::text)::int                  as opt_out
    , try_to_boolean(json:"primary_address"::text)::int          as primary_address
    , try_to_boolean(json:"reply_to_address"::text)::int         as reply_to_address
    , json:"None"::text                                          as none_col

    , effective_at::timestamp                                    as effective_at
    , _created_at::timestamp                                     as _created_at
    , {{ col_is_head(reference=src
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ src }}
