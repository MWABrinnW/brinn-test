with SalesTaxData as (
    select
        TO_CHAR(InvoiceDateTime , 'Mon-yy') as InvoiceMonYear
        , ClientIdent
        , SUM(TaxAmount)                    as SalesTax
    from {{ ref('cch_dau__stg_invoice') }}
    where TO_CHAR(InvoiceDateTime , 'Mon-yy') like '%-23'
    group by TO_CHAR(InvoiceDateTime , 'Mon-yy') , ClientIdent
)

select
    DS1.InvoiceMonYear
        as "Date of Invoice"
    , DS1.ClientIdent                                                                                                   as "Client ID (Key)"
    , DS1.ClientId                                                                                                      as "Client ID"
    , DS1.StaffIdent                                                                                                    as "Staff ID"
    , DS1.StaffName                                                                                                     as "Staff Name"
    , case
        when DS1.StaffName = 'Detert, Sam' then 'Samuel'
        when DS1.StaffName = 'Ruda, Steve' then 'Steven'
        else DS1.StaffFirstName
    end
        as "Staff First Name"
    , DS1.StaffLastName                                                                                                 as "Staff Last Name"
    , DS2.TotalProductionHours                                                                                          as "Production Hours"
    , DS2.TotalProductionAmount                                                                                         as "Production Amount"
    , DS1.BilledHours                                                                                                   as "Billed Hours"
    , DS1.TotalBilledAmount                                                                                             as "Billed Amount"
    , DS1.TotalBilledAmount / NULLIF(SUM(DS1.TotalBilledAmount) over (partition by DS1.InvoiceIdent) , 0) * ST.SalesTax as "Sales Tax"
    , case
        when DS1.ClientId like '20STS%' then 'STS'
        when DS1.ClientId like '20ZTC%' then 'ZTC'
    end
        as "Cube Department"
    , case
        when DS1.ClientId like '20ZTC%' then '6634 Specialty Tax Credit Services'
        when DS1.ClientId like '20STS%' then '6633 Cost Segregation Tax Team'
    end
        as "Department Name"
from
    (
        select
            W.ClientIdent
            , C.ClientId
            , W.StaffIdent
            , S.StaffName
            , S.StaffFirstName
            , S.StaffLastName
            , W.InvoiceIdent
            , SUM(W.Hours)                          as BilledHours
            , SUM(W.BilledAmount)                   as TotalBilledAmount
            , TO_CHAR(W.InvoiceDateTime , 'Mon-yy') as InvoiceMonYear
        from {{ ref('cch_dau__stg_uvw_wipar02clientident') }} as W
        inner join {{ ref('cch_dau__stg_staff') }} as S on W.StaffIdent = S.StaffIdent
        inner join {{ ref('cch_dau__stg_client') }} as C on W.ClientIdent = C.ClientIdent
        where
            C.ClientId like '20STS%'
            or C.ClientId like '20ZTC%'
        group by
            W.ClientIdent
            , C.ClientId
            , W.StaffIdent
            , S.StaffName
            , S.StaffFirstName
            , S.StaffLastName
            , W.InvoiceIdent
            , TO_CHAR(W.InvoiceDateTime , 'Mon-yy')
    ) as DS1
left join
    (
        select
            ClientIdent
            , StaffIdent
            , SUM(BillableHours) as TotalProductionHours
            , SUM(TimeAmount)    as TotalProductionAmount
        from {{ ref('cch_dau__stg_uvw_productivity') }}
        where
            TransactionDate >= '2023-01-01'
        group by
            ClientIdent
            , StaffIdent
    ) as DS2
    on
    DS1.ClientIdent = DS2.ClientIdent
    and DS1.StaffIdent = DS2.StaffIdent
left join SalesTaxData as ST
    on
    DS1.InvoiceMonYear = ST.InvoiceMonYear
    and DS1.ClientIdent = ST.ClientIdent
