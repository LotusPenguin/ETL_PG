use AKCJE_DW;
GO

If (object_id('vETLFUzyteDrogi') is not null) Drop view vETLFUzyteDrogi;
GO
CREATE VIEW vETLFUzyteDrogi
AS
SELECT
	ID_trasy = ST2.ID,
	ID_drogi = ST3.ID_drogi
FROM AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_trasy as ST1
JOIN Droga as ST3 on ST3.Miejscowosc = ST1.Miejscowosc AND ST3.Nazwa = ST1.Nazwa
JOIN AKCJE_STRAZY_POZARNEJ.dbo.Trasy ST2 on ST2.ID = ST1.ID
; 
GO

MERGE INTO Uzyte_drogi as TT
	USING vETLFUzyteDrogi as ST
		ON TT.ID_trasy = ST.ID_trasy
		AND TT.ID_drogi = ST.ID_drogi
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.ID_trasy,
					ST.ID_drogi
					)
			;


Drop view vETLFUzyteDrogi;