{% set src = source('salesforce_adviceperiod', 'upsell_opportunities_c') %}

select
    json:"ADVISORY_ESTIMATED_FEE_C"::int                        as advisory_estimated_fee_c
    , json:"ADVISOR_C"::text                                    as advisor_c
    , try_to_boolean(
        json:"ADVISOR_PROVIDES_CONTRACT_INFO_C"::text
    )::int                                                      as advisor_provides_contract_info_c
    , try_to_boolean(json:"ALERT_OPS_C"::text)::int             as alert_ops_c
    , try_to_boolean(json:"ALERT_REPORTING_C"::text)::int       as alert_reporting_c
    , json:"ANALYST_C"::text                                    as analyst_c
    , json:"ASSESSMENT_DATE_C"::date                            as assessment_date_c
    , json:"ASSET_TYPES_C"::text                                as asset_types_c
    , json:"BOX_LINK_C"::text                                   as box_link_c
    , json:"CFO_FEE_C"::int                                     as cfo_fee_c
    , try_to_boolean(
        json:"CLIENT_WANT_TO_MOVE_FORWARD_C"::text
    )::int                                                      as client_want_to_move_forward_c
    , json:"CONTRACT_DATE_C"::date                              as contract_date_c
    , try_to_boolean(
        json:"CONTRACT_GENERATED_SENT_C"::text
    )::int                                                      as contract_generated_sent_c
    , try_to_boolean(json:"CONTRACT_SAVED_BOX_C"::text)::int    as contract_saved_box_c
    , json:"CONTRACT_SIGN_DATE_C"::date                         as contract_sign_date_c
    , json:"CREATED_BY_ID"::text                                as created_by_id
    , json:"CREATED_DATE"::text                                 as created_date
    , try_to_boolean(
        json:"CREATE_PLAN_PUT_TOGETHER_PROPOSAL_C"::text
    )::int                                                      as create_plan_put_together_proposal_c
    , json:"CRM_C"::text                                        as crmc
    , json:"CSA_C"::text                                        as csac
    , try_to_boolean(
        json:"CURRENT_CLIENT_WITH_OPPORTUNITY_C"::text
    )::int                                                      as current_client_with_opportunity_c
    , json:"DATE_TO_CLOSE_C"::date                              as date_to_close_c
    , json:"DETAILS_C"::text                                    as details_c
    , json:"EMAIL_C"::text                                      as email_c
    , json:"ESTATE_ADVISOR_C"::text                             as estate_advisor_c
    , json:"ID"::text                                           as id
    , try_to_boolean(json:"INFORMATION_CONFIRMED_C"::text)::int as information_confirmed_c
    , try_to_boolean(json:"IS_DELETED"::text)::int              as is_deleted
    , try_to_boolean(json:"KICKOFF_MEETING_C"::text)::int       as kickoff_meeting_c
    , json:"LAST_MODIFIED_BY_ID"::text                          as last_modified_by_id
    , json:"LAST_MODIFIED_DATE"::text                           as last_modified_date
    , json:"LAST_REFERENCED_DATE"::text                         as last_referenced_date
    , json:"LAST_VIEWED_DATE"::text                             as last_viewed_date
    , json:"LEGAL_NAME_C"::text                                 as legal_name_c
    , try_to_boolean(
        json:"LIFE_INSURANCE_TRUST_C"::text
    )::int                                                      as life_insurance_trust_c
    , json:"LOST_PROSPECT_DATE_C"::date                         as lost_prospect_date_c
    , json:"LOST_PROSPECT_REASON_C"::text                       as lost_prospect_reason_c
    , try_to_boolean(
        json:"MADE_GIFTS_OVER_THE_ANNUAL_EXCLUSION_AMO_C"::text
    )::int                                                      as made_gifts_over_the_annual_exclusion_amo_c
    , json:"MARINER_TIER_C"::text                               as mariner_tier_c
    , json:"MWA_TEAM_LOCATION_C"::text                          as mw_a_team_location_c
    , json:"NAME"::text                                         as name
    , try_to_boolean(
        json:"NEW_CLIENT_OPPORTUNITY_C"::text
    )::int                                                      as new_client_opportunity_c
    , json:"NEXT_STEP_C"::text                                  as next_step_c
    , json:"NEXT_STEP_DATE_C"::date                             as next_step_date_c
    , json:"NOTES_C"::text                                      as notes_c
    , json:"OWNER_ID"::text                                     as owner_id
    , json:"PARKING_LOT_C"::date                                as parking_lot_c
    , try_to_boolean(json:"PENDING_BUSINESS_SALE_C"::text)::int as pending_business_sale_c
    , json:"PHONE_C"::text                                      as phone_c
    , json:"PROSPECT_DATE_C"::date                              as prospect_date_c
    , json:"PROSPECT_NAME_C"::text                              as prospect_name_c
    , try_to_boolean(
        json:"PROSPECT_PROVIDES_VERBAL_AGREEMENT_C"::text
    )::int                                                      as prospect_provides_verbal_agreement_c
    , try_to_boolean(json:"QUALIFIED_C"::text)::int             as qualified_c
    , json:"RECORD_TYPE_ID"::text                               as record_type_id
    , json:"REFERRAL_CHANNEL_C"::text                           as referral_channel_c
    , json:"REFFERED_BY_C"::text                                as reffered_by_c
    , json:"RELATIONSHIP_C"::text                               as relationship_c
    , try_to_boolean(
        json:"SENT_PROPOSAL_MET_WITH_CLIENT_C"::text
    )::int                                                      as sent_proposal_met_with_client_c
    , json:"SERVICES_C"::text                                   as services_c
    , json:"SHARE_WITH_C"::text                                 as share_with_c
    , json:"SOURCED_C"::text                                    as source_dc
    , json:"SPOKE_TO_CLIENT_C"::text                            as spoke_to_client_c
    , json:"STAGE_C"::text                                      as stage_c
    , json:"SUSPECT_DATE_C"::date                               as suspect_date_c
    , json:"SYSTEM_MODSTAMP"::text                              as system_mod_stamp
    , json:"SYSTEM_PLACE_HOLDER_DATE_C"::date                   as system_placeholder_date_c
    , json:"SYS_REPORTING_CREATED_DATE_C"::date                 as sys_reporting_created_date_c
    , try_to_boolean(
        json:"TEAM_SENT_OUT_DOCUMENT_REQUEST_C"::text
    )::int                                                      as team_sent_out_document_request_c
    , json:"TOTAL_FEE_C"::int                                   as total_fee_c
    , json:"TOTAL_INVESTABLE_ASSETS_C"::int                     as total_investable_assets_c
    , json:"TOTAL_NET_WORTH_C"::int                             as total_net_worth_c
    , json:"TYPE_C"::text                                       as type_c
    , json:"VALUE_C"::int                                       as value_c
    , json:"VERBAL_DATE_C"::date                                as verbal_date_c
    , json:"WM_C"::text                                         as wmc
    , json:"WON_DATE_C"::date                                   as won_date_c
    , try_to_boolean(
        json:"_FIVETRAN_DELETED"::text
    )::int                                                      as fivetran_deleted
    , json:"_FIVETRAN_SYNCED"::text                             as fivetran_synced

    , effective_at::timestamp                                   as effective_at
    , _created_at::timestamp                                    as _created_at
    , {{ col_is_head(reference=src, source_date_col='effective_at', reference_date_col='effective_at') }}
    , case when row_number()
                over (
                    partition by effective_at
                    order by _created_at desc
                )
            = 1 then 1
        else 0
    end                                                         as is_latest
from {{ src }}
