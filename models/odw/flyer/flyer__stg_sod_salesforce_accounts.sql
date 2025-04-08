select
    id::text(200)                                               as id
    , trading_system__c::text(200)                              as trading_system__c
    , identifier__c::text(200)                                  as identifier__c
    , name::text(200)                                           as name
    , status__c::text(200)                                      as status__c
    , openingdate__c::text(200)                                 as openingdate__c
    , household__c::text(200)                                   as household__c
    , aum_classification__c::text(200)                          as aum_classification__c
    , subadvisor_date_opened__c::text(200)                      as subadvisor_date_opened__c
    , accountidorion__c::text(200)                              as accountidorion__c
    , account_type__c::text(200)                                as account_type__c
    , attributes_type::text(200)                                as attributes_type
    , attributes_url::text(200)                                 as attributes_url
    , registration_type__r_attributes_type::text(200)           as registration_type__r_attributes_type
    , registration_type__r_attributes_url::text(200)            as registration_type__r_attributes_url
    , registration_type__r_name::text(200)                      as registration_type__r_name
    , custodian__r_attributes_type::text(200)                   as custodian__r_attributes_type
    , custodian__r_attributes_url::text(200)                    as custodian__r_attributes_url
    , custodian__r_name::text(200)                              as custodian__r_name
    , model_on_account__r_attributes_type::text(200)            as model_on_account__r_attributes_type
    , model_on_account__r_attributes_url::text(200)             as model_on_account__r_attributes_url
    , model_on_account__r_name::text(200)                       as model_on_account__r_name
    , household__r_attributes_type::text(200)                   as household__r_attributes_type
    , household__r_attributes_url::text(200)                    as household__r_attributes_url
    , household__r_name::text(200)                              as household__r_name
    , household__r_client_manager__r_attributes_type::text(200) as household__r_client_manager__r_attributes_type
    , household__r_client_manager__r_attributes_url::text(200)  as household__r_client_manager__r_attributes_url
    , household__r_client_manager__r_name::text(200)            as household__r_client_manager__r_name
    , subadvisor__r_attributes_type::text(200)                  as subadvisor__r_attributes_type
    , subadvisor__r_attributes_url::text(200)                   as subadvisor__r_attributes_url
    , subadvisor__r_name::text(200)                             as subadvisor__r_name
    , ownerid::text(200)                                        as ownerid
    , model_on_account__r::text(200)                            as model_on_account__r
    , registration_type__r::text(200)                           as registration_type__r
    , subadvisor__r::text(200)                                  as subadvisor__r
    , _created_at::timestamp                                    as _created_at
    , {{ col_is_head(
        reference=source('flyer', 'sod_salesforce_accounts'), 
        reference_date_col='_created_at', 
        source_date_col='_created_at'
    ) }}
from {{ source('flyer', 'sod_salesforce_accounts') }}
