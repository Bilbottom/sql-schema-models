"""Parse the UK Bank Holidays from the UK Government API."""
import json

import requests
import pandas as pd


class BankHolidays:
    def __init__(self, connect_on_init: bool = True):
        self._bank_holiday_frame = pd.DataFrame(columns=['division', 'title', 'date', 'notes', 'bunting'])
        if connect_on_init:
            self.set_bank_holiday_frame()

    @property
    def bank_holiday_frame(self):
        return self._bank_holiday_frame.rename({'date': 'full_date'}, axis='columns')

    @staticmethod
    def get_uk_bank_holidays() -> dict:
        """Return the UK bank holidays from the UK government website as a dict."""
        return json.loads(
            requests.request(
                'GET',
                'https://www.gov.uk/bank-holidays.json'
            ).text
        )

    def _parse_bank_holiday_division(self, division: str) -> pd.DataFrame:
        """Parse the specified division into a pandas dataframe."""
        return (
            pd.DataFrame
                .from_dict(self.get_uk_bank_holidays()[division]['events'])
                .assign(division=division)
        )

    def set_bank_holiday_frame(self) -> None:
        """Convert the UK bank holidays into a pandas dataframe."""
        self._bank_holiday_frame = pd.concat(
            [
                self.bank_holiday_frame,
                *[self._parse_bank_holiday_division(div) for div in self.get_uk_bank_holidays()]
            ]
        )
