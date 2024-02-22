sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_STRAZACY1.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_TRASY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_Uzyte_drogi.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_KIEROWCY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_Dojazdy.sql"
pause