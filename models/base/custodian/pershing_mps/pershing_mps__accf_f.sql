-- depends_on: {{ ref('pershing_udfs') }}
{{ accf_f(source('pershing_mps', 'accf')) }}