{% set src = source('black_diamond_commonwealth', 'accounts') %}

select
  'black_diamond'                            as pms
  , 'commonwealth'                                    as pms_location
  , 'mwa'                                    as firm_source
  , effective_date as effective_date
  , JSON:AccountNumber::string as account_number
  , JSON:AccountCategory::string as account_category
  , JSON:AccountRegistrationType::string as account_registration_type
  , JSON:AccountSubCategory::string as account_subcategory
  , JSON:AccountType::string as account_type
  , JSON:AsOfDate::date as_of_date
  , JSON:Billable::boolean as billable
  , JSON:BillingAccountDescription::string as billing_account_description
  , JSON:BillingEndDate::date as billing_end_date
  , JSON:BillingNumber::string as billing_number
  , JSON:BillingStartDate::date as billing_start_date
  , JSON:ClosedDate::date as closed_date
  , JSON:CustodialAccountName::string as custodial_account_name
  , JSON:Custodian::string as custodian
  , JSON:DataProvider::string as data_provider
  , JSON:Discretionary::boolean as discretionary
  , JSON:ExternalBillingAccountID::string as external_billing_account_id
  , JSON:HistoryStartDate::date as history_start_date
  , JSON:Id::string as id
  , JSON:LastReconciledDate::date as last_reconcile_date
  , JSON:LongNumber::string as long_number
  , JSON:Manager::string as manager
  , JSON:Name::string as name
  , JSON:OtherBillingMethod::string as other_billing_method
  , JSON:PayByInvoice::boolean as pay_by_invoice
  , JSON:PerformanceStartDate::date as performance_start_date
  , JSON:StartDate::date as start_date
  , JSON:Supervised::boolean as supervised
  , JSON:Details:TotalEmv::decimal(20,5) as total_emv
  , JSON:Style:Name::string as style
  , JSON:TaxStatus::string as tax_status
  , JSON:FeeSchedules[0].FeeScheduleType::string as fee_schedule_type
  , JSON:FeeSchedules[0].Name::string as fee_name
  , JSON:FeeSchedules[0].RateType::string as rate_type
  , record_id as record_id
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime as _source_loaded_at
from {{ src }}