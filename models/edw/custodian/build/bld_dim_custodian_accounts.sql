{{ config(
    materialized='incremental',
    unique_key='account_number',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

with cte_accounts_with_max_date as (
    select
        custodian             as custodian
        , account_number      as account_number
        , min(effective_date) as min_effective_date
        , max(effective_date) as max_effective_date
    from {{ ref('bld_custodian_accounts') }}
    group by all
)

, cte_accounts as (
    select
        ca.custodian                            as custodian
        , ca.account_number                     as account_number
        , ca.account_number_formatted           as account_number_formatted
        , max(case
            when ca.firm_source = 'mwa'
                then 1
            else 0
        end)                                    as is_mwa
        , max(case
            when ca.firm_source = 'mps'
                then 1
            else 0
        end)                                    as is_mps
        , max(case
            when ca.firm_source = 'swag'
                then 1
            else 0
        end)                                    as is_swag
        , max(case
            when ca.firm_source in ('network' , 'mian')
                then 1
            else 0
        end)                                    as is_network
        , case
            when ca.is_head = 1
                then 1
            else 0
        end                                     as is_active
        , ca.is_current                         as is_current
        , ca.rep_link                           as rep_link
        , ca.rep_link_detail                    as rep_link_detail
        , ca.total_value                        as total_value
        , ca.cash_value                         as cash_value
        , ca.account_type_source_code           as account_type_source_code
        , ca.account_type_source_definition     as account_type_source_definition
        , ca.account_type                       as account_type
        , ca.opened_date                        as opened_date
        , ca.account_title                      as account_title
        , ca.first_name                         as first_name
        , ca.middle_name                        as middle_name
        , ca.last_name                          as last_name
        , ca.irs_id                             as irs_id
        , ca.irs_id_type                        as irs_id_type
        , ca.birth_date                         as birth_date
        , ca.email_address                      as email_address
        , ca.phone                              as phone
        , ca.cost_basis_method_mutual_funds     as cost_basis_method_mutual_funds
        , ca.cost_basis_method_non_mutual_funds as cost_basis_method_non_mutual_funds
        , ca.is_taxable                         as is_taxable
        , ca.is_fee_authorized                  as is_fee_authorized
        , ca.is_prime_broker                    as is_prime_broker
        , ca.restrictions_source_code           as restrictions_source_code
        , ca.restrictions_source_definition     as restrictions_source_definition
        , ca.restrictions                       as restrictions
        , ca.mailing_address_street             as mailing_address_street
        , ca.mailing_address_city               as mailing_address_city
        , ca.mailing_address_state              as mailing_address_state
        , ca.mailing_address_zip                as mailing_address_zip
        , ca.legal_address_street               as legal_address_street
        , ca.legal_address_city                 as legal_address_city
        , ca.legal_address_state                as legal_address_state
        , ca.legal_address_zip                  as legal_address_zip
        , ca.legal_address_country              as legal_address_country
        , a.min_effective_date                  as min_effective_date
        , a.max_effective_date                  as max_effective_date
        , current_timestamp()                   as _created_at
        , ca._source_loaded_at                  as _source_loaded_at
        , ca._source_file                       as _source_file
    from cte_accounts_with_max_date as a
    inner join {{ ref('custodian_accounts') }} as ca
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
