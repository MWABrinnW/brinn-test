{% set src = source('emoney_mwa', 'disability_ltc_insurance_accounts') %}
select
    _data:"accountnumber"::text(200)                                        as account_number
    , _data:"benefitperiod"::text(200)                                      as benefit_period
    , _data:"clientid"::text(200)                                           as client_id
    , _data:"totalvalue"::text(200)                                         as total_value
    , try_to_number(_data:"annualpremium"::text , 28 , 10)::int             as annual_premium
    , _data:"benefitamount"::text(200)                                      as benefit_amount
    , try_to_number(_data:"benefitpercent"::text , 28 , 10)::int            as benefit_percent
    , _data:"businessentityid"::text(200)                                   as business_entity_id
    , _data:"accountname"::text(200)                                        as account_name
    , try_to_boolean(_data:"underourmanagement"::text)::int                 as under_our_management
    , _data:"accountid"::text(200)                                          as account_id
    , try_to_number(_data:"benefitperiodindays"::text , 28 , 10)::int       as benefit_period_in_days
    , _data:"benefittype"::text(200)                                        as benefit_type
    , _data:"eliminationperiod"::text(200)                                  as elimination_period
    , _data:"institutionname"::text(200)                                    as institution_name
    , try_to_number(_data:"maximumannualbenefit"::text , 28 , 10)::int      as maximum_annual_benefit
    , _data:"benefitfrequency"::text(200)                                   as benefit_frequency
    , _data:"eliminationperiodindays"::text(200)                            as elimination_period_in_days
    , _data:"facttypename"::text(200)                                       as fact_type_name
    , try_to_boolean(_data:"isbenefittaxable"::text)::int                   as is_benefit_taxable
    , try_to_boolean(_data:"ownoccupation"::text)::int                      as own_occupation
    , try_to_timestamp(_data:"amountasof"::text , 'MM/DD/YYYY HH:MI:SS AM') as amount_as_of
    , _data:"premiumterminyears"::text(200)                                 as premium_term_in_years
    , try_to_date(_data:"purchasedate"::text)::date                         as purchase_date
    , _data:"subtype"::text(200)                                            as subtype
    , try_to_date(_data:"connected"::text)::date                            as connected
    , try_to_number(_data:"included"::text , 28 , 10)::int                  as included
    , _data:"type"::text(200)                                               as type

    , effective_date::date                                                  as effective_date
    , _created_at::timestamp                                                as _created_at
    , _source_file::text(200)                                               as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
