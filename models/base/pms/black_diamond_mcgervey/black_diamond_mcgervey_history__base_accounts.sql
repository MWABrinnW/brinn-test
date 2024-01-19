{% set src = source('black_diamond_mcgervey', 'accounts') %}

select
    'black_diamond'                                             as pms
    , 'mcgervey'                                                as pms_location
    , 'mwa'                                                     as firm_source
    , a.effective_date                                          as effective_date
    , a.json:AccountNumber::string                              as account_number
    , a.json:AccountCategory::string                            as account_category
    , a.json:AccountRegistrationType::string                    as account_registration_type
    , a.json:AccountSubCategory::string                         as account_subcategory
    , a.json:AccountType::string                                as account_type
    , a.json:AsOfDate::date                                     as as_of_date
    , a.json:Billable::boolean                                  as billable
    , a.json:BillingAccountDescription::string                  as billing_account_description
    , a.json:BillingEndDate::date                               as billing_end_date
    , a.json:BillingNumber::string                              as billing_number
    , a.json:BillingStartDate::date                             as billing_start_date
    , a.json:ClosedDate::date                                   as closed_date
    , a.json:CustodialAccountName::string                       as custodial_account_name
    , a.json:Custodian::string                                  as custodian
    , a.json:DataProvider::string                               as data_provider
    , a.json:Discretionary::boolean                             as discretionary
    , a.json:ExternalBillingAccountID::string                   as external_billing_account_id
    , a.json:HistoryStartDate::date                             as history_start_date
    , a.json:Id::string                                         as id
    , a.json:LastReconciledDate::date                           as last_reconcile_date
    , a.json:LongNumber::string                                 as long_number
    , a.json:Manager::string                                    as manager
    , a.json:Name::string                                       as name
    , a.json:OtherBillingMethod::string                         as other_billing_method
    , a.json:PayByInvoice::boolean                              as pay_by_invoice
    , a.json:PerformanceStartDate::date                         as performance_start_date
    , a.json:StartDate::date                                    as start_date
    , a.json:Supervised::boolean                                as supervised
    , a.json:Details:TotalEmv::decimal(20 , 5)                  as total_emv
    , a.json:Style:Name::string                                 as style
    , a.json:TaxStatus::string                                  as tax_status
    , a.json:RepCodes[0]:Code::string                           as rep_code
    , a.record_id                                               as record_id
    , max(case when at.tag_name = 'Name' then at.tag_value end) as name
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                                         as _source_loaded_at
from {{ src }} as a
left join {{ ref('black_diamond_mcgervey_history__base_account_tags') }} as at
    on a.effective_date = at.effective_date
    and a.json:AccountNumber::string = at.account_number
group by all
