
   select
       value:c1::string         as symbol,
       value:c2::string         as security_type,
       value:c3::date           as date,
       value:c4::decimal(19, 6) as price,
       value:c5::string         as factor,
       case when effective_date::date = (select max(effective_date::date) from {{ source('tda_mwa', 'prices') }}) then 1 else 0 end as is_current,
       effective_date::date     as effective_date,
       file_type::string        as file_type
   from {{ source('tda_mwa', 'prices') }}