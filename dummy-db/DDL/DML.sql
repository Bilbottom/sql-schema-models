
/*
    Insert values into the  relational table for my transactional data
    ------------------------------------------------------------------
*/

DELETE FROM transactions WHERE True;
DELETE FROM transaction_items WHERE True;
DELETE FROM transaction_payments WHERE True;


PRAGMA foreign_keys = ON;


INSERT INTO transaction_item_categories(
    category_name,
    category_description
)
VALUES
    ('Alcohol', ''),
    ('Bills', ''),
    ('Clothing', ''),
    ('Council Tax', ''),
    ('Electronics', ''),
    ('Family Income', ''),
    ('Food', ''),
    ('Gift', ''),
    ('Household', ''),
    ('Interest', ''),
    ('Luxury', ''),
    ('Medicine', ''),
    ('Misc', ''),
    ('Recreation', ''),
    ('Rent', ''),
    ('Subscription', ''),
    ('Travel', ''),
    ('Uni', ''),
    ('Wage', '')
;


INSERT INTO transaction_payment_methods(
    payment_method_name,
    payment_method_type,
    payment_method_description
)
VALUES
    ('Cash',              'Cash',            ''),
    ('Barclays',          'Current Account', ''),
    ('Monzo',             'Current Account', ''),
    ('Nationwide',        'Current Account', ''),
    ('Santander',         'Current Account', ''),
    ('TSB',               'Current Account', ''),
    ('Jaja',              'Credit Card',     ''),
    ('Amazon',            'Online Wallet',   'Can be rewards, gift card, or credit from returns'),
    ('PayPal',            'Online Wallet',   ''),
    ('Curve (Santander)', 'Payment Medium',  ''),
    ('Paypal (Barclays)', 'Payment Medium',  ''),
    ('Oyster',            'Payment Card',    ''),
    ('PureCard',          'Rewards Card',    '')
;


ANALYZE;
