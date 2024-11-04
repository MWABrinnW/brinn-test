-- protect against the possibility of accounts existing in both tamarac and orion; if the account is billed out of Orion, we would NOT consider it CPG.
select
    ir.*
    , case
        when
            (replace(ir.account_number_c , '-' , '') = replace(cpg_ba.account_number , '-' , '') and ir.orion_bill_id_c is null)
            then 1
        else 0
    end::int as is_cpg
from {{ ref('salesforce_compass__base_invoice_review_c') }} as ir
inner join edw.ref.dates as dt
    on ir.invoice_date_c = dt.date_key
left join {{ ref('tamarac_state_college_history__base_accounts') }} as cpg_ba
    on replace(ir.account_number_c , '-' , '') = replace(cpg_ba.account_number , '-' , '')
    and
    case
        when (ir.invoice_date_c = cpg_ba.effective_date or dt.prior_market_date = cpg_ba.effective_date)
            then
                1
        else
            0
    end
    and cpg_ba.rn = 1
    and cpg_ba.entity_type = 'Single Account'
where true
    and ir.is_head = 1
    and ir.is_latest = 1
    and ir.is_deleted = 0
    and ir._fivetran_deleted = 0
    and ir.invoice_date_c >= '12/31/2021'
qualify row_number() over (partition by ir.name order by ir.name asc , cpg_ba.effective_date desc) = 1
order by ir.name
