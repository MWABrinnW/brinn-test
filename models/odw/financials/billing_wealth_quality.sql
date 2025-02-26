{% set columns = [
    'SYSTEM_KEY',
    'SYSTEM_NAME',
    'SYSTEM_INSTANCE',
    'ACCOUNT_NUMBER',
    'ACCOUNT_NUMBER_FORMATTED',
    'BILLING_ACCOUNT_NUMBER',
    'ACCOUNT_ID_PMS',
    'REGISTRANT_NAME',
    'ACCOUNT_NAME',
    'TYPE_OF_ACCOUNT',
    'CLIENT_ID_PMS',
    'AUM_CLASSIFICATION_STATUS',
    'CUSTODIAN',
    'PARTNER_FIRM_ORIGINAL',
    'ASSOCIATE_ID',
    'FEE_SCHEDULE_TYPE',
    'FEE_SCHEDULE',
    'ASSETS_AS_OF_DATE',
    'FEE_CALCULATION_DATE',
    'EFFECTIVE_FEE_RATE',
    'TOTAL_ACCOUNT_VALUE',
    'BILLABLE_VALUE',
    'FEE_EXCLUDED_ASSETS',
    'CLIENT_FEE_REBATES',
    'CLIENT_NET_CONTRIBUTION_FEE',
    'ADVISOR_TYPE',
    'CLIENT_ADJUSTMENTS_FEE',
    'CLIENT_WRITE_OFF_FEE',
    'THIRD_PARTY_CALCULATION',
    'BILLING_METHOD',
    'PAYMENT_TERMS',
    'PAYMENT_METHOD_FEE',
    'ACCOUNT_CLASS',
    'SYSTEM_NAME_CRM',
    'SYSTEM_INSTANCE_CRM',
    'SYSTEM_KEY_CRM',
    'ACCOUNT_ID_CRM',
    'CLIENT_ID_CRM',
    'CLIENT_ID_ORIGINAL_CRM',
    'CLIENT_ID_UNIQUE_COMPASS',
    'CLIENT_NAME',
    'CLIENT_NAME_ORIGINAL_CRM',
    'TRANSACTION_LINE_TYPE',
    'TRANSACTION_LINE_QUANTITY',
    'CURRENCY_CODE',
    'CURRENCY_CONVERSION_TYPE',
    'UNIT_SELLING_PRICE',
    '_SOURCE_FILE',
    '_BOX_FILE_ID',
    '_CREATED_AT',
    '_EXTRA_FIELDS'
] %}

{% set condition = "a.system_key in (
        'addepar__corbenic'
        , 'black_diamond__houston'
        , 'black_diamond__uhnw'
        , 'sei__manasquan'
        , 'envestnet__manasquan'
    )
    or (
        a.system_key = 'salesforce__compass' and (a._extra_fields['is_cpg'] = 0)
    )" %}

{{ describe_billing_model(model=ref('bld_billing_wealth'), where_clause=condition, date_partition='revenue_period_end_date', exclude_columns=columns) }}
