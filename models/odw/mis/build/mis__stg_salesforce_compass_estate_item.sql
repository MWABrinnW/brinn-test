select
    content:AUM_Classification__c::text                                      as aum_classification
    , content:AccountIDOrion__c::text                                        as account_id_orion
    , try_to_boolean(content:Billing_Exception__c::text)::int                as billing_exception
    , try_to_boolean(content:Block_on_Account__c::text)::int                 as block_on_account
    , content:Cash_Balance__c::number(20 , 5)                                as cash_balance
    , content:"Custodian__r.Id"::text                                        as custodian_id
    , content:"Custodian__r.Name"::text                                      as custodian_name
    , content:"Custodian__r.attributes.type"::text                           as custodian_attributes_type
    , content:"Custodian__r.attributes.url"::text                            as custodian_attributes_url
    , content:Distribution_Type__c::text                                     as distribution_type
    , try_to_boolean(content:Firm_Trading__c::text)::int                     as firm_trading
    , content:"Household__r.Client_Manager__r.Name"::text                    as household_client_manager_name
    , content:"Household__r.Client_Manager__r.attributes.type"::text         as household_client_manager_attributes_type
    , content:"Household__r.Client_Manager__r.attributes.url"::text          as household_client_manager_attributes_url
    , content:"Household__r.Id"::text                                        as household_id
    , content:"Household__r.Legal_Address_State__c"::text                    as household_legal_address_state
    , content:"Household__r.Legal_Firm__r.Name"::text                        as household_legal_firm_name
    , content:"Household__r.Legal_Firm__r.attributes.type"::text             as household_legal_firm_attributes_type
    , content:"Household__r.Legal_Firm__r.attributes.url"::text              as household_legal_firm_attributes_url
    , content:"Household__r.Mailing_State__c"::text                          as household_mailing_state
    , content:"Household__r.Name"::text                                      as household_name
    , content:"Household__r.Mariner_Location__r.Name"::text                  as household_mariner_location_name
    , content:"Household__r.attributes.type"::text                           as household_attributes_type
    , content:"Household__r.attributes.url"::text                            as household_attributes_url
    , content:Id::text                                                       as id
    , content:Identifier__c::text                                            as identifier
    , try_to_boolean(content:"Linked_Individual_Fixed_Income__c"::text)::int as linked_individual_fixed_income
    , content:"Model_On_Account__r.Id"::text                                 as model_on_account_id
    , content:"Model_On_Account__r.Model_Type__c"::text                      as model_on_account_model_type
    , content:"Model_On_Account__r.Name"::text                               as model_on_account_name
    , content:"Model_On_Account__r.attributes.type"::text                    as model_on_account_attributes_type
    , content:"Model_On_Account__r.attributes.url"::text                     as model_on_account_attributes_url
    , content:Name::text                                                     as name
    , try_to_boolean(content:Non_Discretionary_Account__c::text)::int        as non_discretionary_account
    , content:OpeningDate__c::date                                           as opening_date
    , try_to_boolean(content:Prime_Broker_Enabled__c::text)::int             as prime_broker_enabled
    , content:RecordTypeId::text                                             as record_type_id
    , content:"Registration_Type__r.Id"::text                                as registration_type_id
    , content:"Registration_Type__r.Name"::text                              as registration_type_name
    , content:"Registration_Type__r.attributes.type"::text                   as registration_type_attributes_type
    , content:"Registration_Type__r.attributes.url"::text                    as registration_type_attributes_url
    , try_to_boolean(content:SMAReviewRequired__c::text)::int                as sma_review_required
    , content:Status__c::text                                                as status
    , content:Subadvisor_Date_Opened__c::date                                as subadvisor_date_opened
    , content:"Subadvisor__r.Name"::text                                     as subadvisor_name
    , content:"Subadvisor__r.attributes.type"::text                          as subadvisor_attributes_type
    , content:"Subadvisor__r.attributes.url"::text                           as subadvisor_attributes_url
    , regexp_substr(subadvisor_attributes_url , '[^/]+$')                    as subadvisor_id
    , content:Tax_Status__c::text                                            as tax_status
    , content:Trading_ID__c::text                                            as trading_id
    , content:Trading_System__c::text                                        as trading_system
    , content:"attributes.type"::text                                        as attributes_type
    , content:"attributes.url"::text                                         as attributes_url
    , content:AccountDescription__c::text                                    as account_description
    , content:AM_Restrictions__c::text                                       as am_restrictions
    , content:ClosingDate__c::text                                           as closing_date
    , content:Comments__c::text                                              as comments
    , content:Distribution_Amount__c::text                                   as distribution_amount
    , content:Distribution_Frequency__c::text                                as distribution_frequency
    , content:Equity_Goal__c::text                                           as equity_goal
    , content:Estate_Item_type__c::text                                      as estate_item_type
    , content:Investment_Status_Notes__c::text                               as investment_status_notes
    , content:Maturity_Restriction__c::text                                  as maturity_restriction
    , content:Minimum_Cash__c::text                                          as minimum_cash
    , content:Other_Restriction__c::text                                     as other_restriction
    , content:Rating_Restriction__c::text                                    as rating_restriction
    , content:Restriction_Notes__c::text                                     as restriction_notes
    , content:Restriction_Notes_2__c::text                                   as restriction_notes_2
    , content:State1__c::text                                                as state_1
    , content:State2__c::text                                                as state_2
    , content:Trade_Restriction__c::text                                     as trade_restriction
    , content:YTD_Realized_Gain_Loss__c::text                                as ytd_realized_gain_loss
    , content:"Household__r.Fee_Manager__r.Name"::text                       as household_fee_manager_name
    , content:"Household__r.Parent.Name"::text                               as household_parent_name
    , try_to_boolean(
        content:"Moxy_Intra_Day_Import__c"::text
    )::int                                                                   as is_moxy_intra_day_import
    , _created_at                                                            as _created_at
    , {{ col_is_head(reference=source('salesforce_mis', 'estate_item'),
        source_date_col='_created_at',
        reference_date_col='_created_at') }}
from {{ source('salesforce_mis', 'estate_item') }}
