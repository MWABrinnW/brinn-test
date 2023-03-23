-- depends_on: {{ ref('create_udfs_pershing') }}
{{ caps_2(source('pershing_mwa', 'caps')) }}