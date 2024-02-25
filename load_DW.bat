chcp 1251
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "DW_SQL\drop_DW.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "DW_SQL\create_DW.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_klienci.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_sprzedawcy.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_junk.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_date.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_programs.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_podpisanie_umowy_dystrybucyjnej.sql" -f 65001
pause
sqlcmd /S BLAZEJ-PC /d HDsoftware -E -i "ETL\load_podpisanie_umowy_licencyjnej.sql" -f 65001
pause