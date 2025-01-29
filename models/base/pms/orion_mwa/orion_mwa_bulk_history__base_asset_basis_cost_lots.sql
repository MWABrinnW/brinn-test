select
    'orion'                                        as system_name
    , 'mwa'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , accountid
    , acquireddate
    , amortizationamount
    , asofdate
    , assetid
    , costbasis
    , firmid
    , islongterm
    , units
    , file_date
    , {{ col_is_head(reference=source('orion_mwa_bulk', 'assetbasiscostlots')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('orion_mwa_bulk', 'assetbasiscostlots') }}
