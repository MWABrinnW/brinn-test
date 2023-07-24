select
    trim(json:"Office Location"::text(100))                    as office_location
  , trim(json:"Custodian"::text(100))                          as custodian
  , regexp_replace(
    trim(json:"Advisor Code"::text(100)), '[^[:ascii:]]', '')  as advisor_code
  , case
      when custodian ilike '%schwab%'
          then 'schwab'
      when custodian ilike '%fidelity%'
          then 'fidelity'
      when custodian ilike '%ameritrade%'
          then 'tda'
      when custodian ilike '%pershing%'
          then 'pershing'
      when custodian ilike '%lpl%'
          then 'lpl'
      when left(advisor_code, 1) ilike 'G'
          then 'fidelity'
      else null
      end::text(200)                                           as _custodian_key
  , case
        when _custodian_key = 'schwab' and left(advisor_code, 1) <> '0'
            then '0' || trim(advisor_code)
        else
            split_part(trim(advisor_code), ' ', 1)
        end                                                    as link
  , regexp_replace(
    trim(json:"Type"::text(100)), '[^[:ascii:]]', ''
    )                                                          as type
  , regexp_replace(
    trim(json:"Status"::text(100)), '[^[:ascii:]]', ''
    )                                                          as status
  , regexp_replace(
    trim(json:"Description"::text(500)), '[^[:ascii:]]', ''
    )                                                          as description
  , regexp_replace(trim(json:"Notes"::text(500)), '[^[:ascii:]]', ''
    )                                                          as notes
  , trim(json:"HQ Master Code"::text(100))                     as hq_master_code
  , trim(json:"Pricing"::text(100))                            as pricing
  , trim(json:"Trading Authority"::text(100))                  as trading_authority
  , trim(json:"3rd Party Managed"::varchar(100))               as third_party_managed
  , trim(json:"RPP - WAS or SAN"::text(100))                   as rpp_wa_or_san
  , try_to_date(json:"Open Date"::text(100))                   as open_date
  , trim(json:"Old Rep Code"::text(100))                       as old_rep_code
  , trim(json:"1Mariner Transition"::text(100))                as one_mariner_transition
  , trim(json:"Vendor Transmission"::text(100))                as vendor_transmission
  , trim(json:"Options Level Approval"::text(100))             as options_level_approval
  , trim(json:"Prime Broker"::text(100))                       as prime_broker
  , trim(json:"Data Feed"::text(100))                          as data_feed
  , trim(json:"Standing Linking Instructions"::text(100))      as standing_linking_instructions
  , trim(json:"Statement Preferences"::text(100))              as statement_preferences
  , upper(trim(json:"Location Code"::text(200)))               as location_code
  , lower(trim(json:"Advisor Email"::text(200)))               as advisor_email
  , json:_box_file_id::text(100)                               as _box_file_id
  , null::text(100)                                            as _box_sheet_name
  , _created_at::timestamp                                     as _created_at
from {{ source('aux', 'custodian_codes_master_list') }}