# Northwind Database SQL Analysis

## About This Project
This project contains business analysis SQL queries written against the classic Northwind trading company database. It was built as part of my portfolio to demonstrate intermediate SQL skills using PostgreSQL.

## Author
**Lindokuhle Nkosi**  
Final Year BComIS Student  
Aspiring Database Administrator

## Tools Used
- PostgreSQL 18
- pgAdmin 4
- VS Code
- GitHub

## Database
The Northwind database simulates a trading company managing:
- Customers and Orders
- Products and Categories
- Employees and Suppliers
- Shippers and Territories

## Queries Covered
| # | Business Question |
|---|---|
| 1 | Retrieve all out of stock products |
| 2 | Find all customers from Germany |
| 3 | Find all late shipments |
| 4 | Orders with customer and employee details |
| 5 | Products with category and supplier info |
| 6 | Top 5 customers by order count |
| 7 | Total revenue per product category |
| 8 | Employee with the most sales |
| 9 | Customers who never placed an order |
| 10 | Monthly order trends across all years |

## Skills Demonstrated
- SELECT, WHERE, ORDER BY
- JOIN (LEFT JOIN, INNER JOIN)
- GROUP BY and HAVING
- Aggregate functions (COUNT, SUM, AVG)
- Subqueries
- Date functions (EXTRACT)
- Performance optimization (Subquery vs JOIN comparison)

## How to Run
1. Download and restore the Northwind database in PostgreSQL
2. Open the `northwind_analysis.sql` file in pgAdmin or VS Code
3. Run queries individually or all at once