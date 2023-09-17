
drop table if exists customers;
create table customers(
    customer_id text not null primary key,
    customer_type text not null check (customer_type in ('Business', 'Individual', 'Lending Group'))
);

drop table if exists customer_relationships;
create table customer_relationships(
    parent_customer_id text not null,
    child_customer_id text not null,
    relationship_type text not null check (relationship_type in ('Subsidiary', 'Director')),

    primary key (parent_customer_id, child_customer_id),
    foreign key (parent_customer_id) references customers(customer_id),
    foreign key (child_customer_id) references customers(customer_id)
);

drop table if exists loans;
create table loans(
    loan_id text not null primary key,
    loan_value real not null check (loan_value > 0),
    customer_id text not null references customers(customer_id)
);


insert into customers(customer_id, customer_type)
values
    ('BUS116595', 'Business'),
    ('BUS154890', 'Business'),
    ('BUS156044', 'Business'),
    ('BUS156544', 'Business'),
    ('BUS156548', 'Business'),
    ('BUS216549', 'Business'),
    ('BUS364265', 'Business'),
    ('BUS365265', 'Business'),
    ('BUS484532', 'Business'),
    ('BUS520654', 'Business'),
    ('BUS755902', 'Business'),
    ('IND154203', 'Individual'),
    ('IND450298', 'Individual'),
    ('IND454498', 'Individual'),
    ('IND459324', 'Individual'),
    ('IND549804', 'Individual'),
    ('IND744689', 'Individual'),
    ('IND752136', 'Individual'),
    ('IND986597', 'Individual'),
    ('IND996597', 'Individual'),
    ('LEN559852', 'Lending Group')
;


insert into customer_relationships(parent_customer_id, child_customer_id, relationship_type)
values
    ('LEN559852', 'BUS484532', 'Subsidiary'),
    ('LEN559852', 'BUS154890', 'Subsidiary'),
    ('BUS484532', 'BUS755902', 'Subsidiary'),
    ('BUS484532', 'BUS116595', 'Subsidiary'),
    ('BUS484532', 'IND744689', 'Director'),
    ('BUS154890', 'BUS365265', 'Subsidiary'),
    ('BUS154890', 'BUS156544', 'Subsidiary'),
    ('BUS755902', 'IND459324', 'Director'),
    ('BUS755902', 'IND752136', 'Director'),
    ('BUS755902', 'IND744689', 'Director'),
    ('BUS116595', 'IND744689', 'Director'),
    ('BUS365265', 'IND986597', 'Director'),
    ('BUS365265', 'IND454498', 'Director'),
    ('BUS156544', 'IND454498', 'Director'),
    ('BUS520654', 'BUS156548', 'Subsidiary'),
    ('BUS520654', 'BUS216549', 'Subsidiary'),
    ('BUS156548', 'IND154203', 'Director'),
    ('BUS156548', 'IND549804', 'Director'),
    ('BUS216549', 'IND549804', 'Director'),
    ('BUS364265', 'IND996597', 'Director'),
    ('BUS364265', 'IND450298', 'Director'),
    ('BUS156044', 'IND450298', 'Director')
;


insert into loans(loan_id, loan_value, customer_id)
values
    ('LOA123046', 26000, 'BUS154890'),
    ('LOA156487', 113000, 'BUS154890'),
    ('LOA156489', 91000, 'BUS156548'),
    ('LOA326984', 103000, 'BUS755902'),
    ('LOA447741', 210000, 'BUS755902'),
    ('LOA549321', 229000, 'BUS154890'),
    ('LOA655489', 27000, 'BUS484532'),
    ('LOA989215', 189000, 'IND454498')
;
