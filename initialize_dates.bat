chcp 1251
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_date.sql" -f 65001
pause