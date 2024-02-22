USE AKCJE_DW
GO

If (object_id('vETLDimZespolyDane') is not null) Drop View vETLDimZespolyDane;
GO
CREATE VIEW vETLDimZespolyDane
AS
SELECT  
	[Rodzaj_strazy] = 
		CASE 
            		WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN 'panstwowa'
            		WHEN ABS(CHECKSUM(NEWID())) % 3 = 1 THEN 'ochotnicza'
            		ELSE 'zakladowa'
        	END
FROM AKCJE_STRAZY_POZARNEJ.dbo.Zespoly;
GO

MERGE INTO Zespol as TT
	USING vETLDimZespolyDane as ST
		ON TT.Rodzaj_strazy = ST.Rodzaj_strazy
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.Rodzaj_strazy
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View vETLDimZespolyDane;