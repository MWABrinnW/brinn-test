{%- macro black_diamond_base_accounts(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}

select
    'black_diamond'::text(200)                                                      as system_name
    , '{{ instance }}'::text(200)                                                   as system_instance
    , concat(system_name , '__' , system_instance)                                  as system_key
    , '{{ firm_source }}'::text(200)                                                as firm_source
    , upper(a.json:AccountNumber)::text(500)                                        as account_number_formatted                                                                               
    , regexp_replace(
        ltrim(upper(replace(trim(a.json:AccountNumber) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' ,' ')::text(200)                                                as account_number                        
    , a.json:AccountCategory::text(500)                                             as account_category
    , a.json:AccountRegistrationType::text(500)                                     as account_registration_type
    , a.json:AccountSubCategory::text(500)                                          as account_subcategory
    , a.json:AccountType::text(500)                                                 as account_type
    , a.json:AsOfDate::date                                                         as as_of_date
    , a.json:Billable::boolean                                                      as billable
    , a.json:BillingAccountDescription::text(500)                                   as billing_account_description
    , a.json:BillingEndDate::date                                                   as billing_end_date
    , a.json:BillingNumber::text(500)                                               as billing_number
    , a.json:BillingStartDate::date                                                 as billing_start_date
    , a.json:ClosedDate::date                                                       as closed_date
    , a.json:CustodialAccountName::text(500)                                        as custodial_account_name
    , a.json:Custodian::text(500)                                                   as custodian
    , a.json:DataProvider::text(500)                                                as data_provider
    , a.json:Discretionary::boolean                                                 as discretionary
    , a.json:ExternalBillingAccountID::text(500)                                    as external_billing_accountid
    , a.json:HistoryStartDate::date                                                 as history_start_date
    , a.json:Id::text(500)                                                          as id
    , a.json:LastReconciledDate::date                                               as last_reconciled_date
    , a.json:LongNumber::text(500)                                                  as long_number
    , trim(a.json:Manager:LastName::text(500))                                      as manager
    , a.json:Name::text(500)                                                        as account_name
    , a.json:OtherBillingMethod::text(500)                                          as other_billing_method
    , a.json:PayByInvoice::boolean                                                  as pay_by_invoice
    , a.json:PerformanceStartDate::date                                             as performancestartdate
    , a.json:StartDate::date                                                        as start_date
    , a.json:Supervised::boolean                                                    as supervised
    , a.json:TaxStatus::text(500)                                                   as tax_status
    , a.json:Team[0]:Name::text(500)                                                as team
    , a.json:Details:TotalEmv::decimal(20 , 5)                                      as total_emv
    , a.json:Style:Name::text(500)                                                  as style_name
    , a.json:FeeSchedules[0].FeeScheduleType::string                                as fee_schedule_type
    , a.json:FeeSchedules[0].Name::string                                           as fee_name
    , a.json:FeeSchedules[0].RateType::string                                       as rate_type
    , a.effective_date                                                              as effective_date
    , a.record_id                                                                   as record_id
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                            as _source_loaded_at
    {%- if extra_columns -%}
        {{ extra_columns }}
    {%- endif %}
from {{ src }} as a
left join {{ ref('black_diamond_' ~ instance ~ '__base_account_tags') }} as atag
    on a.effective_date = atag.effective_date
    and a.json:AccountNumber::text(500) = atag.account_number
    {%- if extra_joins %}
        {{ extra_joins }}
    {% endif %}
group by all

{%- endmacro -%}


