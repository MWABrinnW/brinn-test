-- depends_on: {{ ref('create_udfs_pershing') }}
{{ actv_a(source('pershing_mps', 'actv')) }}