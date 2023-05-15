select
    'lpl'                                                   as custodian
  , subscriberid                                            as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , repid                                                   as rep_id
  , accountid                                               as account_id
  , lplaccountno                                            as account_number
  , securityid                                              as security_id
  , price                                                   as price
  , quantity                                                as quantity
  , positionvalue                                           as position_value
  , positionvaluedate                                       as position_value_date
  , sponsoraccountno                                        as sponsor_account_no
  , sponsorcode                                             as sponsor_code
  , sponsorname                                             as sponsor_name
  , symbol                                                  as symbol
  , cusip                                                   as cusip
  , enhancedreportingproductgroupcode                       as enhanced_reporting_product_group_code
  , accountlocationcode                                     as account_location_code
  , {{ col_is_head(reference=source('lpl_network', 'position')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'position') }}
