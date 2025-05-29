{%- set extra_columns -%}
    , max(case when atag.tag_name = 'PB' then atag.tag_value end)                   as pb
    , max(case when atag.tag_name = 'TR' then atag.tag_value end)                   as tr
    , max(case when atag.tag_name = 'WAS Account' then atag.tag_value end)          as was_account
    , max(case when atag.tag_name = 'Notes' then atag.tag_value end)                as notes
    , max(case when atag.tag_name = 'State2' then atag.tag_value end)               as state2
    , max(case when atag.tag_name = 'Strategy' then atag.tag_value end)             as strategy
    , max(case when atag.tag_name = 'Lot' then atag.tag_value end)                  as lot
    , max(case when atag.tag_name = 'R' then atag.tag_value end)                    as r
    , max(case when atag.tag_name = 'SI Custody' then atag.tag_value end)           as si_custody
    , max(case when atag.tag_name = 'Account Registration' then atag.tag_value end) as account_registration
    , max(case when atag.tag_name = 'TD Account Number' then atag.tag_value end)    as td_account_number
    , max(case when atag.tag_name = 'Stonnington Referral' then atag.tag_value end) as stonnington_referral
    , max(case when atag.tag_name = 'Regulatory Account' then atag.tag_value end)   as regulatory_account
    , max(case when atag.tag_name = 'QB' then atag.tag_value end)                   as qb
    , max(case when atag.tag_name = 'MWA Contract' then atag.tag_value end)         as mwa_contract
    , max(case when atag.tag_name = 'Rest Notes' then atag.tag_value end)           as rest_notes
    , max(case when atag.tag_name = 'SAN Account' then atag.tag_value end)          as san_account
    , max(case when atag.tag_name = 'State' then atag.tag_value end)                as state
{%- endset -%}

{{ black_diamond_base_accounts(
    src=source('black_diamond_houston', 'accounts'),
    instance='houston',
    firm_source='mwa',
    extra_columns=extra_columns,
    extra_joins=none,
    where_clause="and a.effective_date > (select max(t.effective_date) from " ~ ref('black_diamond_houston__base_accounts_history') ~ " as t)",
    is_lambda=true
) }}
