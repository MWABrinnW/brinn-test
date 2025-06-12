{% macro cvar(var_name) -%}

    {%-
        set all_project_vars = {
            'force_create_policies': var('force_create_policies', false),
            'offset': var('offset', '0'),
            'lookback': var('lookback', 40 if target.name == 'prod' else 7),
            'start_date_orion': var('start_date_orion','2022-12-31'),
            'start_date_custodian': var('start_date_custodian', '2023-12-31'),
            'start_date_pms': var('start_date_pms', '2023-01-01'),
            'custodian_accounts_nml_column_list': [
                "EFFECTIVE_DATE", "CUSTODIAN", "FIRM", "FIRM_SOURCE", "ACCOUNT_NUMBER", "ACCOUNT_NUMBER_FORMATTED",
                "CUSTODIAN_LINK", "CUSTODIAN_LINK_DETAIL", "REP_LINK", "REP_LINK_DETAIL", "ACCOUNT_TYPE",
                "ACCOUNT_TYPE_SOURCE_DEFINITION", "ACCOUNT_TYPE_SOURCE_CODE", "OPENED_DATE", "ACCOUNT_TITLE", "FIRST_NAME",
                "MIDDLE_NAME", "LAST_NAME", "IRS_ID", "IRS_ID_TYPE", "BIRTH_DATE", "EMAIL_ADDRESS", "PHONE",
                "COST_BASIS_METHOD_MUTUAL_FUNDS", "COST_BASIS_METHOD_NON_MUTUAL_FUNDS", "IS_TAXABLE", "IS_FEE_AUTHORIZED",
                "IS_PRIME_BROKER", "IS_MARGIN_ENABLED", "OPTIONS_APPROVAL_LEVEL", "RESTRICTIONS_SOURCE_CODE",
                "IS_MULTIPLE_MARGIN_ENABLED", "RESTRICTIONS_SOURCE_DEFINITION", "RESTRICTIONS", "MAILING_ADDRESS_STREET",
                "MAILING_ADDRESS_CITY", "MAILING_ADDRESS_STATE", "MAILING_ADDRESS_ZIP", "MAILING_ADDRESS_COUNTRY",
                "LEGAL_ADDRESS_STREET", "LEGAL_ADDRESS_CITY", "LEGAL_ADDRESS_STATE", "LEGAL_ADDRESS_ZIP", "LEGAL_ADDRESS_COUNTRY",
                "_CREATED_AT", "_SOURCE_LOADED_AT", "_SOURCE_FILE"
            ],
            'pms_accounts_nml_column_list': [
                'EFFECTIVE_DATE', 'SYSTEM_NAME', 'SYSTEM_INSTANCE', 'SYSTEM_KEY', 'FIRM_SOURCE','ACCOUNT_NUMBER_FORMATTED',
                'ACCOUNT_NUMBER', 'PMS_ACCOUNT_NUMBER', 'PMS_CUSTODIAN', 'PMS_ACCOUNT_ID', 'PMS_ACCOUNT_TYPE', 'PMS_ACCOUNT_NAME',
                'PMS_REGISTRANT_NAME', 'PMS_CLIENT_ID', 'PMS_CLIENT_NAME', 'PMS_IS_ACTIVE', 'PMS_CREATED_DATE', 'PMS_OPENED_DATE',
                'PMS_CLOSED_DATE', 'PMS_ACCOUNT_VALUE', 'PMS_ADVISOR', 'PMS_ADVISOR_ID', 'PMS_ADVISOR_ID_SOURCE',
                'PMS_ADVISOR_EMAIL', 'PMS_LOCATION_CODE', 'PMS_FEE_SCHEDULE', 'PMS_MODEL_INVESTMENT_STRATEGY',
                'PMS_AUM_CLASSIFICATION', 'PMS_IS_ERISA', 'PMS_IS_DISCRETIONARY', 'PMS_IS_VOTING_PROXIED', 'PMS_IS_PRIME_BROKER',
                'PMS_IS_BROKER_DEALER_ACCOUNT', 'PMS_COST_BASIS_METHOD', 'CRM', 'CRM_INSTANCE_LOCATION', 'CRM_KEY',
                'CRM_CUSTODIAN', 'CRM_ACCOUNT_ID', 'CRM_ACCOUNT_TYPE', 'CRM_ACCOUNT_NAME', 'CRM_REGISTRANT_NAME', 'CRM_CLIENT_ID',
                'CRM_CLIENT_NAME', 'CRM_IS_ACTIVE', 'CRM_CREATED_DATE', 'CRM_OPENED_DATE', 'CRM_CLOSED_DATE', 'CRM_ACCOUNT_VALUE',
                'CRM_ADVISOR', 'CRM_ADVISOR_ID', 'CRM_ADVISOR_ID_SOURCE', 'CRM_ADVISOR_EMAIL', 'CRM_LOCATION_CODE',
                'CRM_FEE_SCHEDULE', 'CRM_MODEL_INVESTMENT_STRATEGY', 'CRM_AUM_CLASSIFICATION', 'CRM_IS_ERISA',
                'CRM_IS_DISCRETIONARY', 'CRM_IS_VOTING_PROXIED', 'CRM_IS_PRIME_BROKER', 'CRM_IS_BROKER_DEALER_ACCOUNT',
                'CUSTODIAN', 'ACCOUNT_TYPE', 'ACCOUNT_NAME', 'REGISTRANT_NAME', 'CLIENT_NAME', 'IS_ACTIVE', 'CREATED_DATE',
                'OPENED_DATE', 'CLOSED_DATE', 'ACCOUNT_VALUE', 'ADVISOR', 'ADVISOR_ID', 'ADVISOR_ID_SOURCE', 'ADVISOR_EMAIL',
                'LOCATION_CODE', 'FEE_SCHEDULE', 'MODEL_INVESTMENT_STRATEGY', 'AUM_CLASSIFICATION', 'IS_ERISA',
                'IS_DISCRETIONARY', 'IS_VOTING_PROXIED', 'IS_PRIME_BROKER', 'IS_BROKER_DEALER_ACCOUNT',
                'SYSTEM_KEY__ACCOUNT_NAME', 'SYSTEM_KEY__ACCOUNT_NUMBER', 'SYSTEM_KEY__ADVISOR', 'ADVISOR__ACCOUNT_NUMBER',
                '__ACCOUNT_KEY', '__CUSTODIAN_KEY', 'PREF_ADVISOR__ACCOUNT_NUMBER', 'PREF_ADVISOR', 'PREF_LOCATION',
                'PREF_SYSTEM_KEY', 'DEDUPE_SYSTEM_RN', 'DEDUPE_SYSTEM_COUNT', 'HAS_DUPES', 'EXCLUDED_REASONS', 'IS_EXCLUDED',
                '_EXTRA_FIELDS', '_SOURCE_LOADED_AT', '_SOURCE_FILE'
            ],
            'billing_wealth_column_list': [
                'system_name'
                , 'system_instance'
                , 'system_key'
                , 'firm_source'
                , 'location_code'
                , 'office_name'
                , 'client_location_code'
                , 'client_office_name'
                , 'invoice_created_at'
                , 'invoice_date'
                , 'revenue_period_end_date'
                , 'revenue_quarter_end_date'
                , 'invoice_number_source'
                , 'billing_statement_id_source'
                , 'billing_statement_id_crm'
                , 'invoice_status'
                , 'is_intra_period_invoice'
                , 'account_number'
                , 'account_number_formatted'
                , 'billing_account_number'
                , 'account_id_pms'
                , 'registrant_name'
                , 'account_name'
                , 'type_of_account'
                , 'client_id_pms'
                , 'aum_classification_status'
                , 'model_investment_strategy'
                , 'model_grouping_assignment'
                , 'custodian'
                , 'billing_custodian'
                , 'partner_firm'
                , 'partner_firm_original'
                , 'advisor_source'
                , 'advisor_original'
                , 'associate_id_original'
                , 'advisor_primary'
                , 'associate_id_primary'
                , 'advisor_type'
                , 'advisor'
                , 'associate_id'
                , 'fee_type'
                , 'fee_schedule_source'
                , 'assets_as_of_date'
                , 'fee_calculation_date'
                , 'effective_fee_rate'
                , 'total_account_value'
                , 'billable_value'
                , 'fee_excluded_assets'
                , 'client_fee_gross'
                , 'client_fee_rebates'
                , 'client_net_contribution_fee'
                , 'client_adjustments_fee'
                , 'client_write_off_fee'
                , 'client_fee_net'
                , 'referral_fee'
                , 'collection_date'
                , 'third_party_calculation'
                , 'billing_style'
                , 'billing_frequency'
                , 'billing_method'
                , 'bill_on_balance_type'
                , 'payment_terms'
                , 'payment_method_fee'
                , 'account_class'
                , 'recurring_revenue'
                , 'impacted_by_financial_markets'
                , 'coa_segment_1_legal_entity_id'
                , 'coa_segment_2_product_id'
                , 'coa_segment_3_accounting_id'
                , 'coa_segment_4_team_id'
                , 'coa_segment_5_natural_account_id'
                , 'coa_segment_6_initiative_id'
                , 'coa_segment_7_intercompany_id'
                , 'coa_segment_8_future_id'
                , 'coa_account_number'
                , 'revenue_category'
                , 'revenue_type'
                , 'system_name_crm'
                , 'system_instance_crm'
                , 'system_key_crm'
                , 'account_id_crm'
                , 'client_id_crm'
                , 'client_id_original_crm'
                , 'client_id_unique_compass'
                , 'client_name'
                , 'client_name_original_crm'
                , 'client_lead_source'
                , 'client_key_tags_crm'
                , 'transaction_type'
                , 'transaction_line_type'
                , 'transaction_line_quantity'
                , 'currency_code'
                , 'currency_conversion_type'
                , 'unit_selling_price'
                , 'excluded_reasons'
                , 'is_excluded'
                , '_invoice_key'
                , '_source_loaded_at'
                , '_source_file'
                , '_box_file_id'
                , '_extra_fields'
                , '_created_at'
            ],
            'billing_wealth_nml_column_list': [
                'system_name'
                , 'system_instance'
                , 'system_key'
                , 'firm_source'
                , 'client_location_code'
                , 'invoice_created_at'
                , 'invoice_date'
                , 'revenue_period_end_date'
                , 'invoice_number_source'
                , 'billing_statement_id_source'
                , 'billing_statement_id_crm'
                , 'invoice_status'
                , 'is_intra_period_invoice'
                , 'account_number'
                , 'account_number_formatted'
                , 'billing_account_number'
                , 'account_id_pms'
                , 'registrant_name'
                , 'account_name'
                , 'type_of_account'
                , 'client_id_pms'
                , 'aum_classification_status'
                , 'model_investment_strategy'
                , 'custodian'
                , 'billing_custodian'
                , 'partner_firm'
                , 'partner_firm_original'
                , 'advisor_source'
                , 'advisor_original'
                , 'associate_id_original'
                , 'advisor_primary'
                , 'associate_id_primary'
                , 'advisor_type'
                , 'fee_type'
                , 'fee_schedule_source'
                , 'assets_as_of_date'
                , 'fee_calculation_date'
                , 'effective_fee_rate'
                , 'total_account_value'
                , 'billable_value'
                , 'fee_excluded_assets'
                , 'client_fee_gross'
                , 'client_fee_rebates'
                , 'client_net_contribution_fee'
                , 'client_adjustments_fee'
                , 'client_write_off_fee'
                , 'client_fee_net'
                , 'referral_fee'
                , 'collection_date'
                , 'third_party_calculation'
                , 'billing_style'
                , 'billing_frequency'
                , 'billing_method'
                , 'bill_on_balance_type'
                , 'payment_terms'
                , 'payment_method_fee'
                , 'account_class'
                , 'coa_segment_1_legal_entity_id'
                , 'coa_segment_3_accounting_id'
                , 'coa_segment_4_team_id'
                , 'coa_segment_5_natural_account_id'
                , 'revenue_category'
                , 'revenue_type'
                , 'system_name_crm'
                , 'system_instance_crm'
                , 'system_key_crm'
                , 'account_id_crm'
                , 'client_id_crm'
                , 'client_id_original_crm'
                , 'client_id_unique_compass'
                , 'client_name'
                , 'client_name_original_crm'
                , 'client_lead_source'
                , 'client_key_tags_crm'
                , 'transaction_type'
                , 'transaction_line_type'
                , 'transaction_line_quantity'
                , 'currency_code'
                , 'currency_conversion_type'
                , 'unit_selling_price'
                , 'excluded_reasons'
                , 'is_excluded'
                , '_source_loaded_at'
                , '_source_file'
                , '_box_file_id'
                , '_extra_fields'
            ],
            'pms_holdings_nml_column_list': [
                'effective_date', 'system_name', 'system_instance', 'system_key', 'firm_source', 'account_id',
                'account_number_formatted', 'account_number', 'client_id', 'client_name', 'custodian', 'cusip', 'ticker',
                'is_ticker_cusip', 'is_custodial_cash', 'security_id', 'security_name', 'security_type', 'security_subtype',
                'asset_class', 'market_value', 'quantity', 'price', 'price_unfactored', 'factor', 'cost_basis', 'is_legacy',
                'is_manual_holdings', '_created_at', '_source_loaded_at', '_source_file'
            ]
        }
    -%}

    {{ return(all_project_vars[var_name]) }}

{%- endmacro %}