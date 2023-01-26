
-- find the most recent record_datetime for each survey_name as a map
with survey_targets  as (select
                             survey_data:survey: name::string as name
                           , max(record_datetime)             as record_datetime
                         from {{ source('culture_amp', 'survey') }}
                         group by survey_data:survey: name)
   ,
-- use the map of most recent surveys by name to extract the survey question definition for each most recent instance
    survey_questions as (select
                             survey_data
                           , data.record_datetime
                         from {{ source('culture_amp', 'survey') }} data
                         inner join survey_targets map
                                        on (data.survey_data:survey: name::string = map.name and
                                            data.record_datetime = map.record_datetime))
   ,
-- extract and flatten all the survey data
    survey_data      as (select
                             d.value: email::string                         as email
                           , d.value:employee_id::number                    as employee_id
                           , to_timestamp_ntz(d.value:submitted_at::string) as submitted_at
                           , record_datetime
                           , b.key::string                                  as question_id
                           , b.value::string                                as response_raw
                           , c.value::string                                as response_flat
                           , coalesce(response_flat, response_raw)          as response
                           , survey_id
                           , record_date
                           , survey_name
                         from (select
                                   survey_data:responses           as data
                                 , survey_data:survey:name::string as survey_name
                                 , record_datetime
                                 , survey_id
                                 , record_date
                               from {{ source('culture_amp', 'survey') }})    r
                            , lateral flatten(input =>r.data)                 d
                            , lateral flatten(input =>d.value:answers)        b
                            , lateral flatten(input =>b.value, outer => true) c)
   ,
-- build a column map
    column_data      as (select distinct
                             key
                           , value:label::string as question_text
                         from survey_questions, lateral flatten(input => survey_data:questions))
   , response_data   as (select distinct
                             c.key           as response_id
                           , c.value::string as response_text
                         from survey_questions                                 a
                            , lateral flatten(input =>a.survey_data:questions) b
                            , lateral flatten(input =>b.value:select_options)  c)

select
    survey_id
  , survey_name
  , email
  , employee_id
  , question_id
  , question_text
  , coalesce(response_text, response) as response
  , submitted_at
  , record_date
  , record_datetime
from survey_data
left join column_data
              on survey_data.question_id = column_data.key
left join response_data
              on survey_data.response = response_data.response_id
order by email asc, question_id asc, record_datetime asc
