-- depends_on: {{ ref('create_udfs_pershing') }}
{{ isca_c(source('pershing_mwa', 'isca')) }}