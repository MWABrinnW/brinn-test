select
    'tpg'::text(200)                                                                as system_name
    , 'hfw'::text(200)                                                              as system_instance
    , concat(system_name , '__' , system_instance)::text(200)                       as system_key
    , 'mwa'::text(200)                                                              as firm_source
    , to_timestamp(asofdate , 'MM/DD/YYYY HH:MI:SS AM')::date                       as as_of_date
    , upper(customeraccountnumber::text(200))                                       as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(customeraccountnumber) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                                                    as account_number
    , customername::text(200)                                                       as client_name
    , customertypedesc::text(200)                                                   as client_type_desc
    , cusip::text(200)                                                              as cusip
    , cusipdescription::text(200)                                                   as cusip_type_desc
    , holdingtypedesc::text(200)                                                    as security_type
    , positionid::text(200)                                                         as position_id
    , purchaseprice::decimal(20 , 5)                                                as cost_basis
    , marketpriceaod::decimal(20 , 5)                                               as price
    , fairvalue::decimal(20 , 2)                                                    as market_value
    , parvalue::decimal(20 , 2)                                                     as par_value
    , effective_date::date                                                          as effective_date
    , record_datetime::datetime                                                     as _created_at
    , source_file::text(200)                                                        as _source_file
    -- ranks records that appear in multiple files for the same effective date for downsteam deduping
    , dense_rank() over (partition by effective_date order by record_datetime desc) as rn
    , {{ col_is_head(reference=source('tpg_hfw', 'holdings')) }}
    , {{ col_is_current(date_col='effective_date') }}
from {{ source('tpg_hfw', 'holdings') }}
