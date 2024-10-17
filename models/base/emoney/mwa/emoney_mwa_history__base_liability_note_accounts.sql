{% set src = source('emoney_mwa', 'liability_note_accounts') %}
select
    try_to_number(_data:"included"::text , 28 , 10)::int                    as included
    , _data:"subtype"::text(200)                                            as subtype
    , try_to_number(_data:"connected"::text , 28 , 10)::int                 as connected
    , try_to_number(_data:"cashbalance"::text , 28 , 10)::int               as cash_balance
    , _data:"clientid"::text(200)                                           as client_id
    , try_to_boolean(_data:"isinterestdeductible"::text)::int               as is_interest_deductible
    , _data:"loandate"::text(200)                                           as loan_date
    , try_to_number(_data:"marginbalance"::text , 28 , 10)::int             as margin_balance
    , try_to_number(_data:"originalloanamount"::text , 28 , 10)::int        as original_loan_amount
    , _data:"paymentfrequency"::text(200)                                   as payment_frequency
    , _data:"repaymenttype"::text(200)                                      as repayment_type
    , try_to_number(_data:"totalvalue"::text , 28 , 10)::int                as total_value
    , try_to_number(_data:"costbasis"::text , 28 , 10)::int                 as cost_basis
    , try_to_number(_data:"annualfee"::text , 28 , 10)::int                 as annual_fee
    , try_to_number(_data:"baloonperiodinyears"::text , 28 , 10)::int       as baloon_period_in_years
    , _data:"accountname"::text(200)                                        as account_name
    , try_to_number(_data:"loanterminyears"::text , 28 , 10)::int           as loan_term_in_years
    , try_to_number(_data:"numberofpayments"::text , 28 , 10)::int          as number_of_payments
    , try_to_boolean(_data:"underourmanagement"::text)::int                 as under_our_management
    , _data:"accountid"::text(200)                                          as account_id
    , _data:"institutionname"::text(200)                                    as institution_name
    , _data:"facttypename"::text(200)                                       as fact_type_name
    , try_to_number(_data:"holdingsvalue"::text , 28 , 10)::int             as holdings_value
    , try_to_number(_data:"interestrate"::text , 28 , 10)::int              as interest_rate
    , _data:"realestateaccountid"::text(200)                                as real_estate_account_id
    , try_to_timestamp(_data:"amountasof"::text , 'MM/DD/YYYY HH:MI:SS AM') as amount_as_of
    , _data:"type"::text(200)                                               as type

    , effective_date::date                                                  as effective_date
    , _created_at::timestamp                                                as _created_at
    , _source_file::text(200)                                               as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
