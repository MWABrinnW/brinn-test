{% set src = source('emoney_mwa', 'trust_entities') %}
select
    _data:"type"::text(200)                                         as type
    , _data:"clientid"::text(200)                                   as client_id
    , _data:"factid"::text(200)                                     as fact_id
    , try_to_number(_data:"incomeinterest"::text , 28 , 10)::int    as income_interest
    , try_to_number(_data:"annuityamount"::text , 28 , 10)::int     as annuity_amount
    , try_to_number(_data:"retainedinterest"::text , 28 , 10)::int  as retained_interest
    , try_to_number(_data:"remainderinterest"::text , 28 , 10)::int as remainder_interest
    , _data:"establishedtype"::text(200)                            as established_type
    , try_to_number(_data:"payoutrate"::text , 28 , 10)::int        as payout_rate
    , _data:"typecode"::text(200)                                   as type_code
    , try_to_number(_data:"terminyears"::text , 28 , 10)::int       as term_in_years
    , _data:"termlifetime"::text(200)                               as term_lifetime
    , _data:"realestateaccountid"::text(200)                        as real_estate_account_id
    , try_to_date(_data:"dateestablished"::text)::date              as date_established
    , _data:"payouttype"::text(200)                                 as payout_type
    , try_to_boolean(_data:"withreversion"::text)::int              as with_reversion
    , _data:"name"::text(200)                                       as name

    , effective_date::date                                          as effective_date
    , _created_at::timestamp                                        as _created_at
    , _source_file::text(200)                                       as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
