select
    a.pms_account_id                                                                                        as pms_account_id
    , trim(regexp_replace(lower(a.account_number) , '(s-|r-|-)' , ''))                                      as account_key
    , a.account_name                                                                                        as description
    , case
        when a.state_1 ilike 'nat' and coalesce(lower(a.mailing_state) , '') not in ('' , 'nat')
            then a.mailing_state
        when a.state_1 ilike 'nat' then 'US'
        when not (coalesce(a.state_1 , '') ilike any ('' , 'nat' , 'n/a')) then a.state_1
    end::text(200)                                                                                          as port_state
    , to_varchar(coalesce(a.subadvisor_date_opened , a.opening_date)::date , 'MM/DD/YYYY')                  as inception_date
    , a.status                                                                                              as status
    , a.custodian                                                                                           as custodian
    , a.model::text(200)                                                                                    as model
    , iff(a.is_sma_review_required = 1 , 'PortfolioReviews' , 'AIPManaged')::text(200)                      as type
    , a.account_number_formatted                                                                            as account_custodial
    , a.account_name                                                                                        as contact_name
    , case
        when a.household_name ilike '%(Client Advisor)%'
            then a.household_parent_name
        else a.household_legal_firm_name
    end::text(200)                                                                                          as sponsor
    , 'Constant Yield'::text(200)
        as amort_method_tax_exempt
    , 'Constant Yield'::text(200)
        as accret_method_tax_exempt
    , 'Constant Yield'::text(200)
        as amort_method_taxable
    , 'Constant Yield'::text(200)
        as accret_method_taxable
    , iff(a.is_sma_review_required = 1 , 'mwa-review' , 'mwa-montage')::text(200)                           as blotter_target
    , '<override>'
    || iff(a.am_restrictions is not null and lower(a.am_restrictions) not in ('?' , 'n/a') , '|' || a.am_restrictions , '')
    || iff(a.maturity_restriction is not null , '|' || a.maturity_restriction , '')                         as tags
    , 'URL (https://marinercrm.lightning.force.com/lightning/r/EstateItem__c/'::text
    || a.crm_account_id || '/view'
    || iff(a.investment_status_notes is not null , '|Inv Status (' || a.investment_status_notes || ')' , '')
    || iff(a.rating_restriction is not null , '|Rating Restriction (' || a.rating_restriction || ')' , '')
    || iff(a.other_restriction is not null , '|Other Restriction (' || a.other_restriction || ')' , '')
    || iff(a.restriction_notes is not null , '|Restriction Notes (' || a.restriction_notes || ')' , '')
    || iff(a.restriction_notes_2 is not null , '|Restriction Notes (' || a.restriction_notes_2 || ')' , '')
        as memo
    --, a.household_mariner_location_name                                                                     as mariner_location
    , a.registration_type                                                                                   as client_type
    , case
        when a.household_name ilike '%(Client Advisor)%'
            then a.household_name
        else a.client_manager
    end::text(200)                                                                                          as financial_advisor
    , iff(a.is_prime_broker = 1 , 'yes' , 'no')                                                             as prime_broker

    , a.crm_account_id                                                                                      as id
    , iff(a.is_sma_review_required = 1 , 'mwa-review' , 'mwa-montage')::text(200)                           as source
    , iff(pa.account_number is not null , 1 , 0)                                                            as is_in_perform
    , a.crm_account_id                                                                                      as crm_account_id
    , a.subadvisor_date_opened
        as subadvisor_date_opened
from {{ ref('mis__bld_accounts') }} as a
left join {{ ref('perform__stg_accounts') }} as pa
    on trim(regexp_replace(lower(a.account_number) , '(s-|r-|-)' , '')) = pa.account_number
    and pa.is_head = 1
where a.is_perform = 1
    and coalesce(pa.port_status , '') not ilike 'closed'
    and coalesce(a.status , '') not ilike 'closed'
order by a.account_number
