select
    case
        when nvl(json:start_date, '1900-01-01') in ('1900-01-01', '2199-12-31')
            then null
        else json:start_date
        end::date                                as start_date
  , case
        when nvl(json:end_date, '1900-01-01') in ('1900-01-01', '2199-12-31')
            then null
        else json:end_date
        end::date                                as end_date
  , json:active::int                             as active
  , json:general_access::int                     as general_access
  , json:location_code::varchar(25)              as location_code
  , json:division::varchar(300)                  as division
  , json:legal_name::varchar(300)                as legal_name
  , json:region_name::varchar(300)               as region_name
  , json:market_name::varchar(300)               as market_name
  , json:location_name::varchar(300)             as location_name
  , json:office_name::varchar(300)               as office_name
  , json:location_city::varchar(300)             as location_city
  , json:location_state::varchar(100)            as location_state
  , json:accounting_id::varchar(100)             as accounting_id
  , json:accounting_id_description::varchar(200) as accounting_id_description
  , json:acquisition_name::varchar(300)          as acquisition_name
  , json:acquisition_type::varchar(300)          as acquisition_type
  , {{ col_is_head(reference=source('aux', 'locations'), reference_date_col='_created_at', source_date_col='_created_at') }}
  , _created_at::timestamp                       as _created_at
from {{ source('aux', 'locations') }}
where json:dataset = 'locations'
    and json:location_code::text is not null
