chcp 1251
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "DW_SQL\drop_DW.sql" -f 65001
pause
sqlcmd /S Pingwin-Desktop /d HDsoftware -E -i "DW_SQL\create_DW.sql" -f 65001
pause