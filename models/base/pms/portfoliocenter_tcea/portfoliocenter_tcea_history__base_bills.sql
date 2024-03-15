-- Replaces escape characters that are present in a header that has special characters in the source file. The resulting column is a string. 
with cte_json_replace as (
    select
        REPLACE(json , '\\"Billable\\"' , 'Billable') as json_string
        , _id::int                                    as _id
        , _created_at::timestampntz                   as _created_at
        , _box_file_id::varchar(200)                  as _box_file_id
        , _box_file_name::varchar(200)                as _box_file_name
        , _box_meta::variant                          as _box_meta
    from {{ source('portfoliocenter_tcea_raw', 'bills') }}
)

-- Converts the json column from a string to a variant. 
, cte_json as (
    select
        PARSE_JSON(json_string)::variant as json
        , _id::int                       as _id
        , _created_at::timestampntz      as _created_at
        , _box_file_id::varchar(200)     as _box_file_id
        , _box_file_name::varchar(200)   as _box_file_name
        , _box_meta::variant             as _box_meta
    from cte_json_replace
)

select
    'portfoliocenter'::varchar(200)                              as system_name
    , 'tcea'::varchar(200)                                       as system_instance
    , CONCAT(system_name , '__' , system_instance)::varchar(200) as system_key
    , 'mwa'::varchar(200)                                        as firm_source
    , json:"Billable Value"::number(20 , 5)                      as billable_value
    , json:"Account Code"::varchar(200)                          as account_code
    , json:"Account Number"::varchar(200)                        as account_number
    , json:"Amount"::number(20 , 5)                              as amount
    , json:"Collected"::date                                     as collected
    , json:"Custodian"::varchar(200)                             as custodian
    , json:"Date"::date                                          as date
    , json:"Notes"::varchar(200)                                 as notes
    , json:"Portfolio Description"::varchar(200)                 as portfolio_description
    , _id::int                                                   as _id
    , _created_at::timestampntz                                  as _created_at
    , _box_file_id::varchar(200)                                 as _box_file_id
    , _box_file_name::varchar(200)                               as _box_file_name
    , _box_meta::variant                                         as _box_meta
from cte_json
where json:"Account Number" is not null
