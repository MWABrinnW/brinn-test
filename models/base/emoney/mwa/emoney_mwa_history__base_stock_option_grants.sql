{% set src = source('emoney_mwa', 'stock_option_grants') %}
select
    _data:"clientid"::text(200)                                  as client_id
    , try_to_date(_data:"expirationdate"::text)::date            as expiration_date
    , try_to_number(_data:"sharesgranted"::text , 28 , 10)::int  as shares_granted
    , try_to_number(_data:"exerciseprice"::text , 28 , 10)::int  as exercise_price
    , _data:"grantnumber"::text(200)                             as grant_number
    , _data:"optionplanid"::text(200)                            as option_plan_id
    , try_to_number(_data:"sharessold"::text , 28 , 10)::int     as shares_sold
    , try_to_date(_data:"firstvestdate"::text)::date             as first_vest_date
    , _data:"granttype"::text(200)                               as grant_type
    , _data:"vestingfrequency"::text(200)                        as vesting_frequency
    , _data:"accountid"::text(200)                               as account_id
    , try_to_number(_data:"vestingperiods"::text , 28 , 10)::int as vesting_periods
    , try_to_date(_data:"grantdate"::text)::date                 as grant_date

    , effective_date::date                                       as effective_date
    , _created_at::timestamp                                     as _created_at
    , _source_file::text(200)                                    as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
