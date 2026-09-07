-- seed_data.sql
-- Sample data for the schema in schema.sql — small enough to read by eye,
-- large enough that the queries in queries.sql return interesting results.

INSERT INTO customers (first_name, last_name, email, city, signup_date) VALUES
('Ava',     'Johnson',  'ava.johnson@example.com',   'Charlotte',  '2025-01-12'),
('Liam',    'Smith',    'liam.smith@example.com',    'Charlotte',  '2025-02-03'),
('Noah',    'Williams', 'noah.williams@example.com', 'Raleigh',    '2025-02-20'),
('Emma',    'Brown',    'emma.brown@example.com',    'Atlanta',    '2025-03-05'),
('Olivia',  'Davis',    'olivia.davis@example.com',  'Charlotte',  '2025-03-18'),
('Ethan',   'Miller',   'ethan.miller@example.com',  'Raleigh',    '2025-04-02'),
('Sophia',  'Wilson',   'sophia.wilson@example.com', 'Atlanta',    '2025-04-22'),
('Mason',   'Moore',    'mason.moore@example.com',   'Charlotte',  '2025-05-09'),
('Isabella','Taylor',   'isabella.taylor@example.com','Raleigh',   '2025-06-14'),
('James',   'Anderson', 'james.anderson@example.com','Atlanta',    '2025-07-01');

INSERT INTO products (product_name, category, unit_price) VALUES
('Wireless Mouse',      'Electronics', 19.99),
('Mechanical Keyboard',  'Electronics', 59.99),
('USB-C Hub',            'Electronics', 24.99),
('Laptop Stand',         'Accessories', 34.99),
('Desk Lamp',            'Home',        22.50),
('Notebook (3-pack)',    'Office',       9.99),
('Ergonomic Chair',      'Furniture',  189.00),
('Standing Desk',        'Furniture',  349.00);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-06-01', 'completed'),
(1, '2025-08-14', 'completed'),
(2, '2025-06-05', 'completed'),
(3, '2025-06-10', 'cancelled'),
(4, '2025-06-18', 'completed'),
(5, '2025-07-02', 'completed'),
(5, '2025-08-20', 'pending'),
(6, '2025-07-09', 'completed'),
(7, '2025-07-15', 'completed'),
(8, '2025-07-22', 'cancelled'),
(9, '2025-08-01', 'completed'),
(10,'2025-08-05', 'completed'),
(2, '2025-08-11', 'completed'),
(3, '2025-08-19', 'completed'),
(4, '2025-08-28', 'pending');

-- order_items: (order_id, product_id, quantity)
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2), (1, 3, 1),
(2, 7, 1),
(3, 2, 1), (3, 4, 1),
(4, 5, 1),
(5, 8, 1), (5, 6, 3),
(6, 1, 1), (6, 2, 1), (6, 3, 1),
(7, 4, 2),
(8, 6, 5),
(9, 7, 1), (9, 3, 2),
(10, 5, 1),
(11, 2, 1),
(12, 1, 3), (12, 6, 2),
(13, 8, 1),
(14, 4, 1), (14, 5, 1),
(15, 3, 1);
