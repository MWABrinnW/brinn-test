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
        --and is_head = 1
        and is_current = 1
        and custodian in ('schwab', 'fidelity')
        and link in (
            '08261207' -- schwab options master
            ,'G14279989' -- fidelity options G#
            ,'G26998441' -- fidelity options brokeragelink
            ,'08261207', '08220807', '08220445' -- TDA migrated schwab accounts
        )
    order by custodian, link, account_number
)
-- add a hard fail here if custodian_accounts data is not up to date
,crm_accounts as
(
        -- add effective_date in stg model
    select
        replace(upper(Identifier__c), '-', '')              as account_number
        , replace(name,'','')                              as account_name
        , null::text(200)                                   as model_name
        , Registration_Type__r_Name                         as account_type
        , HOUSEHOLD__R_CLIENT_MANAGER__R_NAME               as advisorname
        , accountidorion__c                                 as orion_account_id
        , Id                                                as crm_id
        , _created_at                                       as _created_at
    from {{ ref('flyer__stg_sod_salesforce_accounts') }}
    where _created_at = (select max(_created_at) from {{ ref('flyer__stg_sod_salesforce_accounts') }})
)
,accounts as
(
    select
          a.effective_date
        , a.custodian
        , a.account_number
        , a.account_number_formatted
        , a.link
        , regexp_replace(replace(coalesce(c.account_name, a.account_name),'"',''), '\\s+',' ') as account_name
        , c.advisorname
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
    , account_number                            as account_no
    , iff(account_name is null, account_number,
      account_name || ' - ' || account_number)  as account_name
    , upper(custodian)                          as custodian
    , ''::text(200)                             as description
    , ''::text(200)                             as notes
    , model_name                                as model_name
    , null::text(200)                           as closing_method
    , null::text(200)                           as long_term_tax_rate
    , null::text(200)                           as short_term_tax_rate
    , null::text(200)                           as use_account_cash
    , null::text(200)                           as cash_reserve_type
    , null::text(200)                           as cash_reserve
    , 'api@mariner' ||
        ';data@mariner' ||
        ';grant@mariner' ||
        ';tanner@mariner' ||
        ';austin@mariner' ||
        ';allen@mariner' ||
        ';sharedblotter@mariner' ||
        ';adam@mariner' ||
        ';brett@mariner' ||
        ';robert@mariner'
        ::text(200)                             as associated_Users
    , null::text(200)                           as taxable
    , null::text(200)                           as cashreserveexpiry
    , null::text(200)                           as disablesleeves
    , account_number_formatted::text(200)       as portfoliocode1
    , crm_id::text(200)                         as portfoliocode2
    , null::text(200)                           as portfoliocode3
    , account_type                              as accounttype
    , advisorname::text(200)                    as advisorname
from accounts
where rn = 1
