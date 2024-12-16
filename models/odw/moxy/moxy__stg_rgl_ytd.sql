select
    json:"account id"::integer                            as account_id
    , json:"account number"::varchar(255)                 as account_number_formatted
    , replace(upper(account_number_formatted) , '-' , '') as account_number
    , json:"account type"::varchar(255)                   as account_type
    , json:"cost basis"::double precision                 as cost_basis
    , json:"custodian"::varchar(255)                      as custodian
    , json:"household id"::integer                        as household_id
    , json:"ismanaged"::boolean::int                      as ismanaged
    , json:"long term gainloss"::double precision         as long_term_gainloss
    , json:"long term units"::double precision            as long_term_units
    , json:"proceed amount"::double precision             as proceed_amount
    , json:"reg id"::integer                              as reg_id
    , json:"registration name"::varchar(255)              as registration_name
    , json:"rep id"::integer                              as rep_id
    , json:"short term gainloss"::double precision        as short_term_gainloss
    , json:"short term units"::double precision           as short_term_units
    , json:"total gain/loss"::double precision            as total_gainloss
    , _created_at                                         as _created_at
    , {{ col_is_head(
        reference=source('moxy', 'realized_gainloss_ytd'),
        source_date_col='_created_at',
        reference_date_col='_created_at'
    ) }}
from {{ source('moxy', 'realized_gainloss_ytd') }}
