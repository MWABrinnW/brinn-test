SELECT
        g.value:name::string                    AS name
        ,g.value:description::string            AS description
        ,g.value:groupId::string                AS groupId
        ,g.value:groupType::string              AS groupType
        ,g.value:groups::string                 AS groups
        ,g.value:custId::string                 AS custId
        ,g.value:parentGroupId::string          AS parentGroupId
        ,g.value:userId::string                 AS userId
        ,a.value:accountDetail::string          AS accountDetail
        ,a.value:accountId::string              AS accountId
        ,a.value:accountName::string            AS accountName
        ,a.value:accountNumber::string          AS accountNumber
        ,a.value:cashAccount::boolean           AS cashAccount
        ,a.value:cashReserve::double            AS cashReserve
        ,a.value:cashReserveExpiry::date        AS cashReserveExpiry
        ,a.value:cashReserveExpiryStr::string   AS cashReserveExpiryStr
        ,a.value:complianceRules::string        AS complianceRules
        ,a.value:custId::string                 AS account_custId
        ,a.value:custodian::string              AS custodian
        ,a.value:disableSleeves::boolean        AS disableSleeves
        ,a.value:endDate::date                  AS endDate
        ,a.value:explicitSleeve::boolean        AS explicitSleeve
        ,a.value:groupId::string                AS account_groupId
        ,a.value:householdId::string            AS householdId
        ,a.value:importDate::date               AS importDate
        ,a.value:longName::string               AS longName
        ,a.value:longTermTaxRate::float         AS longTermTaxRate
        ,a.value:modelId::string                AS modelId
        ,a.value:modelName::string              AS modelName
        ,a.value:name::string                   AS account_name
        ,a.value:notes::string                  AS notes
        ,a.value:percentOrValue::double         AS percentOrValue
        ,a.value:shortTermTaxRate::float        AS shortTermTaxRate
        ,a.value:startDate::date                AS startDate
        ,a.value:taxLotReliefMethod::string     AS taxLotReliefMethod
        ,a.value:taxable::boolean               AS taxable
        ,gr.RECORD_DATE                         AS RECORD_DATE
        ,gr.RECORD_DATETIME                     AS RECORD_DATETIME
    FROM {{ source('copilot', 'groups_raw') }} gr,
    LATERAL FLATTEN(input => gr.JSON, path => 'groups') g,
    LATERAL FLATTEN(input => g.VALUE, path => 'accounts') a