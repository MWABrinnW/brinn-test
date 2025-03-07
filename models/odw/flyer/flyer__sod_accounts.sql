with custodian_accounts as (
    select distinct
        effective_date
        , custodian
        , account_number
        , account_number_formatted
        , link
        , null::text(200) as account_name
        , null::text(200) as account_type
    from {{ ref('custodian_account_links') }}
    where 1 = 1
        and is_head = 1
        and custodian in ('schwab' , 'fidelity')
        and link in (
            -- schwab options master
            '08261207'
            -- fidelity options G#
            , 'G14279989'
            -- fidelity options brokeragelink
            , 'G26998441'
            -- TDA migrated schwab accounts
            , '08261207' , '08220807' , '08220445'
        )
    order by custodian , link , account_number
)

-- TODO: add a hard fail here if custodian_accounts data is not up to date
, crm_accounts as (
    select
        replace(upper(a.identifier__c) , '-' , '') as account_number
        , replace(a.name , '' , '')                as account_name
        , null::text(200)                          as model_name
        , a.registration_type__r_name              as account_type
        , a.household__r_client_manager__r_name    as advisorname
        , a.accountidorion__c                      as orion_account_id
        , a.id                                     as crm_id
        , a._created_at                            as _created_at
        , u.email                                  as advisoremail
        , u.phone                                  as advisorphone
    from {{ ref('flyer__stg_sod_salesforce_accounts') }} as a
    left join {{ ref('salesforce_compass__base_user') }} as u
        on a.ownerid = u.id and u.is_head = 1
    where a._created_at = (select max(t._created_at) from {{ ref('flyer__stg_sod_salesforce_accounts') }} as t)
)

, accounts as (
    select
        a.effective_date                            as effective_date
        , a.custodian                               as custodian
        , a.account_number                          as account_number
        , a.account_number_formatted                as account_number_formatted
        , a.link                                    as link
        , regexp_replace(
            replace(
                coalesce(c.account_name , a.account_name)
                , '"' , ''
            ) , '\\s+' , ' '
        )                                           as account_name
        , c.advisorname                             as advisorname
        , c.model_name                              as model_name
        , coalesce(c.account_type , a.account_type) as account_type
        , c.crm_id                                  as crm_id
        , c.orion_account_id                        as orion_account_id
        , row_number() over (
            partition by a.effective_date , a.custodian , a.account_number order by c.model_name
        )                                           as rn
        , c.advisoremail                            as advisoremail
        , replace(
            coalesce(
                zoom.number , c.advisorphone
            ) , '+1' , ''
        )                                           as advisorphone
    from custodian_accounts as a
    left join crm_accounts as c
        on a.account_number = c.account_number
    left join {{ ref('zoom_mwa__base_user_phone_assignments') }} as zoom
        on lower(c.advisoremail) = lower(zoom.email)
)

select
    effective_date                                                   as effective_date
    , account_number                                                 as account_no
    , iff(
        account_name is null , account_number
        , account_name || ' - ' || account_number
    )                                                                as account_name
    , upper(custodian)                                               as custodian
    , ''::text(200)                                                  as description
    , ''::text(200)                                                  as notes
    , model_name
    , null::text(200)                                                as closing_method
    , null::text(200)                                                as long_term_tax_rate
    , null::text(200)                                                as short_term_tax_rate
    , null::text(200)                                                as use_account_cash
    , null::text(200)                                                as cash_reserve_type
    , null::text(200)                                                as cash_reserve
    , 'api@mariner'
    || ';data@mariner'
    || ';grant@mariner'
    || ';sharedblotter@mariner'
    || ';adam@mariner'
    || ';brett@mariner'
    || ';robert@mariner'
    || ';jacob@mariner'
    || ';brad@mariner'
    || ';ruben@mariner'
    || ';erin@mariner'
    ::text(200)                                                      as associated_users
    , null::text(200)                                                as taxable
    , null::text(200)                                                as cashreserveexpiry
    , null::text(200)                                                as disablesleeves
    , account_number_formatted::text(200)                            as portfoliocode1
    , crm_id::text(200)                                              as portfoliocode2
    , null::text(200)                                                as portfoliocode3
    , account_type                                                   as accounttype
    , replace(advisorname , ' (EMP)' , '')::text(200)                as advisorname
    , advisorphone::text(200)                                        as advisorphone
    , advisoremail::text(200)                                        as advisoremail
    , 'https://marinercrm.lightning.force.com/' || crm_id::text(200) as advisorurl
from accounts
where rn = 1
