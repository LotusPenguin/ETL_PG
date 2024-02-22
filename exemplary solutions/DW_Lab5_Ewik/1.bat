py -m recreateDatabase
py -m bulkInsert
py -m ETL
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"drop DW.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"DW tables.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_creating auxiliary tables.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_TIME.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_vacation.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_holidays.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_load_date.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_DROGI.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_SAMOCHODY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_REMIZY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_STRAZACY1.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_TRASY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_ZESPOLY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_Uzyte_drogi.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_KIEROWCY.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_CZLONKOSTWO.sql"
sqlcmd /S EWIK\DW /d AKCJE_DW -E -i"ETL_LOAD_Dojazdy.sql"
pause