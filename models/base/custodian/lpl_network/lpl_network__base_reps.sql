select
    repid                                    as rep_id
  , lastname                                 as last_name
  , firstname                                as first_name
  , middlename                               as middle_name
  , businessphoneno::int                     as business_phone_no
  , businessphonenoextension                 as business_phone_no_extension
  , ssntin                                   as ssn_tin
  , isssn::int                               as is_ssn
  , crd                                      as crd
  , branchid                                 as branch_id
  , osjbranchid                              as osj_branch_id
  , branchmanagerrepid                       as branch_manager_rep_id
  , businessaddress1                         as business_address_1
  , businessaddress2                         as business_address_2
  , businesscity                             as business_city
  , businessstate                            as business_state
  , businesszipcode                          as business_zip_code
  , mailingaddress1                          as mailing_address_1
  , mailingaddress2                          as mailing_address_2
  , mailingcity                              as mailing_city
  , mailingstate                             as mailing_state
  , mailingzipcode                           as mailing_zip_code
  , mailingphoneno::int                      as mailing_phone_no
  , homephoneno::int                         as home_phone_no
  , reptypedescription                       as rep_type_description
  , masterrepid                              as mater_rep_id
  , osjmanagerrepid                          as osj_manager_rep_id
  , emailaddress                             as email_address
  , repstatuscode                            as rep_status_code
  , try_to_date(repstatusdate, 'MM/DD/YYYY') as rep_status_date
  , try_to_date(approveddate, 'MM/DD/YYYY')  as approved_date
  , isadvisorformcomplete::int               as is_advisor_form_complete
  , isblockedsecondaryrepid::int             as is_blocked_secondary_rep_id
  , {{ col_is_head(reference=source('lpl_network', 'rep')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                     as effective_date
  , _created_at::timestamp                   as _source_loaded_at
  , _source_file
from {{ source('lpl_network', 'rep') }}
