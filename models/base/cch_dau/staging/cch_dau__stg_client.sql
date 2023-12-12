select
    ClientIdent
    , ClientOfficeName
    , ClientRegionName
    , ClientBusinessUnitName
    , ClientId
    , ClientIdSubId
    , PrimaryClientFlag::boolean                                            as PrimaryClientFlag
    , ClientSubId
    , ClientType
    , LineofBusiness
    , ClientPrimaryServiceType
    , ClientSortName
    , ReturnGroupName
    , DeleteFlag::boolean                                                   as DeleteFlag
    , FiscalPeriod
    , ClientStatus
    , TO_TIMESTAMP(ClientStatusDateTime , 'MM/DD/YYYY HH12:MI:SS AM')       as ClientStatusDateTime
    , ShareableFlag
    , TO_TIMESTAMP(AcquiredDateTime , 'MM/DD/YYYY HH12:MI:SS AM')           as AcquiredDateTime
    , ClientClass
    , WebPageURL
    , TO_TIMESTAMP(CreatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')            as CreatedDateTime
    , TO_TIMESTAMP(LastUpdatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')        as LastUpdatedDateTime
    , SalutationText
    , AttentionText
    , CorrespondenceName
    , SubOrdinateDescription
    , FirmMarketingMethod
    , TO_TIMESTAMP(LastActiveDateTime , 'MM/DD/YYYY HH12:MI:SS AM')         as LastActiveDateTime
    , TO_TIMESTAMP(TerminatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')         as TerminatedDateTime
    , TO_TIMESTAMP(LastInactiveDateTime , 'MM/DD/YYYY HH12:MI:SS AM')       as LastInactiveDateTime
    , TO_TIMESTAMP(LastOnHoldDateTime , 'MM/DD/YYYY HH12:MI:SS AM')         as LastOnHoldDateTime
    , TO_TIMESTAMP(LastLitigationHoldDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as LastLitigationHoldDateTime
    , CreatedByIdent
    , LastUpdatedByIdent
    , _Created_At
from {{ source('cch_dau', 'client') }}
