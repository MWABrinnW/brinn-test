select
    issuer_number::text              as issuer_number
    , issuer_check::text             as issuer_check
    , issuer_name::text              as issuer_name
    , issuer_adl::text               as issuer_adl
    , issuer_type::text              as issuer_type
    , issuer_status::text            as issuer_status
    , domicile::text                 as domicile
    , state_cd::text                 as state_cd
    , cabre_id::text                 as cabre_id
    , cabre_status::text             as cabre_status
    , leigmei::text                  as leigmei
    , legal_entity_name::text        as legal_entity_name
    , previous_name::text            as previous_name
    , issuer_entry_date::date        as issuer_entry_date
    , cp_institution_type_desc::text as cp_institution_type_desc
    , issuer_transaction::text       as issuer_transaction
    , issuer_update_date::date       as issuer_update_date
    , reserved_1::text               as reserved_1
    , reserved_2::text               as reserved_2
    , reserved_3::text               as reserved_3
    , reserved_4::text               as reserved_4
    , reserved_5::text               as reserved_5
    , reserved_6::text               as reserved_6
    , reserved_7::text               as reserved_7
    , reserved_8::text               as reserved_8
    , reserved_9::text               as reserved_9
    , reserved_10::text              as reserved_10
    , effective_date::date           as effective_date
    , {{ col_is_head(reference=source('cusip', 'allcmmaster_issuer')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_date::date              as record_date
    , record_datetime::timestamp_ltz as record_datetime
    , source_file::text              as source_file
from {{ source('cusip', 'allcmmaster_issuer') }}
