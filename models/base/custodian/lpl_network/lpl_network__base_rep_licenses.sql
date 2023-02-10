
select
    repid         as rep_id
  , series01::int as series_01
  , series02::int as series_02
  , series03::int as series_03
  , series04::int as series_04
  , series05::int as series_05
  , series06::int as series_06
  , series07::int as series_07
  , series08::int as series_08
  , series09::int as series_09
  , series10::int as series_10
  , series11::int as series_11
  , series15::int as series_15
  , series16::int as series_16
  , series22::int as series_22
  , series24::int as series_24
  , series26::int as series_26
  , series27::int as series_27
  , series28::int as series_28
  , series30::int as series_30
  , series31::int as series_31
  , series39::int as series_39
  , series42::int as series_42
  , series51::int as series_51
  , series52::int as series_52
  , series53::int as series_53
  , series55::int as series_55
  , series62::int as series_62
  , series63::int as series_63
  , series64::int as series_64
  , series65::int as series_65
  , series66::int as series_66
  , series90::int as series_90
  , seriesap::int as series_ap
  , seriesla::int as series_la
  , series86::int as series_86
  , series87::int as series_87
  , {{ col_is_head(reference=source('lpl_network', 'replicense')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                       as effective_date
  , _created_at::timestamp                     as _source_loaded_at
  , _source_file
from {{ source('lpl_network', 'replicense') }}
