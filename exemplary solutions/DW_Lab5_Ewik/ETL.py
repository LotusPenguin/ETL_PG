import pyodbc

sqlScriptsOrdered = [
    # 'DW tables.sql',
    # 'ETL_droping auxiliary tables.sql',
    # 'ETL_creating auxiliary tables.sql',

    # 'ETL_LOAD_TIME.sql',
    # 'ETL_vacation.sql',
    # 'ETL_LOAD_DROGI.sql',
    # 'ETL_LOAD_SAMOCHODY.sql',
    # 'ETL_LOAD_REMIZY.sql',
    # 'ETL_holidays.sql',
    # 'ETL_load_date.sql',
    # 'ETL_LOAD_STRAZACY.sql',
    # 'ETL_LOAD_TRASY.sql',
    # 'ETL_LOAD_ZESPOLY.sql',
    # 'ETL_LOAD_Uzyte_drogi.sql',
    # 'ETL_LOAD_KIEROWCY.sql',
    # 'ETL_LOAD_CZLONKOSTWO.sql',
    # 'ETL_LOAD_Dojazdy.sql'
    'ETL_droping auxiliary tables.sql',


    ]

# Set up the connection to your SQL Server
database_connection_string = 'DRIVER={SQL Server Native Client 11.0};SERVER=EWIK\\DW;DATABASE=AKCJE_DW;Trusted_Connection=yes;'
connection = pyodbc.connect(database_connection_string)
db_cursor = connection.cursor()
dropQueries = ["exec sp_MSforeachtable \"declare @name nvarchar(max); set @name = parsename('?', 1); exec sp_MSdropconstraints @name\"",
               "exec sp_MSforeachtable \"drop table ?\""]


for query in dropQueries:
    db_cursor.execute(query)
    db_cursor.commit()

for script in sqlScriptsOrdered:
    with open(script, 'r') as file:
        sql_scripts = file.read().split('GO')
        for sql_script in sql_scripts:
            db_cursor.execute(sql_script)
            db_cursor.commit()

db_cursor.close()
# Execute the SQL script
# cursor.execute(sql_script)
# conn.commit()  # Commit the changes (if needed)
# conn.close()   # Close the connection