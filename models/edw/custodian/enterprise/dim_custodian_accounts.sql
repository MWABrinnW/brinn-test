{{ config(
    materialized='incremental',
    unique_key='account_number',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

with cte_accounts_with_max_date as (
    select
        custodian
        , account_number
        , max(is_head)        as is_head
        , min(effective_date) as min_effective_date
        , max(effective_date) as max_effective_date
    from {{ ref('bld_custodian_accounts') }}
    group by all
)

, cte_accounts as (
    select
        ca.custodian
        , ca.account_number
        , ca.account_number_formatted
        , max(case
            when ca.firm_source = 'mwa'
                then 1
            else 0
        end)                  as is_mwa
        , max(case
            when ca.firm_source = 'mps'
                then 1
            else 0
        end)                  as is_mps
        , max(case
            when ca.firm_source = 'swag'
                then 1
            else 0
        end)                  as is_swag
        , max(case
            when ca.firm_source in ('network' , 'mian')
                then 1
            else 0
        end)                  as is_network
        , case
            when a.is_head = 1
                then 1
            else 0
        end                   as is_active
        , ca.is_current
        , ca.rep_link
        , ca.rep_link_detail
        , ca.total_value
        , ca.cash_value
        , ca.account_type_source_code
        , ca.account_type_source_definition
        , ca.account_type
        , ca.opened_date
        , ca.account_title
        , ca.first_name
        , ca.middle_name
        , ca.last_name
        , ca.irs_id
        , ca.irs_id_type
        , ca.birth_date
        , ca.email_address
        , ca.phone
        , ca.cost_basis_method_mutual_funds
        , ca.cost_basis_method_non_mutual_funds
        , ca.is_taxable
        , ca.is_fee_authorized
        , ca.is_prime_broker
        , ca.restrictions_source_code
        , ca.restrictions_source_definition
        , ca.restrictions
        , ca.mailing_address_street
        , ca.mailing_address_city
        , ca.mailing_address_state
        , ca.mailing_address_zip
        , ca.legal_address_street
        , ca.legal_address_city
        , ca.legal_address_state
        , ca.legal_address_zip
        , ca.legal_address_country
        , a.min_effective_date
        , a.max_effective_date
        , current_timestamp() as _created_at
        , ca._source_loaded_at
        , ca._source_file
    from cte_accounts_with_max_date as a
    inner join {{ ref('bld_custodian_accounts') }} as ca
        on a.custodian = ca.custodian
        and a.account_number = ca.account_number
        and a.max_effective_date = ca.effective_date
    where true
    group by all
)

select *
from cte_accounts
qualify row_number() over (
    partition by
        custodian
        , account_number
    order by
        is_mwa
        , is_mps
        , is_swag
        , is_network
) = 1
