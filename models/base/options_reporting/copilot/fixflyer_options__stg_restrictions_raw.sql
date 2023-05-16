SELECT
    TO_DATE(v.value:restrictionStartDate::string, 'YYYYMMDD')               AS restrictionStartDate
    ,CASE WHEN v.value:restrictionEndDate != ''
        THEN TO_DATE(v.value:restrictionEndDate::string, 'YYYYMMDD') END    AS restrictionEndDate
    ,v.value:enabled::boolean                                               AS enabled
    ,v.value:restrictionId::string                                          AS restrictionId
    ,v.value:accountId::string                                              AS accountId
    ,v.value:custId::string                                                 AS custId
    ,v.value:userId::string                                                 AS userId
    ,v.value:restrictionType::string                                        AS restrictionType
    ,v.value:securityId::string                                             AS securityId
    ,v.value:cusip::string                                                  AS cusip
    ,v.value:product::string                                                AS product
    ,v.value:notes::string                                                  AS notes
    ,TO_TIMESTAMP_TZ(v.value:lastModified::string, 
                    'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM')                      AS lastModified
    ,r.RECORD_DATE                                                          AS RECORD_DATE
    ,r.RECORD_DATETIME                                                      AS RECORD_DATETIME
    FROM {{ source('copilot', 'restrictions_raw') }} r,
    LATERAL FLATTEN(input => r.JSON, path => 'restrictions') v