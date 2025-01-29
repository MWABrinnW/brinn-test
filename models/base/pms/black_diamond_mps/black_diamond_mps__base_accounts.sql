{%- set extra_columns -%}
, max(
    case
        when atag.tag_name = 'AUM / AUA / RO' and atag.tag_value = 'AUM' then 'AUM - Assets Under Management'
        when atag.tag_name = 'AUM / AUA / RO' and atag.tag_value = 'AUA' then 'AUA - Assets Under Advisory'
        when atag.tag_name = 'AUM / AUA / RO' and atag.tag_value = 'Reporting Only' then 'Data Aggregation / Reporting Only'
        when atag.tag_name = 'AUM / AUA / RO' then atag.tag_value
    end
)                                                                                as aum_aua_ro
, max(case when atag.tag_name = 'Account Compression' then atag.tag_value end)   as account_compression
, max(case when atag.tag_name = 'Account Type' then atag.tag_value end)          as account_type
, max(case when atag.tag_name = 'Billing Split' then atag.tag_value end)         as billing_split
, max(case when atag.tag_name = 'CAIS' then atag.tag_value end)                  as cais
, max(case when atag.tag_name = 'ERISA' then atag.tag_value end)                 as erisa
, max(case when atag.tag_name = 'Exclude from Billing' then atag.tag_value end)  as exclude_from_billing
, max(case when atag.tag_name = 'IPS' then atag.tag_value end)                   as ips
, max(case when atag.tag_name = 'Liquid vs Illiquid' then atag.tag_value end)    as liquid_vs_illiquid
, max(case when atag.tag_name = 'Managed / Non-managed' then atag.tag_value end) as managed_non_managed
, max(case when atag.tag_name = 'RPP Client' then atag.tag_value end)            as rpp_client
, max(case when atag.tag_name = 'TD Account Number' then atag.tag_value end)     as td_account_number
{%- endset -%}

{{ black_diamond_base_accounts(
    src=source('black_diamond_mps', 'accounts'),
    instance='mps',
    firm_source='mps',
    extra_columns=extra_columns,
    extra_joins=none
) }}
