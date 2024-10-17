{% set src = source('emoney_mwa', 'property_casualty_insurance_accounts') %}
select
    _data:"accountnumber"::text(200)                                        as account_number
    , _data:"clientid"::text(200)                                           as client_id
    , try_to_number(_data:"annualpremium"::text , 28 , 10)::int             as annual_premium
    , _data:"accountname"::text(200)                                        as account_name
    , try_to_boolean(_data:"underourmanagement"::text)::int                 as under_our_management
    , _data:"accountid"::text(200)                                          as account_id
    , _data:"institutionname"::text(200)                                    as institution_name
    , try_to_number(_data:"maximumannualbenefit"::text , 28 , 10)::int      as maximum_annual_benefit
    , _data:"facttypename"::text(200)                                       as fact_type_name
    , try_to_boolean(_data:"replacementvalue"::text)::int                   as replacement_value
    , try_to_timestamp(_data:"amountasof"::text , 'MM/DD/YYYY HH:MI:SS AM') as amount_as_of
    , try_to_number(_data:"premiumterminyears"::text , 28 , 10)::int        as premium_term_in_years
    , try_to_date(_data:"purchasedate"::text)::date                         as purchase_date
    , try_to_date(_data:"renewaldate"::text)::date                          as renewal_date
    , _data:"subtype"::text(200)                                            as subtype
    , try_to_number(_data:"connected"::text , 28 , 10)::int                 as connected
    , try_to_number(_data:"included"::text , 28 , 10)::int                  as included
    , _data:"type"::text(200)                                               as type

    , effective_date::date                                                  as effective_date
    , _created_at::timestamp                                                as _created_at
    , _source_file::text(200)                                               as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
