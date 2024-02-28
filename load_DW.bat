chcp 1251
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_klienci.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_sprzedawcy.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_junk.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_date.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_programs.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_podpisanie_umowy_dystrybucyjnej.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "ETL\load_podpisanie_umowy_licencyjnej.sql" -f 65001
pause