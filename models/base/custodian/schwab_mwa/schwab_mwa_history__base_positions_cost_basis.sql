
select
    recordtype
    ,custodian
    ,mstracctnumber
    ,masteraccountname
    ,businessdate
    ,accountid
    ,securitytype
    ,prodcode
    ,prodcatgcode
    ,taxcode
    ,tickersymbol
    ,cusip
    ,schwabsecnbr
    ,itemissueid
    ,isin
    ,sedol
    ,optionsdisplaysymbol
    ,underlyingtickersymbol
    ,underlyingcusip
    ,underlyingschwabnbr
    ,underlyingitmissid
    ,underlyingisin
    ,underlyingsedol
    ,currentquantity
    ,ls
    ,currentmarketvalue
    ,accruedinterest
    ,costbasisunamortized
    ,costpershare
    ,adjcostbasisamortized
    ,adjcostpershare
    ,urgl
    ,cb
    ,ct
    ,at
    ,cf
    ,originalface
    ,dflottselct
    ,cm
    ,princpaydownfactor
    ,case when effective_date::date = (select max(effective_date::date) from {{ source('schwab_mwa', 'positions_cost_basis') }}) then 1 else 0 end as is_current
    ,effective_date::date           as effective_date
    ,record_datetime::timestamp     as record_datetime
    ,record_date::date              as record_date
from {{ source('schwab_mwa', 'positions_cost_basis') }}