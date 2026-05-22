-- =============================================
-- Northwind Database SQL Analysis
-- Author: Lindokuhle 
-- Date: 17 May 2026
-- Database: PostgreSQL 18
-- Description: Business analysis queries on the Northwind trading company database
-- =============================================


/* Question 1
Retrieve all products  that are out of stock
Display: 
product_id,product_name,units_in_stock
*/


SELECT product_id,product_name,
	   units_in_stock
FROM products
WHERE units_in_stock = 0;

/*Question 2 
Show all customers from Germany including their company name,contact name and city*/


SELECT customer_id,
	   company_name,
	   contact_name,city
FROM customers
WHERE country = 'Germany';

/*Question 3
Find all orders that were shipped late(where shipped_date is greater than required_date)
SELECT * FROM orders;
*/

SELECT order_id, 
	   customer_id, 
	   required_date, 
	   shipped_date,
       shipped_date - required_date AS days_late
FROM orders
WHERE shipped_date > required_date;

/* Question 4 
Show each order with the customer's company name and the employee's first and last name who handled it
*/
/*
select * FROM customers;
select * from orders;
select * FROM employees;*/

SELECT  o.order_id,
		c.company_name,
		e.first_name,
		e.last_name
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN employees e ON o.employee_id = e.employee_id;

/*Question 5
List all products with their category name and supplier company name*/

/*select * from Products;
select * from suppliers;
select * from categories;*/

SELECT p.product_name,
	   c.category_name,
	   s.company_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;

/* Question 6
Show the top 5 customers who placed the most orders, displaying company name and order count*/
 
SELECT  c.company_name,
		COUNT(o.order_id) AS number_of_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY  c.company_name
ORDER BY number_of_orders DESC
LIMIT 5;

/*Question 7
Find the total revenue per category (revenue = quantity × unit_price in order_details, join with products and categories)*/

/*select * from Products;
select * from order_details;
select * from categories;*/

SELECT  c.category_name,
		SUM(od.quantity * od.unit_price) AS total_revenue_per_category
FROM  order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue_per_category DESC;

/* Question 8
Which employee made the most sales? Show their full name and total number of orders handled?

SELECT * FROM EMPLOYEES;
SELECT * FROM order_details;
SELECT * FROM orders; */

SELECT  CONCAT(e.last_name,' ',e.first_name) AS fullname,
        e.title,
		COUNT(o.order_id) AS total_orders_handled
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id,e.last_name,e.first_name,e.title
ORDER BY  total_orders_handled DESC
LIMIT 1;

/* Question 9
Find all customers who have never placed an order
Solution 1: Using Subquery (more readable)*/

SELECT c.company_name, c.contact_name, c.country
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT customer_id
    FROM orders
);

/* Solution 2: Using LEFT JOIN (better performance on large datasets)
 When the orders table has millions of rows, this approach is faster
because PostgreSQL doesn't need to run a separate subquery for each row*/

/* Both return the same results but LEFT JOIN scales better
 in production environments with large data volumes*/

SELECT c.company_name, c.contact_name, c.country
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


/*Questio 10
Show monthly order trends — total number of orders per month across all years*/


SELECT 
		EXTRACT (YEAR FROM order_date) AS year,
		EXTRACT (MONTH FROM order_date) AS month,
		COUNT(order_id) AS orders_per_month
		FROM orders 
		GROUP BY EXTRACT (YEAR FROM order_date),EXTRACT (MONTH FROM order_date)
		ORDER BY year DESC, month DESC;