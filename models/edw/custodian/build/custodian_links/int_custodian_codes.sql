with cte_codes as
         (
             select
                 office_location                                        as _office_location
               , custodian                                              as _custodian
               , _custodian_key                                         as _custodian_key
               , link                                                   as _link
               , type                                                   as _type
               , status                                                 as _status
               , description                                            as _description
               , notes                                                  as _notes
               , hq_master_code                                         as _hq_master_code
               , pricing                                                as _pricing
               , trading_authority                                      as _trading_authority
               , third_party_managed                                    as _third_party_managed
               , rpp_wa_or_san                                          as _rpp_wa_or_san
               , open_date                                              as _open_date
               , old_rep_code                                           as _old_rep_code
               , one_mariner_transition                                 as _one_mariner_transition
               , vendor_transmission                                    as _vendor_transmission
               , options_level_approval                                 as _options_level_approval
               , prime_broker                                           as _prime_broker
               , data_feed                                              as _data_feed
               , standing_linking_instructions                          as _standing_linking_instructions
               , statement_preferences                                  as _statement_preferences
               , location_code                                          as _location_code
               , advisor_email                                          as _advisor_email
               , _box_file_id                                           as _box_file_id
               , _box_sheet_name                                        as _box_sheet_name
               , _created_at                                            as _created_at
             from {{ ref('aux__stg_custodian_codes_master_list') }}
         )

select
    _custodian_key                                                 as custodian
  , case
        when (_office_location || ' ' || _custodian) ilike '% mps %'
            then 'mps'
        when _office_location ilike '%msec%'
            then 'msec'
        else 'mwa'
        end::text(200)                                             as firm_source
  , _link                                                          as link
  , case
        when custodian = 'schwab'
            then 'master_number'
        when custodian = 'fidelity'
            then 'gnumber'
        when custodian = 'tda'
            then 'rep_code'
        when custodian = 'pershing'
            then 'investment_professional_number'
        else null
        end::text(100)                                             as link_type
  , case
        when custodian = 'schwab' and _type ilike 'sl'
            then 'sl_master'
        when custodian = 'schwab' and _type ilike 'fa'
            then 'fa_master'
        when custodian = 'fidelity' and _type ilike 'primary'
            then 'primary'
        when custodian = 'fidelity' and _type ilike 'secondary'
            then 'secondary'
        when custodian = 'tda' and _type ilike 'oip'
            then 'oip'
        when custodian = 'tda'
            then 'primary'
        when custodian = 'pershing'
            then 'investment_professional_number'
        else null
        end::text(100)                                             as link_subtype
  , _type                                                          as link_subtype_detail
    --, null::text(200)                                                as custodian_link_description
  , _description                                                   as description
  , _notes                                                         as notes
  , _location_code                                                 as location_code
  , _office_location                                               as location_code_note
  , _advisor_email                                                 as advisor_email
  , _status                                                        as status
  , case when _hq_master_code ilike 'y' then 1 else 0 end          as is_hq_master_code
  , case when _trading_authority ilike 'trading' then 1 else 0 end as has_trading_authority
  , case when _prime_broker ilike 'y' then 1 else 0 end            as is_prime_broker
  , _data_feed                                                     as data_feed

  , _pricing                                                       as pricing
  , _third_party_managed                                           as third_party_managed
  , _rpp_wa_or_san                                                 as rpp_wa_or_san
  , _open_date                                                     as open_date
  , _one_mariner_transition                                        as one_mariner_transition
  , _vendor_transmission                                           as vendor_transmission
  , _old_rep_code                                                  as old_rep_code
  , _options_level_approval                                        as options_level_approval
  , _standing_linking_instructions                                 as standing_linking_instructions
  , _statement_preferences                                         as statement_preferences
  , _box_file_id                                                   as _box_file_id
  , _box_sheet_name                                                as _box_sheet_name
  , _created_at                                                    as _source_loaded_at
from cte_codes
qualify row_number() over(partition by _custodian_key, _link order by _created_at desc) = 1
