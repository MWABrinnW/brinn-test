{% set src = source('emoney_mwa', 'flows') %}
select
    try_to_number(_data:"amount"::text , 28 , 10)::int                      as amount
    , _data:"type"::text(200)                                               as type
    , _data:"subtype"::text(200)                                            as subtype
    , _data:"clientid"::text(200)                                           as client_id
    , try_to_number(_data:"costbasis"::text , 28 , 10)::int                 as cost_basis
    , try_to_number(_data:"guaranteedyearsofpayout"::text , 28 , 10)::int   as guaranteed_years_of_payout
    , _data:"accountname"::text(200)                                        as account_name
    , _data:"accountid"::text(200)                                          as account_id
    , _data:"institutionname"::text(200)                                    as institution_name
    , try_to_number(_data:"terminyears"::text , 28 , 10)::int               as term_in_years
    , _data:"facttypename"::text(200)                                       as fact_type_name
    , try_to_timestamp(_data:"amountasof"::text , 'MM/DD/YYYY HH:MI:SS AM') as amount_as_of
    , _data:"destinationid"::text(200)                                      as destination_id
    , try_to_number(_data:"exclusionratio"::text , 28 , 10)::int            as exclusion_ratio
    , try_to_date(_data:"purchasedate"::text)::date                         as purchase_date
    , try_to_number(_data:"retirementamount"::text , 28 , 10)::int          as retirement_amount

    , effective_date::date                                                  as effective_date
    , _created_at::timestamp                                                as _created_at
    , _source_file::text(200)                                               as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
