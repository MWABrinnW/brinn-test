with custodian_accounts as
(
    select distinct
        effective_date
      , custodian
      , account_number
      , account_number_formatted
      , link
      , null::text(200) as account_name
      , null::text(200) as account_type
    from {{ ref('custodian_account_links') }}
    where 1=1
        and is_head = 1
        and custodian in ('schwab', 'fidelity')
        and link in (
            '08261207', 'G14279989'
            ,'08261207', '08220807', '08220445' -- TDA migrated schwab accounts
        )
    order by custodian, link, account_number
)
,crm_accounts as
(
        -- add effective_date in stg model
    select
        replace(upper(Identifier__c), '-', '')              as account_number
        , name                                              as account_name
        , null::text(200)                                   as model_name
        , Registration_Type__r_Name                         as account_type
        , accountidorion__c                                 as orion_account_id
        , Id                                                as crm_id
        , _created_at                                       as _created_at
    from {{ ref('fixflyer_options__stg_sod_salesforce_accounts') }}
    where _created_at = (select max(_created_at) from {{ ref('fixflyer_options__stg_sod_salesforce_accounts') }})
)
,accounts as
(
    select
          a.effective_date
        , a.custodian
        , a.account_number
        , a.account_number_formatted
        , a.link
        , coalesce(c.account_name, a.account_name) as account_name
        , c.model_name
        , coalesce(c.account_type, a.account_type) as account_type
        , c.crm_id
        , c.orion_account_id
        , row_number() over(partition by a.effective_date, a.custodian, a.account_number order by c.model_name) as rn
    from custodian_accounts a
    left join crm_accounts c
        on a.account_number = c.account_number
)

select
      effective_date                            as effective_date
    , account_number                            as "account_No"
    , iff(account_name is null, account_number,
      account_name || ' - ' || account_number)  as "account_Name" 
    , upper(custodian)                          as "custodian"
    , ''::text(200)                             as "description"
    , ''::text(200)                             as "notes"
    , model_name                                as "model_Name"
    , null::text(200)                           as "closing_Method"
    , null::text(200)                           as "long_Term_Tax_Rate"
    , null::text(200)                           as "short_Term_Tax_Rate"
    , null::text(200)                           as "use_Account_Cash"
    , null::text(200)                           as "cash_Reserve_Type"
    , null::text(200)                           as "cash_Reserve"
    , null::text(200)                           as "taxable"
    , null::text(200)                           as "cashReserveExpiry"
    , null::text(200)                           as "disableSleeves"
    , account_number_formatted::text(200)       as "portfolioCode1"
    , crm_id::text(200)                         as "portfolioCode2"
    , null::text(200)                           as "portfolioCode3"
    , account_type                              as "accountType"
    , 'data@mariner,api@mariner,dev@mariner' ||
        ',adam@mariner' || 
        ',brett@mariner' ||
        ',tanner@mariner' ||
        ',austin@mariner' ||
        ',robert@mariner' ||
        ',grant@mariner'
        ::text(200)                             as "associated_Users"
from accounts
where rn = 1
