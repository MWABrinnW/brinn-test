{% set src = source('emoney_mwa', 'life_insurance_annuity_accounts') %}
select
    _data:"accountnumber"::text(200)                                 as account_number
    , _data:"cashbalance"::text(200)                                 as cash_balance
    , _data:"clientid"::text(200)                                    as client_id
    , _data:"marginbalance"::text(200)                               as margin_balance
    , _data:"totalvalue"::text(200)                                  as total_value
    , try_to_number(_data:"annualpremium"::text , 28 , 10)::int      as annual_premium
    , _data:"costbasis"::text(200)                                   as cost_basis
    , _data:"deathbenefit"::text(200)                                as death_benefit
    , _data:"accountname"::text(200)                                 as account_name
    , _data:"surrendervalue"::text(200)                              as surrender_value
    , try_to_number(_data:"underourmanagement"::text , 28 , 10)::int as under_our_management
    , _data:"accountid"::text(200)                                   as account_id
    , _data:"institutionname"::text(200)                             as institution_name
    , try_to_number(_data:"premiumexclusion"::text , 28 , 10)::int   as premium_exclusion
    , try_to_number(_data:"terminyears"::text , 28 , 10)::int        as term_in_years
    , _data:"facttypename"::text(200)                                as fact_type_name
    , _data:"holdingsvalue"::text(200)                               as holdings_value
    , try_to_number(_data:"amountasof"::text , 28 , 10)::int         as amount_as_of
    , try_to_number(_data:"premiumterminyears"::text , 28 , 10)::int as premium_term_in_years
    , try_to_date(_data:"purchasedate"::text)::date                  as purchase_date
    , _data:"subtype"::text(200)                                     as subtype
    , try_to_date(_data:"country"::text)::date                       as country
    , try_to_number(_data:"connected"::text , 28 , 10)::int          as connected
    , try_to_number(_data:"included"::text , 28 , 10)::int           as included
    , _data:"type"::text(200)                                        as type

    , effective_date::date                                           as effective_date
    , _created_at::timestamp                                         as _created_at
    , _source_file::text(200)                                        as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
