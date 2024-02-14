SELECT
	PERFORM_SYSTICKETNO							                                AS order_id
	,TRADE_DATE									                                AS trade_date
	,SETTLE_DATE								                                AS settle_date
	,CUSIP										                                AS cusip
	,SECURITY_TYPE								                                AS source_security_type
	,DESCRIPTION								                                AS source_security_description
	,SIDE										                                AS order_side
	,'LONG'          							                                AS order_effect
	,QUANTITY									                                AS units
	,PRICE										                                AS unit_price
	,PRINCIPAL									                                AS principal
	,INTEREST									                                AS interest
	,NET_MONEY									                                AS net
	,PORTFOLIO_ACCOUNT_NUMBER					                                AS financial_account
	,PORTFOLIO_CUSTODIAN						                                AS custodian
	,DEALER										                                AS broker_name
	,DEALER_DTC 								                                AS broker_id
	,ACCOUNT_TYPE																AS owner
	,CASE WHEN broker_name != custodian THEN True ELSE False END				AS trade_away
	,'MWA' 								                                        AS firm
	,'MWA - Fixed Income'        				                                AS venue
	,'Perform'          						                                AS platform
	,CREATED_BY									                                AS trader
	,(CREATED_DATE_UTC::string || ' ' || CREATED_TIME_UTC::string)::timestamp	AS trade_start_utc
	,(APPLIED_DATE_UTC::string || ' ' || APPLIED_TIME_UTC::string)::timestamp	AS trade_end_utc
	,(CREATED_DATE::string || ' ' || CREATED_TIME::string)::timestamp			AS source_trade_datetime
	,'Central'       							                                AS source_trade_tz
	,RECORD_DATE 								                                AS record_date
	,RECORD_DATETIME							                                AS record_datetime
FROM {{ ref('perform__stg_allocations') }}
WHERE owner != 'Sample'
