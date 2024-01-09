select
    TO_CHAR(I.InvoiceDateTime , 'Mon-yy')                                      as InvoiceMonYear
    , I.InvoiceIdent
    , I.ClientIdent
    , I.InvoiceDateTime
    , I.ReversedDateTime
    , I.InvoiceNumber
    , I.StdWIPAmount
    , I.AdjustmentAmount
    , I.TaxAmount
    , I.Hours
    , I.ProgressBilledAmount
    , I.StatusCode
    , I.CreatedByIdent
    , I.InvoiceStatusName
    , W.Wipident
    , W.ServiceCodeIdent
    , W.StaffIdent
    , W.Hours
    , W.StdAmount
    , W.TransactionDate
    , W.TimeAdjAmount
    , W.ExpenseAdjAmount
    , W.AdjAmount
    , W.BilledAmount
    , W.InvoiceStatusCode
    , C.ClientOfficeName
    , C.ClientId
    , C.ClientType
    , C.ClientStatus
    , A.AddressLine1
    , A.CityName
    , A.StateProvinceCode
    , A.PostalCode
    , S.CategoryName
    , SUM(COALESCE(W.BilledAmount , 0) + COALESCE(I.ProgressBilledAmount , 0)) as Actuals


from {{ ref('cch_dau__stg_uvw_wipar02clientident') }} as W
full outer join {{ ref('cch_dau__stg_invoice') }} as I on W.InvoiceIdent = I.InvoiceIdent
left join {{ ref('cch_dau__stg_client') }} as C on I.ClientIdent = C.ClientIdent
left join {{ ref('cch_dau__stg_servicecode') }} as S on W.ServiceCodeIdent = S.ServiceCodeIdent
left join {{ ref('cch_dau__stg_clientaddress') }} as A on C.ClientIdent = A.ReferenceIdent AND A.PrimaryAddressFlag = 'T'
where TO_CHAR(I.InvoiceDateTime , 'Mon-yy') like '%-23'

group by
    TO_CHAR(I.InvoiceDateTime , 'Mon-yy')
    , I.InvoiceIdent
    , I.ClientIdent
    , I.InvoiceDateTime
    , I.ReversedDateTime
    , I.InvoiceNumber
    , I.StdWIPAmount
    , I.AdjustmentAmount
    , I.TaxAmount
    , I.Hours
    , I.ProgressBilledAmount
    , I.StatusCode
    , I.CreatedByIdent
    , I.InvoiceStatusName
    , W.Wipident
    , W.ServiceCodeIdent
    , W.StaffIdent
    , W.Hours
    , W.StdAmount
    , W.TransactionDate
    , W.TimeAdjAmount
    , W.ExpenseAdjAmount
    , W.AdjAmount
    , W.BilledAmount
    , W.InvoiceStatusCode
    , C.ClientOfficeName
    , C.ClientId
    , C.ClientType
    , C.ClientStatus
    , A.AddressLine1
    , A.CityName
    , A.StateProvinceCode
    , A.PostalCode
    , S.CategoryName
