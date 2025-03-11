select
    ardistributionident::text                                              as ardistributionident
    , archargesident::text                                                 as archargesident
    , clientident::text                                                    as clientident
    , arident::text                                                        as arident
    , invoiceident::text                                                   as invoiceident
    , projectident::text                                                   as projectident
    , invoicesalestaxident::text                                           as invoicesalestaxident
    , distributionamount::number(20 , 2)                                   as distributionamount
    , createdbyident::text                                                 as createdbyident
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')::datetime as createddatetime
    , _created_at::datetime                                                as _created_at
    , _extracted_at::datetime                                              as _extracted_at
    , {{ col_is_head(reference=source('cch_dau', 'ardistribution')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'ardistribution') }}
