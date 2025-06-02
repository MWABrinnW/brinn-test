with tot_dist_cte as (
    select
        arident
        , sum(distributionamount) as tot_dist_amt
    from {{ ref('cch_dau__stg_ardistribution') }}
    where true
        and is_head = 1
    group by 1
)

, all_ar_balances_cte as (
--invoices
    select
        clientident::int                                                                 as cch_client_ident
        , '01__invoice'                                                                  as trxn_type
        , invoiceident                                                                   as ar_identifier
        , invoicenumber                                                                  as inv_num_src_1
        , invoicenumber                                                                  as inv_num_src_2
        , invoicedatetime::date                                                          as balance_date
        , (stdwipamount + adjustmentamount + progressbilledamount + progressapplyamount) as ar_amount
    from {{ ref('cch_dau__stg_invoice') }}
    where true
        and is_head = 1
        and statuscode = 1

    --sales tax
    union all

    select
        clientident::int                                                        as cch_client_ident
        , '02__sales_tax'                                                       as trxn_type
        , invoiceident                                                          as ar_identifier
        , invoicenumber                                                         as inv_num_src_1
        , invoicenumber                                                         as inv_num_src_2
        , invoicedatetime::date                                                 as balance_date
        , (taxamount + progresstaxamount - taxappamount - progresstaxappamount) as ar_amount
    from {{ ref('cch_dau__stg_invoice') }}
    where true
        and is_head = 1
        and statuscode = 1
        and (taxamount + progresstaxamount - taxappamount - progresstaxappamount) != 0

    --adjustments - 1
    union all

    select
        clientident::int            as cch_client_ident
        , '03__adjustments'         as trxn_type
        , archargesident            as ar_identifier
        , referencenumber           as inv_num_src_1
        , referencenumber           as inv_num_src_2
        , transactiondatetime::date as balance_date
        , archargesamount           as ar_amount
    from {{ ref ('cch_dau__stg_archarges') }}
    where true
        and is_head = 1
        and arentrytypecode in (8 , 9 , 10)
        and correctionstatuscode = 1


    --payments - 1
    union all

    select
        trxn.client_ident::int                       as cch_client_ident
        , '04__payments'                             as trxn_type
        , trxn.arident                               as ar_identifier
        , invc.invoicenumber                         as inv_num_src_1
        , trxn.reference_number                      as inv_num_src_2
        , trxn.transaction_date_time::date           as balance_date
        , coalesce(dist.distributionamount * -1 , 0) as ar_amount
    from {{ ref('cch_dau__stg_artransaction') }} as trxn
    inner join {{ ref('cch_dau__stg_ardistribution') }} as dist
        on trxn.arident = dist.arident
    left join {{ ref('cch_dau__stg_invoice') }} as invc
        on dist.invoiceident = invc.invoiceident
        and invc.is_head = 1
    where true
        and trxn.is_head = 1
        and dist.is_head = 1
        and trxn.ar_entry_type_int_code in (1)
        and trxn.correction_status_code = 1
        and trxn.posted = 1

    -- paymnets (again), adjustments (again), writeoffs (again)
    union all


    select
        trxn.client_ident::int                              as cch_client_ident
        , case
            when trxn.ar_entry_type_int_code in (1)
                then
                    '05__payments'
            when trxn.ar_entry_type_int_code in (2 , 3)
                then
                    '07__adjustments'
            when trxn.ar_entry_type_int_code in (4 , 5)
                then
                    '11__write_off'
            when trxn.ar_entry_type_int_code in (6 , 7) then
                '09__adjustments'
        end                                                 as trxn_type
        , trxn.arident                                      as ar_identifier
        , trxn.reference_number                             as inv_num_src_1
        , trxn.reference_number                             as inv_num_src_2
        , trxn.transaction_date_time::date                  as balance_date
        , (trxn.amount * -1) + coalesce(d.tot_dist_amt , 0) as ar_amount
    from {{ ref('cch_dau__stg_artransaction') }} as trxn
    left join tot_dist_cte as d
        on trxn.arident = d.arident
    where true
        and trxn.is_head = 1
        and trxn.ar_entry_type_int_code in (1 , 2 , 3 , 4 , 5 , 6 , 7)
        and trxn.correction_status_code = 1
        and trxn.posted = 1
        and ar_amount != 0



    -- -- paymnets (again, again), adjustments (again, again), writeoffs (again, again)
    union all


    select
        trxn.client_ident::int                       as cch_client_ident
        , case
            when trxn.ar_entry_type_int_code in (2 , 3)
                then
                    '06__adjustments'
            when trxn.ar_entry_type_int_code in (4 , 5)
                then
                    '10__write_off'
            when trxn.ar_entry_type_int_code in (6 , 7) then
                '08__adjustments'
        end                                          as trxn_type
        , trxn.arident                               as ar_identifier
        , trxn.reference_number                      as inv_num_src_1
        , chrg.referencenumber                       as inv_num_src_2
        , trxn.transaction_date_time::date           as balance_date
        , coalesce(dist.distributionamount * -1 , 0) as ar_amount
    from {{ ref('cch_dau__stg_artransaction') }} as trxn
    inner join {{ ref('cch_dau__stg_ardistribution') }} as dist
        on trxn.arident = dist.arident
    left join {{ ref('cch_dau__stg_invoice') }} as invc
        on dist.invoiceident = invc.invoiceident
        and invc.is_head = 1
    left join {{ ref ('cch_dau__stg_archarges') }} as chrg
        on dist.archargesident = chrg.archargesident
        and chrg.is_head = 1
    where true
        and trxn.is_head = 1
        and dist.is_head = 1
        and trxn.correction_status_code = 1
        and trxn.posted = 1
        and trxn.ar_entry_type_int_code in (2 , 3 , 4 , 5 , 6 , 7)
)

, xcm_locations_cte as (
    select
        account_number
        , location_name
        , period_end_date
        , row_number() over (
            partition by account_number
            order by account_number asc , period_end_date desc
        ) as rn
    from {{ ref('xcm__stg_task_detail') }}
    where true
        and status_type = 'Completed'
    qualify rn = 1
)

select
    ardt.cch_client_ident
    , clnt.clientid
    , clnt.clientidsubid
    , clnt.clientofficename
    , case
        when clnt.clientofficename = 'Madison' and left(clnt.clientid , 2) = '06'
            then
                'Manasquan'
        when clnt.clientofficename = 'Madison' and left(clnt.clientsubid , 2) = '06'
            then
                'Manasquan'
        when clnt.clientofficename = 'Madison' and left(clnt.clientid , 2) = '13'
            then
                'Chatham'
        when clnt.clientofficename = 'Madison' and left(clnt.clientsubid , 2) = '13'
            then
                'Chatham'
        when clnt.clientofficename = 'Sioux Falls' and left(clnt.clientid , 5) = '20ZTC'
            then
                'Speciality Tax'
        when clnt.clientofficename = 'Sioux Falls' and left(clnt.clientsubid , 5) = '20ZTC'
            then
                'Speciality Tax'
        when clnt.clientofficename = 'Sioux Falls' and left(clnt.clientid , 5) = '20STS'
            then
                'Cost Seg'
        when clnt.clientofficename = 'Sioux Falls' and left(clnt.clientsubid , 5) = '20STS'
            then
                'Cost Seg'
        when clnt.clientofficename = 'New Albany' and left(clnt.clientid , 6) = '.kleeh'
            then
                'New Albany'
        when clnt.clientofficename = 'New Albany' and left(clnt.clientsubid , 6) = '.kleeh'
            then
                'New Albany'
        when clnt.clientofficename = 'New Albany'
            then
                'Louisville'
        else
            clnt.clientofficename
    end
        as cch_client_office
    , xcmc.location_name                       as xcm_office
    , coalesce(xcm_office , cch_client_office) as reporting_office
    , case
        when reporting_office = 'Cost Seg'
            then
                '6633'
        when reporting_office = 'Speciality Tax'
            then
                '6634'
        else
            coalesce(ref2.coa_segment_3_accounting_id , ref1.coa_segment_3_accounting_id)
    end                                        as reporting_acct_id
    , ardt.trxn_type
    , ardt.ar_identifier
    , ardt.inv_num_src_1
    , ardt.inv_num_src_2
    , ardt.balance_date
    , ardt.ar_amount
from all_ar_balances_cte as ardt
left join {{ ref('cch_dau__stg_client') }} as clnt
    on ardt.cch_client_ident = clnt.clientident
    and clnt.is_head = 1
left join xcm_locations_cte as xcmc
    on clnt.clientid = xcmc.account_number
left join {{ ref('aux__stg_tax_location_mappings') }} as ref1
    on lower(cch_client_office) = ref1.tax_office_name
    and ref1.system_name = 'cch axcess'
left join {{ ref('aux__stg_tax_location_mappings') }} as ref2
    on lower(xcm_office) = ref2.tax_office_name
    and ref2.system_name = 'xcm'
