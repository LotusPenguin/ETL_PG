chcp 1251
sqlcmd /S Pingwin-Desktop /d SoftwareDB -E -i "DB_SQL\Drop.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d SoftwareDB -E -i "DB_SQL\Create.sql" -f 65001
@REM pause
@REM sqlcmd /S Pingwin-Desktop /d SoftwareDB -E -i "DB_SQL\Insert.sql" -f 65001
pause