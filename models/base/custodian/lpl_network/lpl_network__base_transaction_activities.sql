
select
    accountid::int                         as account_id
  , accountlocationcode                    as account_location_code
  , to_date(transactiondate, 'MM/DD/YYYY') as transaction_date
  , lplaccountno::int                      as lpl_account_no
  , sponsoraccountno::int                  as sponsor_account_no
  , sponsorcode                            as sponsor_code
  , accountname                            as account_name
  , accounttype                            as account_type
  , activitydescription                    as activity_description
  , quantity::decimal(20, 5)               as quantity
  , price::decimal(20, 5)                  as price
  , amount::decimal(20, 2)                 as amount
  , creditdebitindicator                   as credit_debit_indicator
  , securityid::int                        as security_id
  , assetclasscode                         as asset_class_code
  , sponsorname                            as sponsor_name
  , cusip                                  as cusip
  , symbol                                 as symbol
  , securitydescription                    as security_description
  , orderno::int                           as order_no
  , effectivedate
  , sourceorder                            as source_order
  , {{ col_is_head(reference=source('lpl_network', 'transactionactivityext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                   as effective_date
  , _created_at::timestamp                 as _created_at
  , _source_file
from {{ source('lpl_network', 'transactionactivityext') }}
