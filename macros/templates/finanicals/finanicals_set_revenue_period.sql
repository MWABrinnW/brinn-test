{%- macro financials_set_revenue_period() -%}
    case
        -- Quarterly bills and on-cycle
        when billing_frequency ilike 'Quarterly' and is_intra_period_invoice = 0 then
            case
                -- If advance, get next quarter end date
                when billing_style ilike 'Advance' then
                    last_day(dateadd('Quarter', 1, fee_calculation_date), 'Quarter')
                -- If arrears, get current quarter end date
                when billing_style ilike 'Arrears' then
                    last_day(dateadd('Quarter', 0, fee_calculation_date), 'Quarter')
            end
        -- Quarterly bills and NOT on-cycle
        when billing_frequency ilike 'Quarterly' and is_intra_period_invoice = 1 then
            case
                -- If advance, get current quarter end date
                when billing_style ilike 'Advance' then
                    last_day(dateadd('Quarter', 0, fee_calculation_date), 'Quarter')
                -- If arrears, get current quarter end date
                when billing_style ilike 'Arrears' then
                    last_day(dateadd('Quarter', 0, fee_calculation_date), 'Quarter')
            end
        -- Monthly bills, and on-cycle
        when billing_frequency ilike 'Monthly' and is_intra_period_invoice = 0 then
            case
                -- If advance, get next month end date
                when billing_style ilike 'Advance' then
                    last_day(dateadd('Month', 1, fee_calculation_date), 'Month')
                -- If arrears, get current month end date
                when billing_style ilike 'Arrears' then
                    last_day(dateadd('Month', 0, fee_calculation_date), 'Month')
            end
        -- Monthly bills, and off-cycle
        when billing_frequency ilike 'Monthly' and is_intra_period_invoice = 1 then
            case
                -- If advance, get next month end date
                when billing_style ilike 'Advance' then
                    last_day(dateadd('Month', 0, fee_calculation_date), 'Month')
                -- If arrears, get current month end date
                when billing_style ilike 'Arrears' then
                    last_day(dateadd('Month', 0, fee_calculation_date), 'Month')
            end
        -- NOT quarterly or monthly bills, evaluate on-cycle or off-cycle
        when is_intra_period_invoice = 0 then
            case
                when billing_style ilike 'Advance' then
                    last_day(dateadd('Quarter', 1, fee_calculation_date), 'Quarter')
                when billing_style ilike 'Arrears' then
                    last_day(dateadd('Quarter', 0, fee_calculation_date), 'Quarter')
            end
        when is_intra_period_invoice = 1 then
            case
                when billing_style ilike 'Advance' then
                    last_day(dateadd('Quarter', 0, fee_calculation_date), 'Quarter')
                when billing_style ilike 'Arrears' then
                    last_day(dateadd('Quarter', 0, fee_calculation_date), 'Quarter')
            end
    end::date as revenue_period_end_date
{%- endmacro -%}
