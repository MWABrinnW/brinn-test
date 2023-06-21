{% set src = source('black_diamond_ap4', 'relationship') %}

SELECT 
    'black_diamond' as pms
    , 'ap4' as pms_location
    , 'mwa' AS firm_source
    , EFFECTIVE_DATE                             AS EFFECTIVE_DATE
    , JSON:Relationship.ID::string               AS RELATIONSHIP_ID
    , JSON:Relationship.Name::string             AS RELATIONSHIP_NAME
    , JSON:Relationship.ClientTypeID::string     AS RELATIONSHIP_CLIENT_TYPE_ID
    , account.value:HistoryStartDate::date       AS HISTORY_START_DATE
    , account.value:ClosedDate::date             AS RELATIONSHIP_TERMINATION_DATE
    , account.value:Relationship::string         AS RELATIONSHIP_DISPLAY_NAME
    , portfolios.value:Id::string                AS PORTFOLIO_ID
    , portfolios.value:Name::string              AS PORTFOLIO_NAME
    , portfolios.value:DisplayName::string       AS PORTFOLIO_DISPLAY_NAME
    , account.value:ExternalID::string           AS ACCOUNT_ID
    , account.value:LongNumber::string           AS ACCOUNT_NUMBER
    , account.value:AccountDisplayNumber::string AS ACCOUNT_DISPLAY_NUMBER
    , account.value:DisplayName::string          AS ACCOUNT_NAME
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
FROM {{ src }},
     table (flatten(JSON, 'ReferencedEntities.Accounts')) AS account,
     table (flatten(JSON, 'ReferencingPortfolios')) AS portfolios