select

    ARIdent::NUMBER(38 , 0)                                          as Arident
    , ClientIdent::NUMBER(38 , 0)                                    as Client_Ident
    , PostedByStaffIdent::NUMBER(38 , 0)                             as Posted_By_Staffident
    , TO_TIMESTAMP(TransactionDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as Transaction_Date_Time
    , TO_TIMESTAMP(PostedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')      as Posted_Date_Time
    , TO_TIMESTAMP(ReferenceDateTime , 'MM/DD/YYYY HH12:MI:SS AM')   as Reference_Date_Time
    , AREntryTypeIntCode::NUMBER(38 , 0)                             as Ar_Entry_Type_Int_Code
    , Amount::NUMBER(19 , 2)                                         as Amount
    , UndistributedAmout::NUMBER(19 , 2)                             as Undistributed_Amout
    , ReferenceNumber::VARCHAR(45)                                   as Reference_Number
    , DistributionMethodCode::NUMBER(38 , 0)                         as Distribution_Method_Code
    , FullyDistributed::NUMBER(38 , 0)                               as Fully_Distributed
    , Posted::NUMBER(38 , 0)                                         as Posted
    , CorrectionStatusCode::NUMBER(38 , 0)                           as Correction_Status_Code
    , TO_TIMESTAMP(CreatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')     as Created_Date_Time
    , TO_TIMESTAMP(LastUpdatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as Last_Updated_Date_Time
    , BankName::VARCHAR(256)                                         as Bank_Name
    , BankAccountNumber::VARCHAR(256)                                as Bank_Account_Number
    , PaymentMethod::VARCHAR(32)                                     as Payment_Method
    , PaymentMethodCode::NUMBER(38 , 0)                              as Payment_Method_Code
    , Description::VARCHAR(250)                                      as Description
    , CreatedByIdent::NUMBER(38 , 0)                                 as Created_By_Ident
    , LastUpdatedByIdent::NUMBER(38 , 0)                             as Last_Updated_By_Ident
    , AROriginalIdent::NUMBER(38 , 0)                                as Aroriginalident
    , ARGroupName::VARCHAR(256)                                      as Ar_Group_Name
    , ReasonName::VARCHAR(256)                                       as Registration_Type__R_Name
    , _Created_At::TIMESTAMPNTZ                                      as _Created_At
from {{ source('cch_dau', 'artransaction') }}
