{% set src = source('salesforce_pb', 'custodial_pb') %}
select
    content:"Id"::text                                                as id
    , content:"Identifier__c"::text                                   as identifier_c--account_number
    , content:"AccountIDOrion__c"::text                               as account_id_orion
    , content:"Current_Value__c"::int                                 as current_value
    , try_to_boolean(content:"Prime_Broker_Enabled__c"::boolean)::int as is_prime_broker_enabled
    , content:"Subadvisor__c"::text                                   as subadvisor
    , content:"Custodian__r.Name"::text                               as custodian_name
    , content:"Status__c"::text                                       as status
    , content:"Custodian__r.attributes.url"::text                     as custodian_attributes_url
    , content:"Custodian__r.attributes.type"::text                    as custodian_attributes_type
    , content:"attributes.url"::text                                  as attributes_url
    , content:"attributes.type"::text                                 as attributes_type

    , _created_at::timestamp                                          as _created_at
    , {{ col_is_head(reference=src, reference_date_col='_created_at', source_date_col='_created_at') }}
from {{ src }}
