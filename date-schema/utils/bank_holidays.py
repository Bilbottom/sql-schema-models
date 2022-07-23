"""Grab the UK Bank Holidays from the Government API"""
import json

import requests
import pandas as pd


class BankHolidays(object):
    def __init__(self):
        self.bank_holiday_frame = pd.DataFrame(columns=['country', 'title', 'date', 'notes', 'bunting'])
        self.get_uk_bank_holidays()

    def get_uk_bank_holidays(self):
        """Get the UK bank holidays from the UK government website"""
        uk_bank_holidays = json.loads(
            requests.request(
                'GET',
                'https://www.gov.uk/bank-holidays.json'
            ).text
        )
        uk_bank_holidays_df = pd.DataFrame.from_dict(uk_bank_holidays['england-and-wales']['events'])
        uk_bank_holidays_df.loc[:, 'country'] = 'UK'
        self.bank_holiday_frame = pd.concat([self.bank_holiday_frame, uk_bank_holidays_df])
