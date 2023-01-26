
select
    transactionid                                 as transaction_id
  , subscriberid                                  as subscriber_id
  , accountid::int                                as account_id
  , lplaccountno::int                             as lpl_account_no
  , primaryrepid                                  as primary_rep_id
  , primaryrepname                                as primary_rep_name
  , payeerepid                                    as payee_rep_id
  , commissiontypecode                            as commission_type_code
  , batchno::int                                  as batch_no
  , lineno::int                                   as line_no
  , producttypecode                               as product_type_code
  , securityid                                    as security_id
  , to_date(tradedate, 'MM/DD/YYYY')              as trade_date
  , to_date(settledate, 'MM/DD/YYYY')             as settle_date
  , buysellindicatorcode                          as buy_sell_indicator_code
  , quantity::decimal(15, 3)                      as quantity
  , price::decimal(15, 5)                         as price
  , grosstransactionamount::decimal(15, 2)        as gross_transaction_amount
  , grosscommissionamount::decimal(15, 2)         as gross_commission_amount
  , reppayoutpercentage::decimal(6, 3)            as rep_payout_percentage
  , repadjustednetamount::decimal(15, 2)          as rep_adjusted_amount
  , repnetamount::decimal(15, 2)                  as rep_net_amount
  , fisbranchid                                   as fis_branch_id
  , fisbranchname                                 as fis_branch_name
  , secondaryrepid                                as secondary_rep_id
  , insidesalesamount::decimal(15, 2)             as inside_sales_amount
  , outsidesalesamount::decimal(15, 2)            as outside_sales_amount
  , repinvestedsplitamount::decimal(15, 2)        as rep_invested_split_amount
  , repgrosscommissionsplitamount::decimal(15, 2) as rep_gross_commission_split_amount
  , moneysourcedescription                        as money_source_description
  , referralid                                    as referral_id
  , lplpaycycle                                   as lpl_pay_cycle
  , ticketchargeamount::decimal(15, 2)            as ticket_charge_amount
  , floorchargeamount::decimal(15, 2)             as floor_charge_amount
  , enhancedreportingproductgroupcode             as enhanced_reporting_product_group_code
  , employeeindicator                             as employee_indicator
  , adjustmenttypecode                            as adjustment_type_code
  , splitpercentage::decimal(6, 3)                as split_percentage
  , to_date(posteddate, 'MM/DD/YYYY')             as posted_date
  , to_date(updateddate, 'MM/DD/YYYY')            as updated_date
  , istrail::int                                  as is_trail
  , cusip                                         as cusip
  , commissionaccountno                           as commission_account_no
  , clientssntin                                  as client_ssn_tin
  , secondaryrepname                              as secondary_rep_name
  , moneysourcecomments                           as money_source_comments
  , productid                                     as product_id
  , clientname                                    as client_name
  , trailrepid                                    as trail_rep_id
  , {{ col_is_head(reference=source('lpl_network', 'commissiontransactionext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                          as effective_date
  , _created_at::timestamp                        as _created_at
  , _source_file                                  as _source_file
from {{ source('lpl_network', 'commissiontransactionext') }}
