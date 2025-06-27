select
    "security_type_code"::text       as security_type_code
    , "security_modifier_code"::text as security_modifier_code
    , "security_type"::text          as security_type
    , "security_subtype"::text       as security_subtype
from {{ source('fidelity_mwa_history', 'security_map') }}
