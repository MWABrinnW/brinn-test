{% set src = source('black_diamond_houston', 'accounts') %}

select
    'black_diamond'                                                             as pms
    , 'houston'                                                                 as pms_location
    , 'mwa'                                                                     as firm_source
    , a.effective_date                                                          as effective_date
    , a.json:AccountNumber::string                                              as account_number
    , a.json:AccountCategory::string                                            as account_category
    , a.json:AccountRegistrationType::string                                    as account_registration_type
    , a.json:AccountSubCategory::string                                         as account_subcategory
    , a.json:AccountType::string                                                as account_type
    , a.json:AsOfDate::date                                                     as as_of_date
    , a.json:Billable::boolean                                                  as billable
    , a.json:BillingAccountDescription::string                                  as billing_account_description
    , a.json:BillingEndDate::date                                               as billing_end_date
    , a.json:BillingNumber::string                                              as billing_number
    , a.json:BillingStartDate::date                                             as billing_start_date
    , a.json:ClosedDate::date                                                   as closed_date
    , a.json:CustodialAccountName::string                                       as custodial_account_name
    , a.json:Custodian::string                                                  as custodian
    , a.json:DataProvider::string                                               as data_provider
    , a.json:Discretionary::boolean                                             as discretionary
    , a.json:ExternalBillingAccountID::string                                   as external_billing_account_id
    , a.json:HistoryStartDate::date                                             as history_start_date
    , a.json:Id::string                                                         as id
    , a.json:LastReconciledDate::date                                           as last_reconcile_date
    , a.json:LongNumber::string                                                 as long_number
    , a.json:Manager::string                                                    as manager
    , a.json:Name::string                                                       as name
    , a.json:OtherBillingMethod::string                                         as other_billing_method
    , a.json:PayByInvoice::boolean                                              as pay_by_invoice
    , a.json:PerformanceStartDate::date                                         as performance_start_date
    , a.json:StartDate::date                                                    as start_date
    , a.json:Supervised::boolean                                                as supervised
    , a.json:Details:TotalEmv::decimal(20 , 5)                                  as total_emv
    , a.json:Style:Name::string                                                 as style
    , a.json:TaxStatus::string                                                  as tax_status
    , a.record_id                                                               as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , max(case when at.tag_name = 'PB' then at.tag_value end)                   as pb
    , max(case when at.tag_name = 'TR' then at.tag_value end)                   as tr
    , max(case when at.tag_name = 'WAS Account' then at.tag_value end)          as was_account
    , max(case when at.tag_name = 'Notes' then at.tag_value end)                as notes
    , max(case when at.tag_name = 'State2' then at.tag_value end)               as state2
    , max(case when at.tag_name = 'Strategy' then at.tag_value end)             as strategy
    , max(case when at.tag_name = 'Lot' then at.tag_value end)                  as lot
    , max(case when at.tag_name = 'R' then at.tag_value end)                    as r
    , max(case when at.tag_name = 'SI Custody' then at.tag_value end)           as si_custody
    , max(case when at.tag_name = 'Account Registration' then at.tag_value end) as account_registration
    , max(case when at.tag_name = 'TD Account Number' then at.tag_value end)    as td_account_number
    , max(case when at.tag_name = 'Stonnington Referral' then at.tag_value end) as stonnington_referral
    , max(case when at.tag_name = 'Regulatory Account' then at.tag_value end)   as regulatory_account
    , max(case when at.tag_name = 'QB' then at.tag_value end)                   as qb
    , max(case when at.tag_name = 'MWA Contract' then at.tag_value end)         as mwa_contract
    , max(case when at.tag_name = 'Rest Notes' then at.tag_value end)           as rest_notes
    , max(case when at.tag_name = 'SAN Account' then at.tag_value end)          as san_account
    , max(case when at.tag_name = 'State' then at.tag_value end)                as state
    , a.record_datetime                                                         as _source_loaded_at
from {{ src }} as a
left join {{ ref('black_diamond_houston_history__base_account_tags') }} as at
    on a.effective_date = at.effective_date
    and a.json:AccountNumber::string = at.account_number
group by all
