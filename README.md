# Northwind SQL Server Analysis & DBA Automation

## About This Project

This project demonstrates SQL Server database analysis and basic database administration skills using the Northwind trading database.

The project combines business-focused SQL analysis with database administration tasks and a Python automation script for monitoring SQL Server backup history.

The goal was to build a practical portfolio project that demonstrates my ability to query relational data, analyse business information, work with SQL Server database objects, perform database backups, and automate database reporting with Python.

## Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Python 3.14
- pyodbc
- Git & GitHub

## Database

The Northwind database is a sample trading database containing information about:

- Customers
- Orders
- Order Details
- Products
- Categories
- Suppliers
- Employees
- Shippers

## SQL Analysis

The northwind_analysis.sql file contains 21 SQL Server analysis queries and database administration tasks.

### Business Analysis Queries

The project demonstrates:

- SELECT statements
- Filtering with WHERE
- INNER JOIN and LEFT JOIN
- Aggregate functions
- GROUP BY
- HAVING
- Subqueries
- NOT EXISTS
- Date functions
- CASE expressions
- ORDER BY
- Revenue calculations

### Advanced SQL

The project also includes:

- ROW_NUMBER()
- PARTITION BY
- Window functions
- Running totals
- Common Table Expressions (CTEs)

### SQL Server Database Objects

The project demonstrates creating and using:

- SQL Server Views
- Stored Procedures

### Database Administration

The project includes:

- Full SQL Server database backups
- SQL Server backup history queries
- Backup type identification
- Backup size reporting
- Backup monitoring using the `msdb` database

## Python Backup Reporting Automation

The project includes a Python script:

`Python/backup_report.py`

The script connects to SQL Server using `pyodbc` and retrieves backup history from:

`msdb.dbo.backupset`

The script:

1. Connects to the Northwind SQL Server database.
2. Retrieves the latest backup records.
3. Identifies the most recent backup.
4. Displays backup information in the terminal.
5. Generates a formatted backup report.
6. Saves the report to the `Reports` directory.

Example information included in the report:

- Database name
- Backup start time
- Backup finish time
- Backup type
- Backup size

## Project Structure

```text
northwind-sql-portfolio
│
├── Python
│   └── backup_report.py
│
├── Reports
│   └── backup_report.txt
│
├── northwind_analysis.sql
│
└── README.md

```


## How to Run the SQL Analysis
1. Install Microsoft SQL Server and SQL Server Management Studio (SSMS).
2. Restore or attach the Northwind database.
3. Open northwind_analysis.sql in SSMS.
4. Make sure the Northwind database is available.
5. Run the queries individually to explore the analysis.

Some sections create SQL Server objects such as views and stored procedures.

## How to Run the Python Report
### Requirements
- Python 3.14 or compatible Python version
- SQL Server
- ODBC Driver for SQL Server
- pyodbc

### Installation

Install pyodbc using:
```bash
pip install pyodbc
```

### Run the script
```bash
py .\Python\backup_report.py
```
The script connects to the local SQL Server instance using Windows authentication and generates a backup report in:

Reports/backup_report.txt

## Skills Demonstrated

This project demonstrates practical experience with:

- SQL Server
- SSMS
- Relational database querying
- SQL joins
- Aggregation and grouping
- HAVING
- Subqueries
- NOT EXISTS
- Window functions
- CTEs
- CASE expressions
- Views
- Stored Procedures
- Database backup
- Backup monitoring
- Python database connectivity
- pyodbc
- Basic database automation
- Git and GitHub

## Project Outcome

This project helped me strengthen my SQL Server skills while developing practical database administration skills.

The combination of SQL analysis, database objects, backup operations, and Python automation demonstrates how database skills can be applied beyond writing individual queries.

## Author
Lindokuhle Nkosi
BCom Information Systems Student
Aspiring Database Administrator