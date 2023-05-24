
select
    'lpl'                                                   as custodian
  , regexp_substr(_source_file, 'DFM-(.{4})-.*', 1, 1, 'e') as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , securityid::varchar(200)                                as security_id
  , securitysourcecode::varchar(200)                        as security_source_code
  , ttssecurityid::varchar(200)                             as tts_security_id
  , cusip::varchar(200)                                     as cusip
  , securitydescription::varchar(200)                       as security_description
  , producttypecode::varchar(200)                           as product_type_code
  , sponsorid::varchar(200)                                 as sponsor_id
  , sponsorname::varchar(200)                               as sponsor_name
  , symbol::varchar(200)                                    as symbol
  , shareclasscode::varchar(200)                            as share_class_code
  , securitysourcename::varchar(200)                        as security_source_name
  , sponsorcode::varchar(200)                               as sponsor_code
  , securitytypecode::varchar(200)                          as security_type_code
  , {{ col_is_head(reference=source('lpl_network', 'commissionsecurity')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'commissionsecurity') }}
