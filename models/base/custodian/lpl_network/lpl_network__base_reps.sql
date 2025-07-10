select
    'lpl'                                                         as custodian
    , regexp_substr(_source_file , 'DFM-(.{4})-.*' , 1 , 1 , 'e') as subscriber_id
    , case
        when subscriber_id in ('R5TC' , '42LN' , '7PCM' , '86JN' , '86YM' , 'G44R' , 'G9CN' , 'H01M' , 'LH7H' , 'V0TK')
            then 'swag'
        else
            'network'
    end::varchar(50)                                              as firm_source
    , repid::varchar(200)                                         as rep_id
    , lastname::varchar(200)                                      as last_name
    , firstname::varchar(200)                                     as first_name
    , middlename::varchar(200)                                    as middle_name
    , businessphoneno::text(50)                                   as business_phone_no
    , businessphonenoextension::varchar(200)                      as business_phone_no_extension
    , ssntin::varchar(200)                                        as ssn_tin
    , isssn::int                                                  as is_ssn
    , crd::varchar(200)                                           as crd
    , branchid::varchar(200)                                      as branch_id
    , osjbranchid::varchar(200)                                   as osj_branch_id
    , branchmanagerrepid::varchar(200)                            as branch_manager_rep_id
    , businessaddress1::varchar(200)                              as business_address_1
    , businessaddress2::varchar(200)                              as business_address_2
    , businesscity::varchar(200)                                  as business_city
    , businessstate::varchar(200)                                 as business_state
    , businesszipcode::varchar(200)                               as business_zip_code
    , mailingaddress1::varchar(200)                               as mailing_address_1
    , mailingaddress2::varchar(200)                               as mailing_address_2
    , mailingcity::varchar(200)                                   as mailing_city
    , mailingstate::varchar(200)                                  as mailing_state
    , mailingzipcode::varchar(200)                                as mailing_zip_code
    , mailingphoneno::text(50)                                    as mailing_phone_no
    , homephoneno::text(50)                                       as home_phone_no
    , reptypedescription::varchar(200)                            as rep_type_description
    , masterrepid::varchar(200)                                   as master_rep_id
    , osjmanagerrepid::varchar(200)                               as osj_manager_rep_id
    , emailaddress::varchar(200)                                  as email_address
    , repstatuscode::varchar(200)                                 as rep_status_code
    , try_to_date(repstatusdate , 'MM/DD/YYYY')                   as rep_status_date
    , try_to_date(approveddate , 'MM/DD/YYYY')                    as approved_date
    , isadvisorformcomplete::int                                  as is_advisor_form_complete
    , isblockedsecondaryrepid::int                                as is_blocked_secondary_rep_id
    , institutionid::varchar(100)                                 as institution_id
    , institutionname::varchar(200)                               as institution_name
    , firmid::varchar(50)                                         as firm_id
    , branchcrd::varchar(100)                                     as branch_crd
    , parentorgid::varchar(50)                                    as parent_org_id
    , {{ col_is_head(reference=source('lpl_network', 'repext')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , effective_date::date                                        as effective_date
    , _created_at::timestamp                                      as _source_loaded_at
    , _source_file                                                as _source_file
from {{ source('lpl_network', 'repext') }}
