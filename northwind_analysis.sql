USE Northwind;

--1. Customer Analysis

SELECT  
     c.company_name,
     c.contact_name,
	 c.city,
	 c.country
FROM  customers c
ORDER BY c.contact_name;

--2. Product Inventory by Unit Price
  
SELECT   
    p.product_name,
    p.unit_price,
	p.units_in_stock
FROM products p
ORDER BY p.unit_price DESC;

--3. Employee Directory

SELECT 
    CONCAT(e.last_name,' ',e.first_name) AS [Full Name],
    e.title,
	e.hire_date
FROM employees e;

--4. Supplier Informatiom

SELECT 
    s.company_name,
    s.country
FROM suppliers s

--5.Categories

SELECT  
    p.product_name,
	c.category_name
FROM products p
JOIN categories c 
    ON p.category_id = c.category_id;

--6.Top 10 Products by Sales Revenue
SELECT TOP 10
      p.product_id,
	  p.product_name, 
      SUM(od.unit_price * od.quantity) AS SalesRevenue
	  from products p
JOIN order_details od 
    ON p.product_id = od.product_id
GROUP BY  
    p.product_id,
    p.product_name
ORDER BY  SalesRevenue desc;

--7. Top 10 Customers by Total Purchase Value

SELECT TOP  10
    c.customer_id,
    c.company_name,
	SUM(od.unit_price * od.quantity) as TotalPurchaseValue
	  FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_details od 
    ON o.order_id = od.order_id
GROUP BY c.customer_id,
         c.company_name
ORDER BY TotalPurchaseValue DESC;

--8.Sales Revenue by Country

SELECT  
	c.country,
	SUM(od.unit_price * od.quantity) AS SalesRevenue
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_details od 
    ON o.order_id = od.order_id
GROUP BY c.country
ORDER BY SalesRevenue DESC;
	   
--9.Employee Order Performance

SELECT 
    e.employee_id,
    CONCAT(e.last_name,' ',e.first_name) AS FullName,
    COUNT(o.order_id) AS TotalOrdersHandled
FROM employees e
JOIN orders o 
    ON e.employee_id = o.employee_id
GROUP BY 
    e.employee_id,
    e.last_name,
    e.first_name
ORDER BY TotalOrdersHandled DESC;

--10.Products Above Average Price 

SELECT
     p.product_id,
     p.product_name,
     p.unit_price,
     (SELECT AVG(unit_price) FROM products)AS AverageProductPrice
     FROM products p
where unit_price > 
 ( 
    SELECT AVG(unit_price)
	FROM 
    products
  )
ORDER BY p.unit_price DESC;

--11.Customers With No Orders

SELECT
    c.customer_id,
    c.company_name,
    c.contact_name,
    c.country
	FROM customers c
WHERE  NOT EXISTS
(  
   SELECT 1
   FROM orders o
   WHERE c.customer_id = o.customer_id
);

--12.Categories With More Than 10 Products 

SELECT 
    c.category_name,
    COUNT(p.product_id) AS Total_products
FROM categories c
JOIN products p 
    ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 10
ORDER BY total_products DESC;

--13.Monthly Sales Trend

SELECT
    YEAR(o.shipped_date) AS SalesYear,
    DATENAME(MONTH, o.shipped_date) AS SalesMonth,
    SUM(od.unit_price * od.quantity) AS MonthlySales
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY
    YEAR(o.shipped_date),
    MONTH(o.shipped_date),
    DATENAME(MONTH, o.shipped_date)
ORDER BY
    YEAR(o.shipped_date),
    MONTH(o.shipped_date);

--14.Sales Revenue by Catergory 

SELECT 
      c.category_id,
      c.category_name,
      SUM(od.unit_price * od.quantity) AS TotalRevenue
      FROM categories c
      JOIN products p 
           ON c.category_id = p.category_id
      JOIN order_details od 
            ON p.product_id = od.product_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY TotalRevenue DESC;


--15.Best Selling Product in Each Category

WITH ProductSales AS
(
    SELECT
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name,
        SUM(od.unit_price * od.quantity) AS ProductRevenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY c.category_id
            ORDER BY SUM(od.unit_price * od.quantity) DESC,
            p.product_id
        ) AS RowNum

    FROM products p
    JOIN categories c
        ON p.category_id = c.category_id
    JOIN order_details od
        ON p.product_id = od.product_id

    GROUP BY
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name
)

SELECT
   category_id,
   category_name,
   product_id,
   product_name,
   ProductRevenue
FROM ProductSales
WHERE RowNum = 1;

--16.Running Total

WITH DailySales AS 

(    
   SELECT
       o.shipped_date,
       SUM(od.unit_price * od.quantity) AS DailySales
       FROM orders o
       JOIN order_details od 
              ON o.order_id = od.order_id
       WHERE o.shipped_date IS NOT NULL
       GROUP BY o.shipped_date

)
SELECT 
      shipped_date,
      DailySales,
      SUM(DailySales)
      OVER
       (  
           ORDER BY shipped_date  
       ) AS RunningTotal

FROM DailySales;
 
-- 17.Product Price Classification
SELECT 
    p.product_id,
    p.product_name,
    p.unit_price,
    CASE
        WHEN p.unit_price <= 10 THEN 'Cheap'
        WHEN p.unit_price  < 30 THEN  'Moderate'
        ELSE 'Expensive'
    END AS PriceCategory
FROM products p;

--18.Customer Purchase Summary view

GO 
CREATE VIEW  vw_CustomerPurchaseSummary AS

SELECT    
    c.customer_id,
    c.company_name,
    c.contact_name,
    c.city,
    c.country,
    SUM (od.unit_price * od.quantity) AS TotalPurchaseAmount
    FROM customers c
          JOIN orders o 
               ON c.customer_id = o.customer_id
          JOIN order_details od 
               ON o.order_id = od.order_id
          GROUP BY 
            c.customer_id,
            c.company_name,
            c.contact_name,
            c.city,
            c.country;
    
SELECT * FROM vw_CustomerPurchaseSummary

SELECT TOP 5 *
FROM vw_CustomerPurchaseSummary
ORDER BY TotalPurchaseAmount DESC;

--19.Return Sales For a Given Year
GO
CREATE PROCEDURE SalesForYear  
    @Year INT
 AS
 BEGIN
    SELECT 
        YEAR(o.shipped_date) AS SalesYear,
        SUM(od.unit_price * od.quantity) AS TotalSalesRevenue
        FROM orders o
        JOIN order_details od 
                   ON o.order_id = od.order_id
        WHERE YEAR(o.shipped_date) = @Year  
            AND o.shipped_date IS NOT NULL
        GROUP BY 
        YEAR(o.shipped_date);
 END;

 EXEC SalesForYear @year = 1997;

--20.Create NorthWwind Full Database Backup

GO
BACKUP DATABASE NORTHWIND
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\Backup\Northwind_Portfolio.bak'
WITH
    INIT,
    FORMAT,
    NAME = 'Northwind Portfolio Full Backup'
GO

--21. Northwind Backup History Report

USE msdb;
GO

SELECT TOP 10
        database_name,
        backup_start_date,
        backup_finish_date,
        CASE type
                WHEN 'D' THEN 'Full Database Backup'
                WHEN 'I' THEN 'Differential Backup'
                WHEN 'L' THEN 'Transaction Log Backup'
                ELSE 'Other'
        END AS BackupType,
     CAST(   
           backup_size/ 1024.0 /1024.0 
           AS DECIMAL (10,2)
        )AS BackupSizeMB
   FROM dbo.backupset
   WHERE database_name = 'Northwind'
   ORDER BY backup_finish_date DESC;

        
