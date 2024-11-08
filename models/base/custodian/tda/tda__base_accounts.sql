{{ config(materialized = 'view') }}
select
    'tda'                                             as custodian
  , company_name::varchar(100)                        as company_name
  , last_name::varchar(100)                           as last_name
  , first_name::varchar(100)                          as first_name
  , street::varchar(100)                              as street
  , address_2::varchar(100)                           as address_2
  , address_3::varchar(100)                           as address_3
  , address_4::varchar(100)                           as address_4
  , address_5::varchar(100)                           as address_5
  , address_6::varchar(100)                           as address_6
  , city::varchar(100)                                as city
  , state::varchar(100)                               as state
  , zip_code::varchar(50)                             as zip_code
  , ssn::text                                         as ssn
  , account_number::varchar(100)                      as account_number
  , advisor_id::varchar(100)                          as advisor_id
  , taxable::varchar(100)                             as taxable
  , phone_number::number                              as phone_number
  , fax_number::number                                as fax_number
  , account_type::varchar(100)                        as account_type
  , objective::varchar(100)                           as objective
  , billing_account_number::varchar(100)              as billing_account_number
  , default_account::varchar(100)                     as default_account
  , state_of_primary_residence::boolean               as state_of_primary_residence
  , performance_inception_date::date                  as performance_inception_date
  , billing_inception_date::date                      as billing_inception_date
  , federal_tax_rate::varchar(100)                    as federal_tax_rate
  , state_tax_rate::varchar(100)                      as state_tax_rate
  , months_in_short_term_holding_period::varchar(100) as months_in_short_term_holding_period
  , fiscal_year_end::varchar(100)                     as fiscal_year_end
  , use_average_cost_accounting::decimal(19, 6)       as use_average_cost_accounting
  , display_accrued_interest::decimal(19, 6)          as display_accrued_interest
  , display_accrued_dividends::decimal(19, 6)         as display_accrued_dividends
  , display_accrued_gains::decimal(19, 6)             as display_accrued_gains
  , birth_date::date                                  as birth_date
  , discount_rate::double                             as discount_rate
  , payout_rate::double                               as payout_rate
  , effective_date                                    as effective_date
  , rep_code_firm                                     as rep_code_firm
  , _rep_code                                         as _rep_code
  , _file_type                                        as _file_type
  , _source_file                                      as _source_file
  , _source_loaded_at                                 as _source_loaded_at
from {{ ref('tda__base_trf') }}
where true

union all

select
    'tda'                                             as custodian
  , company_name::varchar(100)                        as company_name
  , last_name::varchar(100)                           as last_name
  , first_name::varchar(100)                          as first_name
  , street::varchar(100)                              as street
  , address_2::varchar(100)                           as address_2
  , address_3::varchar(100)                           as address_3
  , address_4::varchar(100)                           as address_4
  , address_5::varchar(100)                           as address_5
  , address_6::varchar(100)                           as address_6
  , city::varchar(100)                                as city
  , state::varchar(100)                               as state
  , zip_code::varchar(50)                             as zip_code
  , ssn::text                                         as ssn
  , account_number::varchar(100)                      as account_number
  , advisor_id::varchar(100)                          as advisor_id
  , taxable::varchar(100)                             as taxable
  , phone_number::number                              as phone_number
  , fax_number::number                                as fax_number
  , account_type::varchar(100)                        as account_type
  , objective::varchar(100)                           as objective
  , billing_account_number::varchar(100)              as billing_account_number
  , default_account::varchar(100)                     as default_account
  , state_of_primary_residence::boolean               as state_of_primary_residence
  , performance_inception_date::date                  as performance_inception_date
  , billing_inception_date::date                      as billing_inception_date
  , federal_tax_rate::varchar(100)                    as federal_tax_rate
  , state_tax_rate::varchar(100)                      as state_tax_rate
  , months_in_short_term_holding_period::varchar(100) as months_in_short_term_holding_period
  , fiscal_year_end::varchar(100)                     as fiscal_year_end
  , use_average_cost_accounting::decimal(19, 6)       as use_average_cost_accounting
  , display_accrued_interest::decimal(19, 6)          as display_accrued_interest
  , display_accrued_dividends::decimal(19, 6)         as display_accrued_dividends
  , display_accrued_gains::decimal(19, 6)             as display_accrued_gains
  , birth_date::date                                  as birth_date
  , discount_rate::double                             as discount_rate
  , payout_rate::double                               as payout_rate
  , effective_date                                    as effective_date
  , rep_code_firm                                     as rep_code_firm
  , _rep_code                                         as _rep_code
  , _file_type                                        as _file_type
  , _source_file                                      as _source_file
  , _source_loaded_at                                 as _source_loaded_at
from {{ ref('tda__base_trd') }}
where true


