select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_sourc
    , effective_date
    , record_type
    , owner_id
    , owner_type
    , contact_type
    , contact_name
    , address_type
    , address_line_1
    , address_line_2
    , city
    , state
    , zip
    , country
    , phone_1
    , phone_2
    , fax
    , email
    , use_as_qpr_mailing_address
    , {{ col_is_head(reference=source('envestnet_mwa', 'familymember_contact')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'familymember_contact') }}


