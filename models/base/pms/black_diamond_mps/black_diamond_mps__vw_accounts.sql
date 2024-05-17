{% set src = source('black_diamond_mps', 'accounts') %}

with cte_flatten as (
    select
        a.effective_date
        , a.json:AccountNumber::string   as accountnumber
        , tags.value:Name::varchar(100)  as tag_name
        , tags.value:Value::varchar(100) as tag_value
    from {{ src }} as a
    , lateral flatten(input => parse_json(a.json:Tags) , outer => true) as tags
)

, pvt as (
    select *
    from cte_flatten
    pivot (max(tag_value) for tag_name in ('AUM / AUA / RO' , 'CAIS' , 'ERISA' , 'RPP Client')
    ) as p (effective_date , accountnumber , aum_aua_ro , cais , erisa , rpp)
)

, final as (
    select
        'black_diamond'                                as system_name
        , 'mps'                                        as system_instance
        , concat(system_name , '__' , system_instance) as system_key
        , 'mps'                                        as firm_source
        , a.json:AccountNumber::string                 as accountnumber
        , a.json:AccountCategory::string               as accountcategory
        , a.json:AccountRegistrationType::string       as accountregistrationtype
        , a.json:AccountSubCategory::string            as accountsubcategory
        , a.json:AccountType::string                   as accounttype
        , a.json:AsOfDate::date                        as asofdate
        , pvt.aum_aua_ro::varchar(100)                 as aum_aua_ro
        , a.json:Billable::boolean                     as billable
        , a.json:BillingAccountDescription::string     as billingaccountdescription
        , a.json:BillingEndDate::date                  as billingenddate
        , a.json:BillingNumber::string                 as billingnumber
        , a.json:BillingStartDate::date                as billingstartdate
        , pvt.cais::varchar(100)                       as cais
        , a.json:ClosedDate::date                      as closeddate
        , a.json:CustodialAccountName::string          as custodialaccountname
        , a.json:Custodian::string                     as custodian
        , a.json:DataProvider::string                  as dataprovider
        , a.json:Discretionary::boolean                as discretionary
        , pvt.erisa::varchar(100)                      as erisa
        , a.json:ExternalBillingAccountID::string      as externalbillingaccountid
        , a.json:HistoryStartDate::date                as historystartdate
        , a.json:Id::string                            as id
        , a.json:LastReconciledDate::date              as lastreconcileddate
        , a.json:LongNumber::string                    as longnumber
        , trim(a.json:Manager:LastName::string)        as manager
        , a.json:Name::string                          as name--noqa: RF04
        , a.json:OtherBillingMethod::string            as otherbillingmethod
        , a.json:PayByInvoice::boolean                 as paybyinvoice
        , a.json:PerformanceStartDate::date            as performancestartdate
        , pvt.rpp::varchar(100)                        as rpp_client
        , a.json:StartDate::date                       as startdate
        , a.json:Supervised::boolean                   as supervised
        , a.json:Team[0]:Name::string                  as team
        , a.json:Details:TotalEmv::decimal(20 , 5)     as totalemv
        , a.json:Style:Name::string                    as stylename
        , a.json:TaxStatus::string                     as taxstatus
        , a.effective_date                             as effective_date
        , a.record_id                                  as record_id
        , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='a.effective_date') }}
        , {{ col_is_current(date_col='a.effective_date') }}
        , a.record_datetime                            as _source_loaded_at
    from {{ src }} as a
    left join pvt
        on a.effective_date = pvt.effective_date
        and a.json:AccountNumber::string = pvt.accountnumber
)

select *
from final
