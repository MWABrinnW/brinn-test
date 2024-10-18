{%- set extra_columns -%}
, max(case when atag.tag_name = 'Account Comments' then atag.tag_value end)              as account_comments
, max(case when atag.tag_name = 'Active/Passive Form' then atag.tag_value end)           as active_passive_form
, max(case when atag.tag_name = 'Advisor Commission Split Code' then atag.tag_value end) as advisor_commission_split_code
, max(case when atag.tag_name = 'Billing Company' then atag.tag_value end)               as billing_company
, max(case when atag.tag_name = 'Notes' then atag.tag_value end)                         as notes_1
, max(case when atag.tag_name = 'Notes 1' then atag.tag_value end)                       as notes_1
, max(case when atag.tag_name = 'Notes 2' then atag.tag_value end)                       as notes_2
, max(case when atag.tag_name = 'Select Alternatives' then atag.tag_value end)           as select_alternatives
, max(case when atag.tag_name = 'Select Equities' then atag.tag_value end)               as select_equities
, max(case when atag.tag_name = 'Select Fixed Income' then atag.tag_value end)           as select_fixed_income
, max(case when atag.tag_name = 'Select Program' then atag.tag_value end)                as select_program
{%- endset -%}

{{ black_diamond_base_accounts(
    src=source('black_diamond_baystate', 'accounts'),
    instance='baystate',
    firm_source='baystate',
    extra_columns=extra_columns,
    extra_joins=none
) }}
