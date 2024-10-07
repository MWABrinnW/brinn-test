select
    json:ACCOUNTCLASSIFICATIONCODE::varchar(200)             as account_classification_code
    , json:ACCOUNTID::varchar(200)                           as account_id
    , json:ACCOUNTRATINGCODE::varchar(200)                   as account_rating_code
    , json:ADDRESS_1_ADDRESSID::varchar(200)                 as address_1_address_id
    , json:ADDRESS_1_ADDRESSTYPECODE::integer                as address_1_address_type_code
    , json:ADDRESS_1_CITY::varchar(100)                      as address_1_city
    , json:ADDRESS_1_COMPOSITE::varchar(200)                 as address_1_composite
    , json:ADDRESS_1_COUNTRY::varchar(100)                   as address_1_country
    , json:ADDRESS_1_LINE_1::varchar(100)                    as address_1_line_1
    , json:ADDRESS_1_LINE_2::varchar(100)                    as address_1_line_2
    , json:ADDRESS_1_LINE_3::varchar(100)                    as address_1_line_3
    , json:ADDRESS_1_NAME::varchar(100)                      as address_1_name
    , json:ADDRESS_1_POSTALCODE::varchar(20)                 as address_1_postal_code
    , json:ADDRESS_1_STATEORPROVINCE::varchar(100)           as address_1_state_or_province
    , json:ADDRESS_2_ADDRESSID::varchar(200)                 as address_2_address_id
    , json:ADDRESS_2_FREIGHTTERMSCODE::varchar(200)          as address_2_freight_terms_code
    , json:ADDRESS_2_SHIPPINGMETHODCODE::varchar(200)        as address_2_shipping_method_code
    , json:BUSINESSTYPECODE::varchar(200)                    as business_type_code
    , json:CREATEDON::timestamp_ntz                          as created_at
    , json:CREDITONHOLD::boolean                             as credit_on_hold
    , json:CUSTOMERSIZECODE::varchar(200)                    as customer_size_code
    , json:DONOTBULKEMAIL::boolean                           as do_not_bulk_email
    , json:DONOTBULKPOSTALMAIL::boolean                      as do_not_bulk_postal_mail
    , json:DONOTEMAIL::boolean                               as do_not_email
    , json:DONOTFAX::boolean                                 as do_not_fax
    , json:DONOTPHONE::boolean                               as do_not_phone
    , json:DONOTPOSTALMAIL::boolean                          as do_not_postal_mail
    , json:DONOTSENDMM::boolean                              as do_not_send_mm
    , effective_at::timestamp_ntz                            as effective_at
    , json:EXCHANGERATE::decimal(20 , 4)                     as exchange_rate
    , json:FOLLOWEMAIL::boolean                              as follow_email
    , json:IMPORTSEQUENCENUMBER::integer                     as import_sequence_number
    , json:MARKETINGONLY::boolean                            as marketing_only
    , json:MERGED::boolean                                   as merged
    , json:MODIFIEDON::timestamp_ntz                         as modified_at
    , json:MSDYN_GDPROPTOUT::boolean                         as msdyn_gdprop_to_out
    , json:NAME::varchar(200)                                as name
    , json:OPENDEALS::decimal(20 , 2)                        as open_deals
    , json:OPENDEALS_DATE::date                              as open_deals_date
    , json:OPENDEALS_STATE::varchar(200)                     as open_deals_state
    , json:OPENREVENUE::decimal(20 , 2)                      as open_revenue
    , json:OPENREVENUE_BASE::decimal(20 , 2)                 as open_revenue_base
    , json:OPENREVENUE_DATE::date                            as open_revenue_date
    , json:OPENREVENUE_STATE::varchar(200)                   as open_revenue_state
    , json:PATENT::boolean                                   as participates_in_workflow
    , json:PREFERREDCONTACTMETHODCODE::integer               as preferred_contact_method_code
    , json:PROCESSID::varchar(200)                           as process_id
    , json:SHIPPINGMETHODCODE::varchar(200)                  as shipping_method_code
    , json:STATECODE::integer                                as state_code
    , json:STATUSCODE::integer                               as status_code
    , json:TAMC_PAYOUTFIXEDRATE::decimal(20 , 2)             as tamc_payout_fixed_rate
    , json:TAMC_PAYOUTTIERED::varchar(200)                   as tamc_payout_tiered
    , json:TAMC_PAYOUTTIER_1_RATE::decimal(20 , 2)           as tamc_payout_tier_1_rate
    , json:TAMC_PAYOUTTIER_1_THRESHOLD::decimal(20 , 2)      as tamc_payout_tier_1_threshold
    , json:TAMC_PAYOUTTIER_1_THRESHOLD_BASE::decimal(20 , 2) as tamc_payout_tier_1_threshold_base
    , json:TAMC_PAYOUTTIER_2_RATE::decimal(20 , 2)           as tamc_payout_tier_2_rate
    , json:TAMC_PAYOUTTIER_2_THRESHOLD::decimal(20 , 2)      as tamc_payout_tier_2_threshold
    , json:TAMC_PAYOUTTIER_2_THRESHOLD_BASE::decimal(20 , 2) as tamc_payout_tier_2_threshold_base
    , json:TAMC_PAYOUTTIER_3_RATE::decimal(20 , 2)           as tamc_payout_tier_3_rate
    , json:TAMC_PAYOUTTIER_3_THRESHOLD::decimal(20 , 2)      as tamc_payout_tier_3_threshold
    , json:TAMC_PAYOUTTIER_3_THRESHOLD_BASE::decimal(20 , 2) as tamc_payout_tier_3_threshold_base
    , json:TAMC_PAYOUTTIER_4_RATE::decimal(20 , 2)           as tamc_payout_tier_4_rate
    , json:TAMC_PAYOUTTIER_4_THRESHOLD::decimal(20 , 2)      as tamc_payout_tier_4_threshold
    , json:TAMC_PAYOUTTIER_4_THRESHOLD_BASE::decimal(20 , 2) as tamc_payout_tier_4_threshold_base
    , json:TAMC_PAYOUTTIER_5_RATE::decimal(20 , 2)           as tamc_payout_tier_5_rate
    , json:TAMC_SOLICITORDISCLOSUREONFILE_2::boolean         as tamc_solicitor_disclosure_on_file_2
    , json:TAMC_SPLITSREQUIRED::varchar(200)                 as tamc_splits_required
    , json:TAMC_SPLIT_1::varchar(200)                        as tamc_split_1
    , json:TAMC_SPLIT_2::varchar(200)                        as tamc_split_2
    , json:TAMC_SPLIT_3::varchar(200)                        as tamc_split_3
    , json:TAM_ACCOUNTGUID::varchar(200)                     as tam_account_guid
    , json:TAM_ADDRESSUPDATEDFROMPLUGIN::varchar(200)        as tam_address_updated_from_plugin
    , json:TAM_ADDRESS_1::varchar(100)                       as tam_address_1
    , json:TAM_AGREEMENTDATE::date                           as tam_agreement_date
    , json:TAM_ALERT::varchar(200)                           as tam_alert
    , json:TAM_ASSETS::decimal(20 , 2)                       as tam_assets
    , json:TAM_ASSETS_BASE::decimal(20 , 2)                  as tam_assets_base
    , json:TAM_CLIENTSINCE::date                             as tam_clients_since_date
    , json:TAM_COI::decimal(20 , 2)                          as tam_coi
    , json:TAM_CREATEINAVREQUEST::boolean                    as tam_create_in_av_request
    , json:TAM_CURRENTMAILINGADDRESS::varchar(200)           as tam_current_mailing_address
    , json:TAM_DOCUMENTLINK::varchar(200)                    as tam_document_link
    , json:TAM_GENERATION::integer                           as tam_generation
    , json:TAM_HOLIDAYCARDS::boolean                         as tam_holiday_cards
    , json:TAM_HOLIDAYGIFT::boolean                          as tam_holiday_gift
    , json:TAM_LASTADVSENT::date                             as tam_last_adv_sent_date
    , json:TAM_LASTAPPOINTMENT::date                         as tam_last_appointment_date
    , json:TAM_LASTCALL::date                                as tam_last_call_date
    , json:TAM_LASTCONTACTED::date                           as tam_last_contacted_date
    , json:TAM_LASTPRIVACYNOTICESENT::date                   as tam_last_privacy_notice_sent_date
    , json:TAM_LASTREVIEWREQUEST::date                       as tam_last_review_request_date
    , json:TAM_LIABILITIES::decimal(20 , 2)                  as tam_liabilities
    , json:TAM_LIABILITIES_BASE::decimal(20 , 2)             as tam_liabilities_base
    , json:TAM_LINKEDTOADVISORVIEW::boolean                  as tam_linked_to_advisor_view
    , json:TAM_MAILING_ADDRESS_OPTION::integer               as tam_mailing_address_option
    , json:TAM_MGMTFEE::decimal(20 , 2)                      as tam_mgmt_fee
    , json:TAM_MGMTFEE_BASE::decimal(20 , 2)                 as tam_mgmt_fee_base
    , json:TAM_MOBILEPHONE::varchar(15)                      as tam_mobile_phone
    , json:TAM_NETWORTH::decimal(20 , 2)                     as tam_net_worth
    , json:TAM_NETWORTH_BASE::decimal(20 , 2)                as tam_net_worth_base
    , json:TAM_NEWSLETTERS::boolean                          as tam_newsletters
    , json:TAM_PHYSICAL_ADDRESS_OPTION::integer              as tam_physical_address_option
    , json:TAM_POTENTIALAUM::decimal(20 , 2)                 as tam_potential_aum
    , json:TAM_POTENTIALAUM_BASE::decimal(20 , 2)            as tam_potential_aum_base
    , json:TAM_PREFERREDPHONE::varchar(15)                   as tam_preferred_phone
    , json:TAM_PRIMARYCONTACTISBENEFICIARY::boolean          as tam_primary_contact_is_beneficiary
    , json:TAM_REVENUE::decimal(20 , 2)                      as tam_revenue
    , json:TAM_REVENUE_BASE::decimal(20 , 2)                 as tam_revenue_base
    , json:TAM_SALUTATION::varchar(200)                      as tam_salutation
    , json:TAM_SECONDARYCONTACTISBENEFICIARY::boolean        as tam_secondary_contact_is_beneficiary
    , json:TAM_SECONDARYFIRSTNAME::varchar(200)              as tam_secondary_first_name
    , json:TAM_SECONDARYLASTNAME::varchar(200)               as tam_secondary_last_name
    , json:TAM_STATEOFPRIMARYRESIDENCE::varchar(100)         as tam_state_of_primary_residence
    , json:TAM_SYNCFAMILYROLLUP::boolean                     as tam_sync_family_rollup
    , json:TAM_TERMINATEDDATE::date                          as tam_terminated_date
    , json:TAM_TOTALCUSTODIANVALUE::decimal(20 , 2)          as tam_total_custodian_value
    , json:TAM_TOTALCUSTODIANVALUE_BASE::decimal(20 , 2)     as tam_total_custodian_value_base
    , json:TAM_TOTALREBALVALUE::decimal(20 , 2)              as tam_total_rebal_value
    , json:TAM_TOTALREBALVALUE_BASE::decimal(20 , 2)         as tam_total_rebal_value_base
    , json:TAM_TOTALVALUE::decimal(20 , 2)                   as tam_total_value
    , json:TAM_TOTALVALUE_BASE::decimal(20 , 2)              as tam_total_value_base
    , json:TAM_UNMANAGEDVALUE::decimal(20 , 2)               as tam_unmanaged_value
    , json:TAM_UNMANAGEDVALUE_BASE::decimal(20 , 2)          as tam_unmanaged_value_base
    , json:TAM_UPDATEDBYTAMARACINTEGRATION::boolean          as tam_updated_by_tamarac_integration
    , json:TAM_UPLOADID::varchar(200)                        as tam_upload_id
    , json:TELEPHONE_1::varchar(15)                          as telephone_1
    , json:TELEPHONE_2::varchar(15)                          as telephone_2
    , json:TELEPHONE_3::varchar(15)                          as telephone_3
    , json:TERRITORYCODE::varchar(200)                       as territory_code
    , json:TIMEZONERULEVERSIONNUMBER::varchar(200)           as time_zone_rule_version_number
    , json:VERSIONNUMBER::integer                            as version_number
    , json:_CREATEDBY_VALUE::varchar(200)                    as _created_by_value
    , json:_FIVETRAN_DELETED::integer                        as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz                   as _fivetran_synced
    , json:_MASTERID_VALUE::varchar(200)                     as _master_id_value
    , json:_MODIFIEDBY_VALUE::varchar(200)                   as _modified_by_value
    , json:_MODIFIEDONBEHALFBY_VALUE::varchar(200)           as _modified_on_behalf_by_value
    , json:_ORIGINATINGLEADID_VALUE::varchar(200)            as _originating_lead_id_value
    , json:_OWNERID_VALUE::varchar(200)                      as _owner_id_value
    , json:_OWNINGBUSINESSUNIT_VALUE::varchar(200)           as _owning_business_unit_value
    , json:_OWNINGUSER_VALUE::varchar(200)                   as _owning_user_value
    , json:_PRIMARYCONTACTID_VALUE::varchar(200)             as _primary_contact_id_value
    , json:_TAMC_BDM_VALUE::varchar(200)                     as _bdm_value
    , json:_TAM_ACCOUNTTYPEID_VALUE::varchar(200)            as _account_type_id_value
    , json:_TAM_ADDRESS_1_ID_VALUE::varchar(200)             as _address_1_id_value
    , json:_TAM_CLIENTCLASSIFICATIONID_VALUE::varchar(200)   as _client_classification_id_value
    , json:_TAM_CURRENTMAILINGADDRESSID_VALUE::varchar(200)  as _current_mailing_address_id_value
    , json:_TAM_FAMILYID_VALUE::varchar(200)                 as _family_id_value
    , json:_TAM_REFERREDBYID_VALUE::varchar(200)             as _referred_by_id_value
    , json:_TAM_REGIONID_VALUE::varchar(200)                 as _region_id_value
    , json:_TAM_REGION_VALUE::varchar(200)                   as _region_value
    , json:_TAM_SECONDARYCONTACTID_VALUE::varchar(200)       as _secondary_contact_id_value
    , _created_at::timestamp_ntz                             as _created_at
    , json:_TRANSACTIONCURRENCYID_VALUE::varchar(200)        as _transaction_currency_id_value
    , {{ col_is_head(reference = source('dynamics_tamarac_cpg', 'account'), 
            reference_date_col = 'effective_at::date', 
            source_date_col = 'effective_at::date') }}
    , case when
            dense_rank() over (partition by effective_at::date order by date_trunc('second' , _created_at) desc) = 1
            then 1
        else 0
    end::int                                                 as is_head_for_day
from
    {{ source('dynamics_tamarac_cpg', 'account') }}
