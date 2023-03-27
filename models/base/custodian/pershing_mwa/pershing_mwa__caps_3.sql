-- depends_on: {{ ref('create_udfs_pershing') }}
{{ caps_3(source('pershing_mwa', 'caps')) }}