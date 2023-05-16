SELECT
    m.value:modelId::string                 AS modelId
    ,m.value:custId::string                 AS custId
    ,m.value:name::string                   AS name
    ,m.value:masterModel::boolean           AS masterModel
    ,m.value:percentOrShares::double        AS percentOrShares
    ,m.value:percent::double                AS percent
    ,m.value:assetType::string              AS assetType
    ,c.value:modelId::string                AS contents_modelId
    ,c.value:securityId::string             AS securityId
    ,c.value:percent::double                AS contents_percent
    ,c.value:sharePercent::double           AS sharePercent
    ,c.value:quantity::double               AS quantity
    ,c.value:price::double                  AS price
    ,c.value:value::double                  AS value
    ,c.value:product::int                   AS product
    ,c.value:cusip::string                  AS cusip
    ,c.value:updated::boolean               AS updated
    ,c.value:lastModified::TIMESTAMP_NTZ    AS lastModified
    ,r.RECORD_DATE                          AS RECORD_DATE
    ,r.RECORD_DATETIME                      AS RECORD_DATETIME
    FROM {{ source('copilot', 'models_raw') }} r,
    LATERAL FLATTEN(input => r.JSON, path => 'models') m,
    LATERAL FLATTEN(input => m.VALUE, path => 'contents') c