{% set src = source('black_diamond_ap4', 'accounts') %}

select
  'black_diamond'                            as pms
  , 'ap4'                                    as pms_location
  , 'mwa'                                    as firm_source
  , a.json:AccountNumber::string             as accountnumber
  , a.json:AccountCategory::string           as accountcategory
  , a.json:AccountRegistrationType::string   as accountregistrationtype
  , a.json:AccountSubCategory::string        as accountsubcategory
  , a.json:AccountType::string               as accounttype
  , a.json:AsOfDate::date                    as asofdate
  , aum.value:Value::varchar(100)            as aum_aua_ro
  , a.json:Billable::boolean                 as billable
  , a.json:BillingAccountDescription::string as billingaccountdescription
  , a.json:BillingEndDate::date              as billingenddate
  , a.json:BillingNumber::string             as billingnumber
  , a.json:BillingStartDate::date            as billingstartdate
  , t_cais.value:Value::varchar(100)         as cais
  , a.json:ClosedDate::date                  as closeddate
  , a.json:CustodialAccountName::string      as custodialaccountname
  , a.json:Custodian::string                 as custodian
  , a.json:DataProvider::string              as dataprovider
  , a.json:Discretionary::boolean            as discretionary
  , a.json:ExternalBillingAccountID::string  as externalbillingaccountid
  , a.json:HistoryStartDate::date            as historystartdate
  , a.json:Id::string                        as id
  , a.json:LastReconciledDate::date          as lastreconcileddate
  , a.json:LongNumber::string                as longnumber
  , trim(a.json:Manager:LastName::string)    as manager
  , a.json:Name::string                      as name
  , a.json:OtherBillingMethod::string        as otherbillingmethod
  , a.json:PayByInvoice::boolean             as paybyinvoice
  , a.json:PerformanceStartDate::date        as performancestartdate
  , a.json:StartDate::date                   as startdate
  , a.json:Supervised::boolean               as supervised
  , a.json:Team[0]:Name::string              as team
  , a.json:Details:TotalEmv::decimal(20, 5)  as totalemv
  , a.json:Style:Name::string                as stylename
  , a.json:TaxStatus::string                 as taxstatus
  , a.effective_date
  , a.record_id
  , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='a.effective_date') }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a.record_datetime as _source_loaded_at
from {{src}}                                                      a
   , lateral flatten(input => parse_json(a.json:Tags), outer => true) t_cais
   , lateral flatten(input => parse_json(a.json:Tags), outer => true) aum
where true
  and t_cais.value:Name::varchar(100) = 'CAIS'
  and aum.value:Name::varchar(100) = 'AUM / AUA / RO'