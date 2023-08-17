select
    id ::TEXT(200)                                             as id
  , trading_system__c ::TEXT(200)                              as trading_system__c
  , identifier__c ::TEXT(200)                                  as identifier__c
  , name ::TEXT(200)                                           as name
  , status__c ::TEXT(200)                                      as status__c
  , openingdate__c ::TEXT(200)                                 as openingdate__c
  , household__c ::TEXT(200)                                   as household__c
  , aum_classification__c ::TEXT(200)                          as aum_classification__c
  , subadvisor_date_opened__c ::TEXT(200)                      as subadvisor_date_opened__c
  , accountidorion__c ::TEXT(200)                              as accountidorion__c
  , account_type__c ::TEXT(200)                                as account_type__c
  , attributes_type ::TEXT(200)                                as attributes_type
  , attributes_url ::TEXT(200)                                 as attributes_url
  , registration_type__r_attributes_type ::TEXT(200)           as registration_type__r_attributes_type
  , registration_type__r_attributes_url ::TEXT(200)            as registration_type__r_attributes_url
  , registration_type__r_name ::TEXT(200)                      as registration_type__r_name
  , custodian__r_attributes_type ::TEXT(200)                   as custodian__r_attributes_type
  , custodian__r_attributes_url ::TEXT(200)                    as custodian__r_attributes_url
  , custodian__r_name ::TEXT(200)                              as custodian__r_name
  , model_on_account__r_attributes_type ::TEXT(200)            as model_on_account__r_attributes_type
  , model_on_account__r_attributes_url ::TEXT(200)             as model_on_account__r_attributes_url
  , model_on_account__r_name ::TEXT(200)                       as model_on_account__r_name
  , household__r_attributes_type ::TEXT(200)                   as household__r_attributes_type
  , household__r_attributes_url ::TEXT(200)                    as household__r_attributes_url
  , household__r_name ::TEXT(200)                              as household__r_name
  , household__r_client_manager__r_attributes_type ::TEXT(200) as household__r_client_manager__r_attributes_type
  , household__r_client_manager__r_attributes_url ::TEXT(200)  as household__r_client_manager__r_attributes_url
  , household__r_client_manager__r_name ::TEXT(200)            as household__r_client_manager__r_name
  , subadvisor__r_attributes_type ::TEXT(200)                  as subadvisor__r_attributes_type
  , subadvisor__r_attributes_url ::TEXT(200)                   as subadvisor__r_attributes_url
  , subadvisor__r_name ::TEXT(200)                             as subadvisor__r_name
  , household__r_client_manager__r ::TEXT(200)                 as household__r_client_manager__r
  , model_on_account__r ::TEXT(200)                            as model_on_account__r
  , registration_type__r ::TEXT(200)                           as registration_type__r
  , subadvisor__r ::TEXT(200)                                  as subadvisor__r
    -- is_head --is_latest
  , _created_at::timestamp as _created_at
from {{ source('copilot', 'sod_salesforce_accounts') }}
