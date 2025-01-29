select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:NAME::varchar(240)                               as name
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:LAST_VIEWED_DATE::timestamptz                    as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                as last_referenced_date
    , a.json:FINANCIAL_ACCOUNT_C::varchar(18)                 as financial_account_c
    , a.json:AUM_CLASSIFICATION_C::varchar(765)               as aum_classification_c
    , a.json:DESCRIPTION_C::varchar(765)                      as description_c
    , a.json:RULE_END_DATE_C::date                            as rule_end_date_c
    , a.json:RULE_START_DATE_C::date                          as rule_start_date_c
    , a.json:SECURITY_IDENTIFIER_C::varchar(54)               as security_identifier_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:IDENTIFIER_TYPE_C::varchar(3900)                 as identifier_type_c
    , a.json:ACTIVE_C::boolean                                as active_c
    , a.json:FINANCIAL_ACCOUNT_NUMBER_C::varchar(3900)        as financial_account_number_c
    , a.json:ORION_ACCOUNT_ID_C::varchar(3900)                as orion_account_id_c
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'holding_rule_c'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case when b.rn_latest = 1 then 1 else 0 end             as is_latest
    , case when b.rn_earliest = 1 then 1 else 0 end           as is_earliest
from {{ source('salesforce_compass', 'holding_rule_c') }} as a
left join (
    select
        a.effective_at::date                                                                as effective_at
        , a._created_at
        , row_number() over (partition by a.effective_at::date order by a._created_at desc) as rn_latest
        , row_number() over (partition by a.effective_at::date order by a._created_at asc)  as rn_earliest
    from {{ source('salesforce_compass', 'holding_rule_c') }} as a
    group by 1 , 2
) as b
    on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
