select
    compthirdpartyid::int                 as comp_third_party_id
    , billingdefinitionid::int            as billing_definition_id
    , compdescription::text               as comp_description
    , compfactor::int                     as comp_factor
    , expirationdate::timestamp_ntz       as expiration_date
    , effectivedate::timestamp_ntz        as effective_date
    , contact::text                       as contact
    , payeetypeid::int                    as payee_type_id
    , contractpayeename::text             as contract_payee_name
    , solicitordisclosuredate::date       as solicitor_disclosure_date
    , initialoverriderate::number(5 , 2)  as initial_override_rate
    , initialoverrideexpirationdate::date as initial_override_expiration_date
    , ongoingoverriderate::number(5 , 2)  as ongoing_override_rate

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                     as _extracted_at
    , file_type::text                     as file_type
    , _created_at::timestamp              as _created_at
    , _source_file::text                  as _source_file
from {{ source('cambak', 'cbcompthirdparty') }}
