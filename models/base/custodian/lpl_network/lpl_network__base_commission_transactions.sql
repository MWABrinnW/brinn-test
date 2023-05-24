
select
    'lpl'                                                   as custodian
  , subscriberid::varchar(5)                                as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , transactionid::varchar(200)                             as transaction_id
  , subscriberid::varchar(200)                              as subscriber_id
  , accountid::int                                          as account_id
  , lplaccountno::text(50)                                  as account_number
  , primaryrepid::varchar(200)                              as primary_rep_id
  , primaryrepname::varchar(200)                            as primary_rep_name
  , payeerepid::varchar(200)                                as payee_rep_id
  , commissiontypecode::varchar(200)                        as commission_type_code
  , batchno::int                                            as batch_no
  , lineno::int                                             as line_no
  , producttypecode::varchar(200)                           as product_type_code
  , securityid::varchar(200)                                as security_id
  , to_date(tradedate, 'MM/DD/YYYY')                        as trade_date
  , to_date(settledate, 'MM/DD/YYYY')                       as settle_date
  , buysellindicatorcode::varchar(200)                      as buy_sell_indicator_code
  , quantity::decimal(15, 3)                                as quantity
  , price::decimal(15, 5)                                   as price
  , grosstransactionamount::decimal(15, 2)                  as gross_transaction_amount
  , grosscommissionamount::decimal(15, 2)                   as gross_commission_amount
  , reppayoutpercentage::decimal(6, 3)                      as rep_payout_percentage
  , repadjustednetamount::decimal(15, 2)                    as rep_adjusted_amount
  , repnetamount::decimal(15, 2)                            as rep_net_amount
  , fisbranchid::varchar(200)                               as fis_branch_id
  , fisbranchname::varchar(200)                             as fis_branch_name
  , secondaryrepid::varchar(200)                            as secondary_rep_id
  , insidesalesamount::decimal(15, 2)                       as inside_sales_amount
  , outsidesalesamount::decimal(15, 2)                      as outside_sales_amount
  , repinvestedsplitamount::decimal(15, 2)                  as rep_invested_split_amount
  , repgrosscommissionsplitamount::decimal(15, 2)           as rep_gross_commission_split_amount
  , moneysourcedescription::varchar(200)                    as money_source_description
  , referralid::varchar(200)                                as referral_id
  , lplpaycycle::varchar(200)                               as lpl_pay_cycle
  , ticketchargeamount::decimal(15, 2)                      as ticket_charge_amount
  , floorchargeamount::decimal(15, 2)                       as floor_charge_amount
  , enhancedreportingproductgroupcode::varchar(200)         as enhanced_reporting_product_group_code
  , employeeindicator::varchar(200)                         as employee_indicator
  , adjustmenttypecode::varchar(200)                        as adjustment_type_code
  , splitpercentage::decimal(6, 3)                          as split_percentage
  , to_date(posteddate, 'MM/DD/YYYY')                       as posted_date
  , to_date(updateddate, 'MM/DD/YYYY')                      as updated_date
  , istrail::int                                            as is_trail
  , cusip::varchar(200)                                     as cusip
  , commissionaccountno::varchar(200)                       as commission_account_no
  , clientssntin::varchar(200)                              as client_ssn_tin
  , secondaryrepname::varchar(200)                          as secondary_rep_name
  , moneysourcecomments::varchar(200)                       as money_source_comments
  , productid::varchar(200)                                 as product_id
  , clientname::varchar(200)                                as client_name
  , trailrepid::varchar(200)                                as trail_rep_id
  , {{ col_is_head(reference=source('lpl_network', 'commissiontransactionext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'commissiontransactionext') }}
