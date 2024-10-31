select
    ir.*
    -- protect against the possibility of accounts existing in both tamarac and orion; if the account is billed out of Orion, we would NOT consider it CPG.
    , case
        when (ir.account_number_c = replace(cpg_ba.account_number , '-' , '') and ir.orion_bill_id_c is null) then 1
        else 0
    end::int as is_cpg
from {{ ref('salesforce_compass__base_invoice_review_c') }} as ir
left join {{ ref('tamarac_state_college_history__base_accounts') }} as cpg_ba
    on ir.account_number_c = replace(cpg_ba.account_number , '-' , '')
    and ir.invoice_date_c = cpg_ba.effective_date
    and cpg_ba.rn = 1
    and cpg_ba.entity_type = 'Single Account'
where true
    and ir.is_head = 1
    and ir.is_latest = 1
    and ir.is_deleted = 0
    and ir._fivetran_deleted = 0
    and ir.invoice_date_c >= '12/31/2021'
