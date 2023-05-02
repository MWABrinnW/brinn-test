
select
    'lpl'                                                   as custodian
  , regexp_substr(_source_file, 'DFM-(.{4})-.*', 1, 1, 'e') as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , securityid                                              as security_id
  , securitysourcecode                                      as security_source_code
  , ttssecurityid                                           as tts_security_id
  , cusip                                                   as cusip
  , securitydescription                                     as security_description
  , producttypecode                                         as product_type_code
  , sponsorid                                               as sponsor_id
  , sponsorname                                             as sponsor_name
  , symbol                                                  as symbol
  , shareclasscode                                          as share_class_code
  , securitysourcename                                      as security_source_name
  , sponsorcode                                             as sponsor_code
  , securitytypecode                                        as security_type_code
  , {{ col_is_head(reference=source('lpl_network', 'commissionsecurity')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'commissionsecurity') }}
