{% set src = source('pontera', 'clients') %}
select
    _data:"city"::text(200)                     as city
    , _data:"zip"::int                          as zip
    , _data:"first name"::text(200)             as first_name
    , _data:"ssn"::text(200)                    as ssn
    , _data:"firm id"::text(200)                as firm_id
    , _data:"rep code"::text(200)               as rep_code
    , _data:"last name"::text(200)              as last_name
    , _data:"client id"::int                    as client_id
    , _data:"state"::text(200)                  as state
    , _data:"organization client id"::text(200) as organization_client_id

    , effective_date::date                      as effective_date
    , _created_at::timestamp                    as _created_at
    , _source_file::text(200)                   as _source_file
    , dense_rank() over (
        partition by effective_date order by _created_at desc
    )                                           as is_head_for_day
    , case
        when is_head_for_day = 1
            and effective_date = (select max(effective_date) from {{ src }})
            then 1
        else 0
    end::int                                    as is_head
from {{ src }}
