select *
from {{ ref('redtail_network__base_contact_udfs') }}
pivot (max(field_value) for contact_udf_field_name in (
    'Account Aggregation System' , 'Basic Data Last Verified(person/date)' , 'Books checked out' , 'Branch ID - NON OSJ'
    , 'Branch ID - NON OSJ - #2' , 'Branch ID - NON OSJ - #3' , 'Branch ID - NON OSJ - #4' , 'Branch ID - OSJ'
    , 'Branch ID - Satellite Office' , 'CRD #' , 'CRM System' , 'Club Level 2012' , 'Current BD'
    , 'Designated IAR (PAA Program)' , 'Docupace Username' , 'Employing Rep (name)' , 'Entity ID'
    , 'Entity Name' , 'FP Software' , 'Fidelity G#' , 'Hybrid Rep ID' , 'Hybrid Secondary ID 1'
    , 'Hybrid Secondary ID 2' , 'Hybrid Secondary ID 3' , 'Hybrid Secondary ID 4' , 'Institutional PAA ID'
    , 'Insurance License (#/State)' , 'Insurance Only Rep ID'
    , 'LPL Affiliation Date ' , 'Master Rep ID' , 'Models' , 'MoneyGuidePro Username' , 'NLA LPL ID'
    , 'Network Alliance Fee ($)' , 'PCS Bill Rate' , 'PCS Last Quarterly AUM' , 'PCS Last Quarterly Fees'
    , 'Previous BD' , 'Priority 1' , 'Priority 2' , 'Priority 3' , 'RIA Hybrid Firm LPL ID'
    , 'RIA Hybrid Firm Name' , 'RPCP (yes)' , 'Recruit Approx GDC' , 'Rehire Date' , 'Schwab LPL ID'
    , 'Schwab Master Account Number(s)' , 'Secondary Rep ID' , 'Secondary Rep ID 1' , 'Secondary Rep ID 2'
    , 'Secondary Rep ID 3' , 'Secondary Rep ID 4' , 'Secondary Rep ID 5' , 'Secondary Rep ID 6'
    , 'Sig Gar Stamp (#)' , 'Split Rep ID' , 'Split Rep ID 1' , 'Split Rep ID 10' , 'Split Rep ID 11'
    , 'Split Rep ID 12' , 'Split Rep Id 2' , 'Split Rep Id 3' , 'Split Rep Id 4' , 'Split Rep Id 5'
    , 'Split Rep Id 6' , 'Split Rep Id 7' , 'Split Rep Id 8' , 'Split Rep Id 9' , 'Succession/Contingency Plan(yes/who with)'
    , 'TD Ameritrade Master Account Number' , 'Termination Date' , 'Transition Specialist' , 'Website Vendor'
))
