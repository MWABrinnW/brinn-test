select
    a.system_key                                    as system_key
    , a.account_id                                  as account_id
    , a.account_number                              as account_number
    , a.account_name                                as account_name
    , a.custodian                                   as custodian
    , a.total_value                                 as total_value
    , a.is_margin_enabled                           as is_margin_enabled
    , a.is_multiple_margin_enabled                  as is_multiple_margin_enabled
    , a.options_approval_level                      as options_approval_level
    , a.is_active                                   as is_active
    , a.option_requirements                         as option_requirements
    , coalesce(sod.accounttype , s.account_type__c) as account_type
    , s.status__c                                   as status
    , s.openingdate__c                              as open_date
    , split_part(
        s.household__r_client_manager__r_name , ' (EMP)' , 1
    )                                               as advisor
    , s.model_on_account__r_name                    as model_name
    , iff(sod.account_no is not null , 1 , 0)       as is_linked
    , s.household__r_name                           as crm_household_name
    , s.name                                        as crm_account_name
    , s.household__c                                as crm_household_id
    , s.id                                          as crm_account_id
    , s.accountidorion__c                           as pms_account_id
    , a.last_collected_at                           as last_collected_at
    , a.first_collected_at                          as first_collected_at
    , a.effective_date                              as effective_date
    , a._source_file                                as _source_file
    , a._uri                                        as _uri
    , a._env                                        as _env

from {{ ref('flyer__dim_accounts') }} as a
left join {{ ref('flyer__stg_sod_accounts_history') }} as sod
    on a.effective_date = sod.effective_date
    and a.account_number = replace(sod.account_no , '-' , '')
    and sod.is_head = 1
left join {{ ref('flyer__stg_sod_salesforce_accounts') }} as s
    on a.account_number = replace(trim(s.identifier__c) , '-' , '')
where 1 = 1
