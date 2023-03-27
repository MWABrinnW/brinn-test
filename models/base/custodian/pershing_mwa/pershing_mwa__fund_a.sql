-- depends_on: {{ ref('create_udfs_pershing') }}
{{ fund_a(source('pershing_mwa', 'fund')) }}