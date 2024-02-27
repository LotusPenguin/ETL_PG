import pyodbc
import os
import PYTHON.etl.config as config

database_connection_string = config.db_connection_data
connection = pyodbc.connect(database_connection_string)
db_cursor = connection.cursor()
insertname = "Insert.sql"

tables = ["Lokalizacje",
          "Sprzedawcy",
          "Klienci"]

os.chdir("bulks")

tables2 = ["Umowy_licencyjne",
           "Umowy_dystrybucyjne",
           "Faktury",
           "Dystrybucja"
]

def CreateBulkInsertQuerry(tableName, filename):
    return f"""
    USE SoftwareDB;
    BULK INSERT dbo.{tableName} 
    FROM '{os. getcwd()}\\{filename}' 
    WITH (FIELDTERMINATOR='|');
    """

def BulkInsertIntoDB(tablesName):
    try:
        for table in tablesName:
            db_cursor.execute(CreateBulkInsertQuerry(table, table+".bulk"))
            connection.commit()
            print("BULK INSERT completed successfully.")
    except Exception as e:
        print("Error during BULK INSERT:", e)

BulkInsertIntoDB(tables)

os.chdir("../DB_SQL")

# f = open(insertname,"r")
# filecontent = f.read()
# db_cursor.execute(str(filecontent))

os.system(f'sqlcmd /S {config.server_name} /d SoftwareDB -E -i Insert.sql -f 65001')

os.chdir("../bulks")

BulkInsertIntoDB(tables2)


connection.close()

exit()