{% set columns = [
    'EFFECTIVE_DATE'
    , 'SYSTEM_NAME'
    , 'SYSTEM_INSTANCE'
    , 'SYSTEM_KEY'
    , 'ACCOUNT_NUMBER_FORMATTED'
    , 'ACCOUNT_NUMBER'
    , 'ACCOUNT_ID_CRM'
    , 'ACCOUNT_ID_PMS'
    , 'ACCOUNT_NAME'
    , 'CLIENT_ID_CRM'
    , 'CLIENT_ID_PMS'
    , 'CLIENT_NAME'
    , 'FEE_SCHEDULE'
    , 'IS_INSTITUTIONAL'
    , 'IS_MARKET_DAY'
    , 'IS_MARKET_MONTH_END'
    , 'IS_MANUAL_ACCOUNT'
    , 'IS_LEGACY'
    , '_SOURCE_LOADED_AT'
    , '_CREATED_AT'
    , '_EXTRA_FIELDS'
] %}

{% set condition = 
    "is_legacy=0
    and is_manual_account=0
    and is_market_month_end=1" %}

{{ describe_model_stats(model=ref('accounts'), where_clause=condition, date_partition='effective_date', exclude_columns=columns) }}
