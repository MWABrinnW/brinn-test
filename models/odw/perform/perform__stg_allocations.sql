WITH cte_alloc as (
	SELECT XMLGET(XML, 'Perform_SysTicketNo'):"$"::string as ID,
		XML,
		case
			when alloc.key IS NULL then value
			when alloc.key = '$' then this
			else this
		end                                        as allocation_xml,
		EFFECTIVE_DATE,
		RECORD_DATE,
		RECORD_DATETIME
    FROM {{ source('perform', 'allocations') }} AL,
         LATERAL flatten(XMLGET(XML, 'allocations'):"$") alloc
    where alloc.key IS NULL
       or alloc.key = '$'
)

SELECT
	XMLGET(XML, 'transType'):"$"::string 							AS SIDE
	,XMLGET(XML, 'CUSIP'):"$"::string 								AS CUSIP
	,REPLACE(XMLGET(XML, 'tprice'):"$", ',')::double 				AS PRICE
	,XMLGET(XML, 'tradeDate'):"$"::date 							AS TRADE_DATE
	,XMLGET(XML, 'settleDate'):"$"::date 							AS SETTLE_DATE
	,XMLGET(XML, 'dealer'):"$"::string 								AS DEALER
	,XMLGET(XML, 'dealer_DTC'):"$"::string 							AS DEALER_DTC
	,XMLGET(XML, 'Perform_SysTicketNo'):"$"::string 				AS PERFORM_SYSTICKETNO
	,XMLGET(XML, 'TicketNo'):"$"::string 							AS TICKETNO
	,XMLGET(XML, 'Desc'):"$"::string 								AS DESCRIPTION
	,case
        when XMLGET(XML, 'matureDate'):"$" = '' then NULL
        else XMLGET(XML, 'matureDate'):"$"::date
    end                                                             AS MATURE_DATE
	,case
    	when XMLGET(XML, 'coupon'):"$"= '' then NULL
        else REPLACE(XMLGET(XML, 'coupon'):"$", ',')::double
    end 															as COUPON
	,XMLGET(XML, 'sectype'):"$"::string 							AS SECURITY_TYPE
	,XMLGET(XML, 'TCreatedDt'):"$"::date 							AS CREATED_DATE
	,XMLGET(XML, 'TCreatedTime'):"$"::time 							AS CREATED_TIME
	,XMLGET(XML, 'TCreatedDt_UTC'):"$"::date 						AS CREATED_DATE_UTC
	,XMLGET(XML, 'TCreatedTime_UTC'):"$"::time 						AS CREATED_TIME_UTC
	,XMLGET(XML, 'TCreatedBy'):"$"::string 							AS CREATED_BY
	,XMLGET(XML, 'TAppliedOrigDt'):"$"::date 						AS APPLIED_DATE
	,XMLGET(XML, 'TAppliedOrigTime'):"$"::time 						AS APPLIED_TIME
	,XMLGET(XML, 'TAppliedOrigDt_UTC'):"$"::date 					AS APPLIED_DATE_UTC
	,XMLGET(XML, 'TAppliedOrigTime_UTC'):"$"::time 					AS APPLIED_TIME_UTC
	,XMLGET(XML, 'TAppliedOrigBy'):"$"::string 						AS APPLIED_BY
	,XMLGET(XML, 'TAppliedLastDt'):"$"::date 						AS APPLIED_LAST_DATE
	,XMLGET(XML, 'TAppliedLastTime'):"$"::time 						AS APPLIED_LAST_TIME
	,XMLGET(XML, 'TAppliedLastDt_UTC'):"$"::date 					AS APPLIED_LAST_DATE_UTC
	,XMLGET(XML, 'TAppliedLastTime_UTC'):"$"::time 					AS APPLIED_LAST_TIME_UTC
	,XMLGET(XML, 'TAppliedLastBy'):"$"::string 						AS APPLIED_LAST_BY
	,REPLACE(XMLGET(XML, 'quantity'):"$", ',')::double 				AS TRADE_QUANTITY
	,REPLACE(XMLGET(XML, 'principal'):"$", ',')::double 			AS TRADE_PRINCIPAL
	,REPLACE(XMLGET(XML, 'interest'):"$", ',')::double 				AS TRADE_INTEREST
	,REPLACE(XMLGET(XML, 'net_money'):"$", ',')::double 			AS TRADE_NET_MONEY
	,XMLGET(allocation_xml, 'portfolio'):"$"::string 				AS PORTFOLIO
	,XMLGET(allocation_xml, 'PortAcctNo'):"$"::string  				AS PORTFOLIO_ACCOUNT_NUMBER
	,XMLGET(allocation_xml, 'portfolio_custodian'):"$"::string  	AS PORTFOLIO_CUSTODIAN
	,XMLGET(allocation_xml, 'account_type'):"$"::string  			AS ACCOUNT_TYPE
	,REPLACE(XMLGET(allocation_xml, 'quantity'):"$", ',')::double  	AS QUANTITY
	,REPLACE(XMLGET(allocation_xml, 'principal'):"$", ',')::double 	AS PRINCIPAL
	,REPLACE(XMLGET(allocation_xml, 'interest'):"$", ',')::double  	AS INTEREST
	,REPLACE(XMLGET(allocation_xml, 'net_money'):"$", ',')::double  AS NET_MONEY
	,XMLGET(allocation_xml, 'inquiry_ID'):"$"::string  				AS INQUIRY_ID
	,XMLGET(allocation_xml, 'external_order_ID'):"$"::string  		AS EXTERNAL_ORDER_ID
	,EFFECTIVE_DATE
	,RECORD_DATE
	,RECORD_DATETIME
FROM cte_alloc
WHERE 1=1
    and account_type ilike 'aipmanaged'
    and cusip not ilike 'subetf%'
    and cusip not ilike 'mubetf%'
