{% set columns = [
    'EFFECTIVE_DATE'
    , 'SYSTEM_NAME'
    , 'SYSTEM_INSTANCE'
    , 'SYSTEM_KEY'
    , 'FIRM_SOURCE'
    , 'ACCOUNT_NUMBER_FORMATTED'
    , 'ACCOUNT_NUMBER'
    , 'ACCOUNT_NUMBER_KEY'
    , 'ACCOUNT_VALUE'
    , 'ACCOUNT_ID_CRM'
    , 'ACCOUNT_ID_PMS'
    , 'ACCOUNT_NAME'
    , 'CLIENT_ID_CRM'
    , 'CLIENT_ID_PMS'
    , 'CLIENT_NAME'
    , 'CUSTODIAN'
    , 'AUM_CLASSIFICATION'
    , 'ADVISOR'
    , 'IS_ACTIVE'
    , 'OPENED_DATE'
    , 'CLOSED_DATE'
    , 'LOCATION_CODE'
    , 'PMS_LOCATION_CODE'
    , 'CRM_LOCATION_CODE'
    , 'LINK'
    , 'LINK_TYPE'
    , 'LINK_SUBTYPE'
    , 'IS_MARKET_MONTH_END'
    , 'IS_INSTITUTIONAL'
    , 'IS_DISCRETIONARY'
    , 'IS_MANUAL_ACCOUNT'
    , 'QUANTITY'
    , 'PRICE'
    , 'PRICE_UNFACTORED'
    , 'FACTOR'
    , 'COST_BASIS'
    , 'IS_MANUAL_HOLDINGS'
    , 'IS_LEGACY'
    , '_CREATED_AT'
] %}

{% set condition = 
    "is_legacy=0
    and is_manual_holdings=0
    and is_market_month_end=1" %}

{{ describe_model_stats(model=ref('holdings'), where_clause=condition, date_partition='effective_date', exclude_columns=columns) }}
