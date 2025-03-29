## E-Commerce Database Project

This project creates a simple e-commerce database using **MySQL**. The database includes tables for **customers**, **orders**, **products**, and **order_items** (to normalize the data). It also includes sample data and several useful queries for data retrieval and management.

# Normalization Process
--Created a new table order_items to store product-level order details.
--Dropped the total_amount column from orders to eliminate redundancy.
--Total amount can now be computed dynamically using JOIN and SUM() queries.

# Queries:
--Retrieve all customers who have placed an order in the last 30 days.
--Get the total amount of all orders placed by each customer.
--Update the price of Product C to 45.00.
--Add a new column discount to the products table.
--Retrieve the top 3 products with the highest price.
--Get the names of customers who have ordered Product A.
--Join the orders and customers tables to retrieve the customer's name and order date for each order. 
--Retrieve the orders with a total amount greater than 150.00.
--Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.
--Retrieve the average total of all orders.


