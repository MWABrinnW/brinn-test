select
    'cch'::text(200)                                                 as system_name
    , 'axcess'::text(200)                                            as system_instance
    , concat(system_name , '__' , system_instance)::text(200)        as system_key
    , arident::number(38 , 0)                                        as arident
    , clientident::number(38 , 0)                                    as client_ident
    , postedbystaffident::number(38 , 0)                             as posted_by_staffident
    , to_timestamp(transactiondatetime , 'MM/DD/YYYY HH12:MI:SS AM') as transaction_date_time
    , to_timestamp(posteddatetime , 'MM/DD/YYYY HH12:MI:SS AM')      as posted_date_time
    , to_timestamp(referencedatetime , 'MM/DD/YYYY HH12:MI:SS AM')   as reference_date_time
    , arentrytypeintcode::number(38 , 0)                             as ar_entry_type_int_code
    , amount::number(19 , 2)                                         as amount
    , undistributedamout::number(19 , 2)                             as undistributed_amout
    , referencenumber::varchar(45)                                   as reference_number
    , distributionmethodcode::number(38 , 0)                         as distribution_method_code
    , fullydistributed::number(38 , 0)                               as fully_distributed
    , posted::number(38 , 0)                                         as posted
    , correctionstatuscode::number(38 , 0)                           as correction_status_code
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as created_date_time
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM') as last_updated_date_time
    , bankname::varchar(256)                                         as bank_name
    , bankaccountnumber::varchar(256)                                as bank_account_number
    , paymentmethod::varchar(32)                                     as payment_method
    , paymentmethodcode::number(38 , 0)                              as payment_method_code
    , description::varchar(250)                                      as description
    , createdbyident::number(38 , 0)                                 as created_by_ident
    , lastupdatedbyident::number(38 , 0)                             as last_updated_by_ident
    , aroriginalident::number(38 , 0)                                as aroriginalident
    , argroupname::varchar(256)                                      as ar_group_name
    , reasonname::varchar(256)                                       as registration_type__r_name
    , _created_at::timestampntz                                      as _created_at
    , {{ col_is_head(reference=source('cch_dau', 'artransaction')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'artransaction') }}
