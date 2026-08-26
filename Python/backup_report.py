import pyodbc
from pathlib import Path

database_name = "Northwind"

try:
    connection = pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        f"DATABASE={database_name};"
        "Trusted_Connection=yes;"
    )

except pyodbc.Error as error:
    print("Database connection failed")
    print(f"Error: {error}")
    exit()

print(f"Connected to {database_name} database successfully!\n")

cursor = connection.cursor()

cursor.execute("""
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
        CAST(backup_size / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS BackupSizeMB
    FROM msdb.dbo.backupset
    WHERE database_name = ? 
    ORDER BY backup_finish_date DESC;
""",database_name)

results = cursor.fetchall()

if not results:
    print(f"No {database_name} backup records found")

else:
    latest_backup = results[0]
    latest_database, latest_start, latest_finish, latest_type, latest_size = latest_backup

    report = (
        f"{latest_database} Backup Report\n"
        "=============================================\n\n"
        "LATEST BACKUP\n"
        "---------------------------------------------\n"
        f"Database:      {latest_database}\n"
        f"Backup Finish: {latest_finish}\n"
        f"Backup Type:   {latest_type}\n"
        f"Backup Size:   {latest_size} MB\n"
        "---------------------------------------------\n\n"
        "BACKUP HISTORY\n"
        "---------------------------------------------\n"
    )

    for row in results:
        backup_database, backup_start, backup_finish, backup_type, backup_size = row

        report += (
            f"Database:      {backup_database}\n"
            f"Backup Start:  {backup_start}\n"
            f"Backup Finish: {backup_finish}\n"
            f"Backup Type:   {backup_type}\n"
            f"Backup Size:   {backup_size} MB\n"
            "---------------------------------------------\n"
        )

    print(report)

    from pathlib import Path

    project_folder = Path(__file__).resolve().parent.parent
    reports_folder = project_folder / "Reports"
    reports_folder.mkdir(exist_ok=True)

    report_file = reports_folder / "backup_report.txt"

    with open(report_file,"w",encoding="utf-8") as file:
        file.write(report)

cursor.close()
connection.close()



