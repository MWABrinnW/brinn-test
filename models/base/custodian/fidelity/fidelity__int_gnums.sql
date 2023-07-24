select
      a.effective_date
    , 'fidelity'                  as custodian
    , a.firm_source
    , a.account_number_formatted
    , a.account_number
    , a.primary_account_holder
    , a.gnum
    , gnum_source
    , case when gnum_source = 'PRIMARY_GNUM' then 1 else 0 end as is_primary
    , gnum_name
    , gnum_source_desc
    , a.is_head
    , a.is_current
    , a._source_loaded_at
    , a._source_file
    , a._row_number
    , a._checksum
from {{ ref('fidelity__stg_gnums') }} a
unpivot (gnum for gnum_source in (primary_gnum, secondary_gnum_1, secondary_gnum_2, secondary_gnum_3, secondary_gnum_4, secondary_gnum_5
                        , secondary_gnum_6, secondary_gnum_7, secondary_gnum_8, secondary_gnum_9, secondary_gnum_10))
unpivot (gnum_name for gnum_source_desc in (primary_gnum_advisor, secondary_gnum_name_1, secondary_gnum_name_2, secondary_gnum_name_3, secondary_gnum_name_4, secondary_gnum_name_5
                        , secondary_gnum_name_6, secondary_gnum_name_7, secondary_gnum_name_8, secondary_gnum_name_9, secondary_gnum_name_10))
where true
    and (
        (gnum_source = 'PRIMARY_GNUM' and gnum_source_desc = 'PRIMARY_GNUM_ADVISOR')
        or (gnum_source = 'SECONDARY_GNUM_1' and gnum_source_desc = 'SECONDARY_GNUM_NAME_1')
        or (gnum_source = 'SECONDARY_GNUM_2' and gnum_source_desc = 'SECONDARY_GNUM_NAME_2')
        or (gnum_source = 'SECONDARY_GNUM_3' and gnum_source_desc = 'SECONDARY_GNUM_NAME_3')
        or (gnum_source = 'SECONDARY_GNUM_4' and gnum_source_desc = 'SECONDARY_GNUM_NAME_4')
        or (gnum_source = 'SECONDARY_GNUM_5' and gnum_source_desc = 'SECONDARY_GNUM_NAME_5')
        or (gnum_source = 'SECONDARY_GNUM_6' and gnum_source_desc = 'SECONDARY_GNUM_NAME_6')
        or (gnum_source = 'SECONDARY_GNUM_7' and gnum_source_desc = 'SECONDARY_GNUM_NAME_7')
        or (gnum_source = 'SECONDARY_GNUM_8' and gnum_source_desc = 'SECONDARY_GNUM_NAME_8')
        or (gnum_source = 'SECONDARY_GNUM_9' and gnum_source_desc = 'SECONDARY_GNUM_NAME_9')
        or (gnum_source = 'SECONDARY_GNUM_10' and gnum_source_desc = 'SECONDARY_GNUM_NAME_10')
    )
