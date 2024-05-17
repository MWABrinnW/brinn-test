{% set src = source('black_diamond_mps', 'accounts') %}

select
    'black_diamond'                                                              as system_name
    , 'mps'                                                                      as system_instance
    , concat(system_name , '__' , system_instance)                               as system_key
    , 'mps'                                                                      as firm_source
    , a.json:AccountNumber::string                                               as accountnumber
    , a.json:AccountCategory::string                                             as accountcategory
    , a.json:AccountRegistrationType::string                                     as accountregistrationtype
    , a.json:AccountSubCategory::string                                          as accountsubcategory
    , a.json:AccountType::string                                                 as accounttype
    , a.json:AsOfDate::date                                                      as asofdate
    , a.json:Billable::boolean                                                   as billable
    , a.json:BillingAccountDescription::string                                   as billingaccountdescription
    , a.json:BillingEndDate::date                                                as billingenddate
    , a.json:BillingNumber::string                                               as billingnumber
    , a.json:BillingStartDate::date                                              as billingstartdate
    , a.json:ClosedDate::date                                                    as closeddate
    , a.json:CustodialAccountName::string                                        as custodialaccountname
    , a.json:Custodian::string                                                   as custodian
    , a.json:DataProvider::string                                                as dataprovider
    , a.json:Discretionary::boolean                                              as discretionary
    , a.json:ExternalBillingAccountID::string                                    as externalbillingaccountid
    , a.json:HistoryStartDate::date                                              as historystartdate
    , a.json:Id::string                                                          as id
    , a.json:LastReconciledDate::date                                            as lastreconcileddate
    , a.json:LongNumber::string                                                  as longnumber
    , trim(a.json:Manager:LastName::string)                                      as manager
    , a.json:Name::string                                                        as name--noqa: RF04
    , a.json:OtherBillingMethod::string                                          as otherbillingmethod
    , a.json:PayByInvoice::boolean                                               as paybyinvoice
    , a.json:PerformanceStartDate::date                                          as performancestartdate
    , a.json:StartDate::date                                                     as startdate
    , a.json:Supervised::boolean                                                 as supervised
    , a.json:Team[0]:Name::string                                                as team
    , a.json:Details:TotalEmv::decimal(20 , 5)                                   as totalemv
    , a.json:Style:Name::string                                                  as stylename
    , a.json:TaxStatus::string                                                   as taxstatus
    , a.effective_date                                                           as effective_date
    , a.record_id                                                                as record_id
    , max(case when at.tag_name = 'AUM / AUA / RO' then at.tag_value end)        as aum_aua_ro
    , max(case when at.tag_name = 'Account Compression' then at.tag_value end)   as account_compression
    , max(case when at.tag_name = 'Account Type' then at.tag_value end)          as account_type
    , max(case when at.tag_name = 'Billing Split' then at.tag_value end)         as billing_split
    , max(case when at.tag_name = 'CAIS' then at.tag_value end)                  as cais
    , max(case when at.tag_name = 'ERISA' then at.tag_value end)                 as erisa
    , max(case when at.tag_name = 'Exclude from Billing' then at.tag_value end)  as exclude_from_billing
    , max(case when at.tag_name = 'IPS' then at.tag_value end)                   as ips
    , max(case when at.tag_name = 'Liquid vs Illiquid' then at.tag_value end)    as liquid_vs_illiquid
    , max(case when at.tag_name = 'Managed / Non-managed' then at.tag_value end) as managed_non_managed
    , max(case when at.tag_name = 'RPP Client' then at.tag_value end)            as rpp_client
    , max(case when at.tag_name = 'TD Account Number' then at.tag_value end)     as td_account_number
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                                                          as _source_loaded_at
from {{ src }} as a
left join {{ ref('black_diamond_mps__base_account_tags') }} as at--noqa: RF04
    on a.effective_date = at.effective_date
    and a.json:AccountNumber::string = at.account_number
group by all
