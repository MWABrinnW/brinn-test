select
    CLIENT_NAME
    , TPG_ID_NUMBER
    , MORNINGSTAR_ACCT_NUMBER
    , MORNINGSTAR_ACCOUNT_NAME
    , _CREATED_AT::TIMESTAMPNTZ as _CREATED_AT
from {{source('aux', 'hfw_tpg_mstar_overlap')}}