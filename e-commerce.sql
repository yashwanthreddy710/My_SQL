-- creating Ecommerce Database
CREATE DATABASE Ecommerce; 

-- Selecting Ecommerce Database
USE Ecommerce;

-- creating table for customers
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(200) NOT NULL
);

-- inserting data into customers table
INSERT INTO customers (name, email, address)
VALUES 
('Prabhas', 'Prabhas@gmail.com', 'Hyderabad'),
('Surya', 'Surya@gmail.com', 'Chennai'),
('Yash', 'Yash@gmail.com', 'Bangalore');

-- creating table for orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

-- inserting data into orders table
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES 
(1, CURDATE(), 110.00),
(2, CURDATE() - INTERVAL 10 DAY, 185.00),
(3, CURDATE() - INTERVAL 40 DAY, 150.00);

-- creating table for products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT
);

-- inserting data into products table
INSERT INTO products (name, price, description)
VALUES 
('Product A', 25.00, 'Description of Product A'),
('Product B', 30.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C');


-- QUERIES

-- (1) Retrieve all customers who have placed an order in the last 30 days.
SELECT customers.name, orders.order_date 
FROM customers 
JOIN orders ON customers.id=orders.customer_id WHERE orders.order_date>=CURDATE()-INTERVAL 30 DAY;

-- (2)Get the total amount of all orders placed by each customer.
SELECT customers.name, SUM(orders.total_amount) AS total_amount_spent
FROM customers
LEFT JOIN orders ON customers.id=orders.customer_id   
GROUP BY customers.id;

--(3) Update the price of Product C to 45.00.
UPDATE products
SET price=45.00 WHERE name='Product C';

-- (4)Add a new column discount to the products table.
ALTER TABLE products
ADD COLUMN discount DECIMAL(10,2);   --adding a new column(discount) to the products table

UPDATE products 
SET discount=price*0.05;             -- 5% discount for product

-- (5)Retrieve the top 3 products with the highest price.
SELECT * FROM products
ORDER BY price DESC   --price by descending order
LIMIT 3;              --limiting the result to 3 products

-- (6)Get the names of customers who have ordered Product A.
CREATE TABLE order_items (                                                --creating a new table for order items
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,       --taking care of the relationship between orders and order_items
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE    --taking care of the relationship between products and order_items
);

INSERT INTO order_items (order_id, product_id, quantity)                 --inserting data into order_items table
VALUES 
(1,1,2), 
(2,2,1),
(3,1,3);

SELECT DISTINCT customers.name
FROM customers
JOIN orders ON customers.id=orders.customer_id                           -- joining customers and orders table
JOIN order_items ON orders.id=order_items.order_id                       -- joining orders and order_items table
JOIN products ON order_items.product_id=products.id                      -- joining order_items and products table
WHERE products.name='Product A';                                         -- filtering the result to get the names of customers who have ordered Product A

--(7) Join the orders and customers tables to retrieve the customer's name and order date for each order. 
SELECT orders.id,customers.name,orders.order_date
FROM customers
JOIN orders ON customers.id=orders.customer_id;                         -- joining customers and orders table

-- (8)Retrieve the orders with a total amount greater than 150.00.
SELECT * FROM orders
WHERE total_amount>150.00;                                              -- filtering the result to get the orders with a total amount greater than 150.00

-- (9)Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,                -- taking care of the relationship between orders and order_items
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE             -- taking care of the relationship between products and order_items
);

ALTER TABLE orders                                                                 -- updating the orders table to reference the order_items table
DROP COLUMN total_amount;

INSERT INTO order_items (order_id, product_id, quantity, price)                    -- inserting data into order_items table
VALUES 
(1,1,2,25.00),
(2,2,1,30.00),
(2,3,2,40.00);

--(10) Retrieve the average total of all orders.
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

ALTER TABLE orders
DROP COLUMN total_amount;

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES 
(1,1,2,25.00),
(2,2,1,30.00),
(2,3,2,40.00);

SELECT AVG(total) AS average_order_total                                -- calculating the average total of all orders and aliasing it as average_order_total
FROM (
    SELECT orders.id, SUM(order_items.quantity*order_items.price) AS total           -- calculating the total of all orders and aliasing it as total
    FROM orders
    JOIN order_items ON orders.id=order_items.order_id                               -- joining the orders and order_items tables
    GROUP BY orders.id                                                               -- grouping the result by orders id
)AS order_total;                                                                     -- aliasing the subquery result as order_total