
select
    recordtype
    ,custodian
    ,mstracctnumber
    ,masteraccountname
    ,businessdate
    ,accountid
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
    ,transcode
    ,currentmarketvalue
    ,accruedinterest
    ,acquireddate
    ,origpurchasedate
    ,orgpurchaseprice
    ,yieldtomaturity
    ,costbasisunamortized
    ,costpershare
    ,adjustedcostbasisamortized
    ,adjustedcostpershare
    ,urgl
    ,daysheld
    ,ht
    ,cb
    ,ct
    ,at
    ,cf
    ,originalface
    ,dflotselct
    ,ws
    ,versionmrkr1
    ,disallowedlossamount
    ,transactioncost
    ,transactioncostpershare
    ,versmrkr2
    ,gi
    ,originalcostbasis
    ,versmrkr3
    ,adjustedcostincludgunpdamort
    ,case when effective_date::date = (select max(effective_date::date) from {{ source('schwab_mwa', 'tax_lots') }}) then 1 else 0 end as is_current
    ,effective_date::date           as effective_date
    ,record_datetime::timestamp     as record_datetime
    ,record_date::date              as record_date
from {{ source('schwab_mwa', 'tax_lots') }}