"""
Define the database objects using Python classes inheriting from SQLAlchemy.

The mapping between the classes and database objects is:

- Transaction   -- transactions
- Item          -- transaction_items
- Payment       -- transaction_payments
- ItemCategory  -- transaction_item_categories
- PaymentMethod -- transaction_payment_methods

Don't use ``backref`` -- use ``back_populates`` instead:

- https://stackoverflow.com/questions/39869793/when-do-i-need-to-use-sqlalchemy-back-populates
"""
from sqlalchemy import ForeignKey, Column, Integer, String, Boolean, Float, create_engine
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
engine = create_engine(r"sqlite:///dummy-db.db", echo=True)
Session = sessionmaker(bind=engine)
session = Session()
Base.metadata.create_all(engine)


class Transaction(Base):
    __tablename__ = 'transactions'

    transaction_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    transaction_date = Column(String(10), nullable=False, index=True)
    transaction_value = Column(Float, nullable=False)
    transaction_item_count = Column(Integer, nullable=False)
    transaction_counterparty = Column(String, nullable=False)

    items = relationship('Item', back_populates='transaction')
    payments = relationship('Payment', back_populates='transaction')

    def __repr__(self):
        return f"<Transaction(" \
               f"transaction_id={self.transaction_id}, " \
               f"transaction_date='{self.transaction_date}', " \
               f"transaction_value={self.transaction_value}, " \
               f"transaction_counterparty='{self.transaction_counterparty}'" \
               f")>"

    def set_value_and_count(self):
        self.transaction_value = sum([item.item_value for item in self.items])
        self.transaction_item_count = len(self.items)
        payment_values = sum([payment.payment_value for payment in self.payments])
        if payment_values != self.transaction_value:
            raise ValueError(
                f'The transaction_value {self.transaction_value} does not equal '
                f'the sum of payment values {payment_values}'
            )


class Item(Base):
    __tablename__ = 'transaction_items'

    item_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    transaction_id = Column(Integer, ForeignKey('transactions.transaction_id'), index=True)
    item_name = Column(String, nullable=False)
    item_value = Column(Float, nullable=False)
    item_category = Column(String, ForeignKey('transaction_item_categories.category_name'), index=True)
    item_exclusion_flag = Column(Boolean, nullable=False, default=False)

    transaction = relationship('Transaction', back_populates='items', uselist=True)
    category = relationship('ItemCategory', back_populates='item')

    def __repr__(self):
        return f"<Item(" \
               f"item_id={self.item_id}, " \
               f"transaction_id={self.transaction_id}, " \
               f"item_name='{self.item_name}', " \
               f"item_value={self.item_value}, " \
               f"item_category='{self.item_category}', " \
               f"item_exclusion_flag={self.item_exclusion_flag}" \
               f")>"


class Payment(Base):
    __tablename__ = 'transaction_payments'

    payment_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    transaction_id = Column(Integer, ForeignKey('transactions.transaction_id'), index=True)
    payment_value = Column(Float, nullable=False)
    payment_method = Column(String, ForeignKey('transaction_payment_methods.payment_method_name'), index=True)

    transaction = relationship('Transaction', back_populates='payments')
    payment_method_fk = relationship('PaymentMethod', back_populates='payment', uselist=True)

    def __repr__(self):
        return f"<Payment(" \
               f"payment_id={self.payment_id}, " \
               f"transaction_id='{self.transaction_id}', " \
               f"payment_value={self.payment_value}, " \
               f"payment_method='{self.payment_method}'" \
               f")>"


class ItemCategory(Base):
    __tablename__ = 'transaction_item_categories'

    category_name = Column(String, primary_key=True, index=True, nullable=False)
    category_description = Column(String, nullable=False)
    category_last_used = Column(String(10))

    item = relationship('Item', back_populates='category')

    def __repr__(self):
        return f"<ItemCategory(" \
               f"category_name={self.category_name}, " \
               f"category_description='{self.category_description}', " \
               f"category_last_used={self.category_last_used}, " \
               f")>"


class PaymentMethod(Base):
    __tablename__ = 'transaction_payment_methods'

    payment_method_name = Column(String, primary_key=True, index=True, nullable=False)
    payment_method_type = Column(String, nullable=False)
    payment_method_description = Column(String, nullable=False)
    payment_method_last_used = Column(String(10))

    payment = relationship('Payment', back_populates='payment_method_fk')

    def __repr__(self):
        return f"<ItemCategory(" \
               f"category_name={self.category_name}, " \
               f"payment_method_type='{self.payment_method_type}', " \
               f"payment_method_description='{self.payment_method_description}', " \
               f"payment_method_last_used={self.payment_method_last_used}, " \
               f")>"
