select
    json:id::int                                      as contact_id
  , json:type::varchar(200)                           as business
  , json:first_name::varchar(200)                     as first_name
  , json:middle_name::varchar(200)                    as middle_name
  , json:last_name::varchar(200)                      as last_name
  , json:company_name::varchar(200)                   as company_name
  , json:full_name::varchar(200)                      as full_name
  , json:nickname::varchar(200)                       as nickname
  , json:suffix_id::int                               as suffix_id
  , json:suffix::varchar(200)                         as suffix
  , json:job_title::varchar(200)                      as job_title
  , json:favorite::varchar(200)                       as favorite
  , json:pronouns::varchar(200)                       as pronouns
  , json:deleted::int                                 as is_deleted
  , json:created_at::timestamp                        as created_at
  , json:updated_at::timestamp                        as updated_at
  , json:salutation_id::int                           as salutation_id
  , json:salutation::varchar(200)                     as salutation
  , json:source_id::int                               as source_id
  , json:source::varchar(200)                         as source
  , json:status_id::int                               as status_id
  , json:status::varchar(200)                         as status
  , json:category_id::int                             as category_id
  , json:category::varchar(200)                       as category
  , json:gender_id::int                               as gender_id
  , json:gender::varchar(200)                         as gender
  , json:gender_description::varchar(200)             as gender_description
  , json:spouse_name::varchar(200)                    as spouse_name
  , json:tax_id::varchar(200)                         as tax_id
  , try_to_date(json:dob::text)                       as dob
  , try_to_date(json:death_date::text)                as death_date
  , json:client_since::timestamp                      as client_since
  , json:client_termination_date::date                as client_termination_date
  , json:marital_status_id::int                       as marital_status_id
  , json:marital_status::varchar(200)                 as marital_status
  , json:marital_date::date                           as marital_date
  , json:employer_id::int                             as employer_id
  , json:employer::varchar(200)                       as employer
  , json:designation::varchar(200)                    as designation
  , json:referred_by::varchar(200)                    as referred_by
  , json:servicing_advisor_id::int                    as servicing_advisor_id
  , json:servicing_advisor::varchar(200)              as servicing_advisor
  , json:writing_advisor_id::int                      as writing_advisor_id
  , json:writing_advisor::varchar(200)                as writing_advisor
  , json:added_by::int                                as added_by
  , json:family::variant                              as family
--   , json:important_information:id::int                as important_information_id
--   , json:important_information:content::varchar(10000)as important_information_content
--   , json:important_information:created_at::timestamp  as important_information_created_at
--   , json:important_information:updated_at::timestamp  as important_information_updated_at

  , json:addresses::variant                           as addresses
  , json:phones::variant                              as phones
  , json:emails::variant                              as emails
  , json:urls::variant                                as urls
  , json:tag_memberships::variant                     as tag_memberships

  , {{ col_is_head(reference=source('redtail_network', 'contacts'), reference_date_col='_effective_at::date', source_date_col='_effective_at::date') }}

  , _effective_at::timestamp_ltz                      as effective_at
  , _created_at::timestamp_ltz                        as _source_loaded_at
  , _source_file::varchar(200)                        as _source_file
from {{ source('redtail_network', 'contacts') }}