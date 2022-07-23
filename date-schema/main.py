import pandas as pd

from utils.database_connector import DatabaseConnector
from utils.date_dimension import DateDimension
from utils.bank_holidays import BankHolidays


def write_to_database(dataframe: pd.DataFrame, table_name: str, schema_name: str) -> None:
    """Truncate and append method for writing"""
    db_conn = DatabaseConnector()

    dataframe.to_sql(
        name=table_name,
        schema=schema_name,
        con=db_conn.sqlachemy_engine,
        if_exists='replace',
        index=False
    )


def main():
    # db_conn = DatabaseConnector()
    # date_dim = DateDimension(start='1980-01-01', end='2079-12-31')
    date_dim = DateDimension(start='2010-01-01', end='2011-01-01')
    bank_hols = BankHolidays()

    # date_dim.date_frame.to_csv('test-1.csv', index=False)
    # bank_hols.bank_holiday_frame.to_csv('test-2.csv', index=False)
    print(date_dim.date_frame)
    print(bank_hols.bank_holiday_frame)

    # write_to_database(
    #     dataframe=bank_holidays,
    #     table_name='raw_uk_bank_holidays',
    #     schema_name='dbo'
    # )


if __name__ == '__main__':
    main()
