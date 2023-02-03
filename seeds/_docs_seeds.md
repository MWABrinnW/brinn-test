{% docs holidays_description %}
List of market holidays.
```
from pandas.tseries.holiday import nearest_workday, AbstractHolidayCalendar, Holiday, USMartinLutherKingJr, USPresidentsDay, GoodFriday, USMemorialDay, USLaborDay, USThanksgivingDay
import pandas as pd

class USTradingHolidaysCalendar(AbstractHolidayCalendar):
    rules = [
        Holiday(
            'NewYearsDay',
            month=1,
            day=1,
            observance=nearest_workday
        ),
        USMartinLutherKingJr,
        USPresidentsDay,
        GoodFriday,
        USMemorialDay,
        Holiday(
            'Juneteenth National Independence Day',
            month=6,
            day=19,
            start_date='2021-06-18',
            observance=nearest_workday,
        ),
        Holiday(
            'USIndependenceDay',
            month=7,
            day=4,
            observance=nearest_workday
        ),
        USLaborDay,
        USThanksgivingDay,
        Holiday(
            'Christmas',
            month=12,
            day=25,
            observance=nearest_workday
        ),
    ]

cal = USTradingHolidaysCalendar()
holidays = cal.holidays(start='2000-01-01', end='2040-12-31')
```

{% enddocs %}