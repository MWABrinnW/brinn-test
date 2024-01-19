{% set src = source('black_diamond_baystate', 'accounts') %}

select
    'black_diamond'                                                                      as pms
    , 'baystate'                                                                         as pms_location
    , 'baystate'                                                                         as firm_source
    , a.json:AccountNumber::string                                                       as accountnumber
    , a.json:AccountCategory::string                                                     as accountcategory
    , a.json:AccountRegistrationType::string                                             as accountregistrationtype
    , a.json:AccountSubCategory::string                                                  as accountsubcategory
    , a.json:AccountType::string                                                         as accounttype
    , a.json:AsOfDate::date                                                              as asofdate
    , a.json:Billable::boolean                                                           as billable
    , a.json:BillingAccountDescription::string                                           as billingaccountdescription
    , a.json:BillingEndDate::date                                                        as billingenddate
    , a.json:BillingNumber::string                                                       as billingnumber
    , a.json:BillingStartDate::date                                                      as billingstartdate
    , a.json:ClosedDate::date                                                            as closeddate
    , a.json:CustodialAccountName::string                                                as custodialaccountname
    , a.json:Custodian::string                                                           as custodian
    , a.json:DataProvider::string                                                        as dataprovider
    , a.json:Discretionary::boolean                                                      as discretionary
    , a.json:ExternalBillingAccountID::string                                            as externalbillingaccountid
    , a.json:HistoryStartDate::date                                                      as historystartdate
    , a.json:Id::string                                                                  as id
    , a.json:LastReconciledDate::date                                                    as lastreconcileddate
    , a.json:LongNumber::string                                                          as longnumber
    , trim(a.json:Manager:LastName::string)                                              as manager
    , a.json:Name::string                                                                as name
    , a.json:OtherBillingMethod::string                                                  as otherbillingmethod
    , a.json:PayByInvoice::boolean                                                       as paybyinvoice
    , a.json:PerformanceStartDate::date                                                  as performancestartdate
    , a.json:StartDate::date                                                             as startdate
    , a.json:Supervised::boolean                                                         as supervised
    , a.json:Team[0]:Name::string                                                        as team
    , a.json:Details:TotalEmv::decimal(20 , 5)                                           as totalemv
    , a.json:Style:Name::string                                                          as stylename
    , a.json:TaxStatus::string                                                           as taxstatus
    , a.effective_date                                                                   as effective_date
    , a.record_id                                                                        as record_id
    , max(case when at.tag_name = 'Account Comments' then at.tag_value end)              as account_comments
    , max(case when at.tag_name = 'Active/Passive Form' then at.tag_value end)           as active_passive_form
    , max(case when at.tag_name = 'Advisor Commission Split Code' then at.tag_value end) as advisor_commission_split_code
    , max(case when at.tag_name = 'Billing Company' then at.tag_value end)               as billing_company
    , max(case when at.tag_name = 'Notes' then at.tag_value end)                         as notes_1
    , max(case when at.tag_name = 'Notes 1' then at.tag_value end)                       as notes_1
    , max(case when at.tag_name = 'Notes 2' then at.tag_value end)                       as notes_2
    , max(case when at.tag_name = 'Select Alternatives' then at.tag_value end)           as select_alternatives
    , max(case when at.tag_name = 'Select Equities' then at.tag_value end)               as select_equities
    , max(case when at.tag_name = 'Select Fixed Income' then at.tag_value end)           as select_fixed_income
    , max(case when at.tag_name = 'Select Program' then at.tag_value end)                as select_program
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                                                                  as _source_loaded_at
from {{ src }} as a
left join {{ ref('black_diamond_baystate__base_account_tags') }} as at
    on a.effective_date = at.effective_date
    and a.json:AccountNumber::string = at.account_number
group by all
