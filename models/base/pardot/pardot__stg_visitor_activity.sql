select
    id
  , prospect_id
  , visitor_id
  , email_id
  , opportunity_id
  , visit_id
  , campaign_id
  , type
  , type_name
  , details
  , list_email_id
  , email_template_id
  , form_id
  , form_handler_id
  , site_search_query_id
  , landing_page_id
  , paid_search_ad_id
  , multivariate_test_variation_id
  , visitor_page_view_id
  , file_id
  , custom_redirect_id
  , created_at
  , _fivetran_synced
from {{ source('pardot', 'visitor_activity') }}