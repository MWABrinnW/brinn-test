
select
    'lpl'                                                   as custodian
  , regexp_substr(_source_file, 'DFM-(.{4})-.*', 1, 1, 'e') as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , accountid::int                                          as account_id
  , accountlocationcode                                     as account_location_code
  , to_date(transactiondate, 'MM/DD/YYYY')                  as transaction_date
  , lplaccountno::text(50)                                  as account_number
  , sponsoraccountno::text(50)                              as sponsor_account_no
  , sponsorcode                                             as sponsor_code
  , accountname                                             as account_name
  , accounttype                                             as account_type
  , activitydescription                                     as activity_description
  , quantity::decimal(20, 5)                                as quantity
  , price::decimal(20, 5)                                   as price
  , amount::decimal(20, 2)                                  as amount
  , creditdebitindicator                                    as credit_debit_indicator
  , securityid::text(50)                                    as security_id
  , assetclasscode                                          as asset_class_code
  , sponsorname                                             as sponsor_name
  , cusip                                                   as cusip
  , symbol                                                  as symbol
  , securitydescription                                     as security_description
  , orderno::text(50)                                       as order_no
  , effectivedate                                           as effectivedate
  , sourceorder                                             as source_order
  , {{ col_is_head(reference=source('lpl_network', 'transactionactivityext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'transactionactivityext') }}
