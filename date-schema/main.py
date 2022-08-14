import pandas as pd
import sqlalchemy.engine as sql_e

from utils.date_dimension import DateDimension
from utils.bank_holidays import BankHolidays


def write_to_database(dataframe: pd.DataFrame, table_name: str, sqlalchemy_engine: sql_e.Engine) -> None:
    """This needs to be significantly refactored -- need to sanitise the parameters."""
    sqlalchemy_engine.execute(statement=f"""DELETE FROM {table_name} WHERE True;""")
    dataframe.to_sql(
        name=table_name,
        con=sqlalchemy_engine,
        if_exists='append',
        index=False
    )


def main():
    engine = sql_e.create_engine('sqlite:///date-schema.db')
    date_dim = DateDimension(start='1980-01-01', end='2079-12-31')
    bank_hols = BankHolidays()

    write_to_database(date_dim.date_frame, 'dates', engine)
    write_to_database(bank_hols.bank_holiday_frame, 'bank_holidays', engine)


if __name__ == '__main__':
    main()
