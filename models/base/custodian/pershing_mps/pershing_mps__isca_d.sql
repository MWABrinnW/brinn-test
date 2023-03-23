-- depends_on: {{ ref('create_udfs_pershing') }}
{{ isca_d(source('pershing_mps', 'isca')) }}