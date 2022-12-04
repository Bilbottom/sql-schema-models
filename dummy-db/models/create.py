"""
Entry point for scripts to update the finances database

Model using SQLAlchemy ORM
"""
import models.models


# def create_transaction_1() -> models.Transaction:
def create_transaction_1():
    txn = models.models.Transaction(
        transaction_date="2020-01-01",
        transaction_counterparty="Party"
    )

    itm1 = models.models.Item(
        item_name='Something tasty',
        item_value=10,
        item_category='Food',
        item_exclusion_flag=False
    )
    itm2 = models.models.Item(
        item_name='Something else tasty',
        item_value=20,
        item_category='Food',
        item_exclusion_flag=True
    )
    pay1 = models.models.Payment(
        payment_value=10,
        payment_method='Santander'
    )
    pay2 = models.models.Payment(
        payment_value=20,
        payment_method='Cash'
    )
    txn.items.append(itm1)
    txn.items.append(itm2)
    txn.payments.append(pay1)
    txn.payments.append(pay2)
    txn.set_value_and_count()

    return txn


# def create_transaction_2() -> models.Transaction:
def create_transaction_2():
    txn = models.models.Transaction(
        transaction_date='2020-01-02',
        transaction_counterparty='Party2'
    )
    itm3 = models.models.Item(
        item_name='Something helpful',
        item_value=100,
        item_category='Household',
        item_exclusion_flag=False
    )
    itm4 = models.models.Item(
        item_name='Something else tasty',
        item_value=200,
        item_category='Household',
        item_exclusion_flag=True
    )
    txn.items.append(itm3)
    txn.items.append(itm4)
    pay3 = models.models.Payment(
        payment_value=300,
        payment_method='Cash'
    )
    txn.payments.append(pay3)
    txn.set_value_and_count()

    return txn


def add_dummy_data():
    session = models.models.Session()
    session.add(create_transaction_1())
    session.add(create_transaction_2())
    session.commit()


def main():
    add_dummy_data()

