select
    "iso_cfi_prefix"::text  as iso_cfi_prefix
    , "cfi_category"::text  as cfi_category
    , "cfi_attribute"::text as cfi_attribute
from {{ source('cusip', 'cfi_map') }}
