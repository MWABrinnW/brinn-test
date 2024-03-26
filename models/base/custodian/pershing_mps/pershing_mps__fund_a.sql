-- depends_on: {{ ref('pershing_udfs') }}
{{ fund_a(source('pershing_mps', 'fund')) }}