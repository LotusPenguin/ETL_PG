chcp 1251
sqlcmd /S BLAZEJ-PC /d SoftwareDB -E -i "DB_SQL\Drop.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d SoftwareDB -E -i "DB_SQL\Create.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d SoftwareDB -E -i "DB_SQL\Insert.sql" -f 65001
pause