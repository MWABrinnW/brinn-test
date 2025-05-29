{%- macro black_diamond_base_accounts(
    src, instance, firm_source, extra_columns=none,
    extra_joins=none, where_clause=none, is_lambda=false
) -%}

select
    'black_diamond'::text                                                           as system_name
    , '{{ instance }}'::text                                                        as system_instance
    , concat(system_name , '__' , system_instance)                                  as system_key
    , '{{ firm_source }}'::text                                                     as firm_source
    , upper(a.json:AccountNumber)::text                                             as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(a.json:AccountNumber) , '-' , '')) , '0')::text
        , '\\s{2,}' ,' ')::text                                                     as account_number
    , a.json:AccountCategory::text                                                  as account_category
    , a.json:AccountRegistrationType::text                                          as account_registration_type
    , a.json:AccountSubCategory::text                                               as account_subcategory
    , a.json:AccountType::text                                                      as account_type
    , a.json:AsOfDate::date                                                         as as_of_date
    , a.json:Billable::boolean                                                      as billable
    , a.json:BillingAccountDescription::text                                        as billing_account_description
    , a.json:BillingEndDate::date                                                   as billing_end_date
    , a.json:BillingNumber::text                                                    as billing_number
    , a.json:BillingStartDate::date                                                 as billing_start_date
    , a.json:ClosedDate::date                                                       as closed_date
    , a.json:CustodialAccountName::text                                             as custodial_account_name
    , a.json:Custodian::text                                                        as custodian
    , a.json:DataProvider::text                                                     as data_provider
    , a.json:Discretionary::boolean                                                 as discretionary
    , a.json:ExternalBillingAccountID::text                                         as external_billing_accountid
    , a.json:HistoryStartDate::date                                                 as history_start_date
    , a.json:Id::text                                                               as id
    , a.json:LastReconciledDate::date                                               as last_reconciled_date
    , a.json:LongNumber::text                                                       as long_number
    , trim(a.json:Manager:LastName::text)                                           as manager
    , a.json:Name::text                                                             as account_name
    , a.json:OtherBillingMethod::text                                               as other_billing_method
    , a.json:PayByInvoice::boolean                                                  as pay_by_invoice
    , a.json:PerformanceStartDate::date                                             as performancestartdate
    , a.json:StartDate::date                                                        as start_date
    , a.json:Supervised::boolean                                                    as supervised
    , a.json:TaxStatus::text                                                        as tax_status
    , a.json:Team[0]:Name::text                                                     as team
    , a.json:Details:TotalEmv::decimal(20 , 5)                                      as total_emv
    , a.json:Style:Name::text                                                       as style_name
    , a.json:FeeSchedules[0].FeeScheduleType::string                                as fee_schedule_type
    , a.json:FeeSchedules[0].Name::string                                           as fee_name
    , a.json:FeeSchedules[0].RateType::string                                       as rate_type
    , a.effective_date                                                              as effective_date
    , a.record_id                                                                   as record_id
    {%- if not is_lambda %}
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date'
        ) }}
    , a.record_datetime                                                             as _created_at
    {%- else %}
    , current_timestamp()::timestamp_ntz                                            as _created_at
    {%- endif %}
    , a.record_datetime                                                             as _source_loaded_at
    {%- if extra_columns -%}
        {{ extra_columns }}
    {%- endif %}
from {{ src }} as a
{%- if extra_columns %}
left join {{ ref('black_diamond_' ~ instance ~ '__base_account_tags') }} as atag
    on a.effective_date = atag.effective_date
    and a.json:AccountNumber::text = atag.account_number
    {%- if extra_joins %}
        {{ extra_joins }}
    {%- endif %}
{%- endif %}
where 1 = 1
{%- if where_clause %}
{{ where_clause }}
{%- endif %}
group by all
--qualify dense_rank() over(
--    partition by a.effective_date, a.json:Id::text
--    order by a.record_datetime desc
--) = 1

{%- endmacro -%}
