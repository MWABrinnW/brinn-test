{{ config(enabled = false) }}

with cte_ass as (
    select
        accountid
        , upper(acctcode) as acctcode
        , fkasset
    from {{ ref('orion__base_vw_asset') }}
    where fkalclient = 568
)

, cte_accounts as (
    select
        pms_account_id
        , is_perform
        , is_moxy
        , is_included
    from {{ ref('mis__accounts') }}
    where 1 = 1
        and is_included = 1
)

select
    ass.accountid                  as accountid
    , ass.acctcode                 as acctcode
    , cbr.clientname               as clientname
    , cbr.system_name              as system_name
    , cbr.system_instance          as system_instance
    , cbr.system_key               as system_key
    , cbr.firm_source              as firm_source
    , cbr.acquireddate             as acquireddate
    , cbr.amortizationamt          as amortizationamt
    , cbr.costamt                  as costamt
    , cbr.createddate              as createddate
    , cbr.fkalclient               as fkalclient
    , cbr.fkasset                  as fkasset
    , cbr.fkassetcostbasis         as fkassetcostbasis
    , cbr.holdperioddate           as holdperioddate
    , case
        when cbr.selldate - cbr.acquireddate > 365 then 1
        when cbr.selldate - cbr.acquireddate <= 365 then 0
    end                            as islongterm
    --	, cbr.islongterm                        as islongterm
    , cbr.method                   as method
    , cbr.nounits                  as nounits
    , cbr.proceedamt               as proceedamt
    , cbr.proceedamt - cbr.costamt as gain_loss
    , case
        when cbr.costamt = 0
            then 1
        else 0
    end                            as unknown_cost
    , cbr.recordsource             as recordsource
    , cbr.selldate                 as selldate
    , cbr.washsaleimpacted         as washsaleimpacted
    , cbr.effective_date           as effective_date
    , cbr.is_head                  as is_head
    , cbr.is_current               as is_current
    , cbr._pk                      as _pk
    , cbr._client                  as _client
    , cbr._is_full                 as _is_full
    , cbr._extracted_at            as _extracted_at
    , cbr._created_at              as _created_at
    , cbr._source_file             as _source_file
    , cbr._checksum                as _checksum
    , acc.is_perform               as is_perform
    , acc.is_moxy                  as is_moxy
    , acc.is_included              as is_included
from {{ ref('orion__base_vw_costbasisrealized') }} as cbr
left join cte_ass as ass
    on cbr.fkasset = ass.fkasset
inner join cte_accounts as acc
    on ass.accountid::varchar = acc.pms_account_id::varchar
where 1 = 1
    and cbr.is_head = 1
    and cbr.fkalclient = 568
