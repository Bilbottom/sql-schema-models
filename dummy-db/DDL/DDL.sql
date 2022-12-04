
/*
    Setting up a relational database for transactional data
    -------------------------------------------------------
*/

/*
    The only way that you can implement clustered indexes in SQLite is to:
        * Use INTEGER PRIMARY KEY as an alias for ROWID (which would AUTOINCREMENT, UNIQUE, and NON NULL)
        * Use WITHOUT ROWID after the closing parenthesis in the CREATE TABLE statement and PRIMARY KEY on the column(s)

    Don't forget to include the PRAGMA foreign_keys = ON statement each time a connection is made
*/

PRAGMA foreign_keys = ON;


/* raw 'copy' from the Excel version */
DROP TABLE IF EXISTS transactional_raw_data;
CREATE TABLE transactional_raw_data(
    transaction_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    item TEXT NOT NULL,
    cost REAL NOT NULL,
    category TEXT NOT NULL,
    retailer TEXT NOT NULL,
    payment_method TEXT NOT NULL,
    exclusions INTEGER NOT NULL
);


/*
    Reference Tables
*/
DROP TABLE IF EXISTS transaction_item_categories;
CREATE TABLE transaction_item_categories(
    category_name TEXT PRIMARY KEY,
    category_description TEXT NOT NULL,
    category_last_used TEXT
) WITHOUT ROWID;

DROP TABLE IF EXISTS transaction_payment_methods;
CREATE TABLE transaction_payment_methods(
    payment_method_name TEXT PRIMARY KEY,
    payment_method_type TEXT NOT NULL,
    payment_method_description TEXT NOT NULL,
    payment_method_last_used TEXT
) WITHOUT ROWID;


/*
    Data Tables
*/
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions(
    transaction_id INTEGER PRIMARY KEY,
    transaction_date TEXT NOT NULL CHECK(transaction_date GLOB '20[0-9][0-9]-[0-1][0-2]-[0-3][0-9]'),
    transaction_value REAL NOT NULL,
    transaction_item_count INTEGER NOT NULL CHECK(transaction_item_count > 0),
    transaction_counterparty TEXT NOT NULL /* renames from 'retailer' */
);
CREATE INDEX transaction_date_index
    ON transactions(transaction_date)
;

DROP TABLE IF EXISTS transaction_items;
CREATE TABLE transaction_items(
    item_id INTEGER PRIMARY KEY,
    transaction_id INTEGER REFERENCES transactions(transaction_id),
    item_name TEXT NOT NULL,
    item_value REAL NOT NULL,
    item_category TEXT REFERENCES transaction_item_categories(category_name),
    item_exclusion_flag BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE INDEX transaction_items_id_index
    ON transaction_items(transaction_id)
;
CREATE INDEX transaction_items_category_index
    ON transaction_items(item_category)
;

DROP TABLE IF EXISTS transaction_payments;
CREATE TABLE transaction_payments(
    payment_id INTEGER PRIMARY KEY,
    transaction_id INTEGER REFERENCES transactions(transaction_id),
    payment_value REAL NOT NULL,
    payment_method TEXT REFERENCES transaction_payment_methods(payment_method_name)
);
CREATE INDEX transaction_payments_index
    ON transaction_payments(transaction_id)
;
CREATE INDEX transaction_payments_method_index
    ON transaction_payments(payment_method)
;


-- DROP TABLE IF EXISTS transaction_travel_items;
-- CREATE TABLE transaction_travel_items(
--
-- );


-- /* for dashboard calculations */
-- DROP TABLE IF EXISTS wage_pay_days;
-- CREATE TABLE wage_pay_days(
--     company TEXT NOT NULL,
--     pay_date TEXT NOT NULL CHECK(pay_date GLOB '20[0-9][0-9]-[0-1][0-2]-[0-3][0-9]')
-- );


-- DROP TABLE IF EXISTS regular_transactions; -- not sure a table is best for this
-- CREATE TABLE regular_transactions(
--
-- );




/*
    Triggers
*/

/* category_last_used -- from INSERT */
DROP TRIGGER IF EXISTS transaction_item_category_last_used_insert;
CREATE TRIGGER transaction_item_category_last_used_insert
    INSERT ON transaction_items
BEGIN
    UPDATE transaction_item_categories
        SET category_last_used = (
            SELECT transaction_date FROM transactions
            WHERE transaction_id = NEW.transaction_id
        )
        WHERE category_name = NEW.item_category
    ;
END
;
/* category_last_used -- from UPDATE */
DROP TRIGGER IF EXISTS transaction_item_category_last_used_update;
CREATE TRIGGER transaction_item_category_last_used_update
    UPDATE OF item_category ON transaction_items
BEGIN
    UPDATE transaction_item_categories
        SET category_last_used = (
            SELECT transaction_date FROM transactions
            WHERE transaction_id = NEW.transaction_id
        )
        WHERE category_name = NEW.item_category
    ;
END
;

/* payment_method_last_used -- from INSERT */
DROP TRIGGER IF EXISTS transaction_payment_method_last_used_insert;
CREATE TRIGGER transaction_payment_method_last_used_insert
    INSERT ON transaction_payments
BEGIN
    UPDATE transaction_payment_methods
        SET payment_method_last_used = (
            SELECT transaction_date FROM transactions
            WHERE transaction_id = NEW.transaction_id
        )
        WHERE payment_method_name = NEW.payment_method
    ;
END
;
/* payment_method_last_used -- from UPDATE */
DROP TRIGGER IF EXISTS transaction_payment_method_last_used_update;
CREATE TRIGGER transaction_payment_method_last_used_update
    UPDATE OF payment_method ON transaction_payments
BEGIN
    UPDATE transaction_payment_methods
        SET payment_method_last_used = (
            SELECT transaction_date FROM transactions
            WHERE transaction_id = NEW.transaction_id
        )
        WHERE payment_method_name = NEW.payment_method
    ;
END
;


ANALYZE;
