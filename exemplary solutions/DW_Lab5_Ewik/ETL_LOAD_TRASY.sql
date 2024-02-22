USE AKCJE_DW
GO

If (object_id('vETLDimTrasyDane') is not null) Drop View vETLDimTrasyDane;
GO
CREATE VIEW vETLDimTrasyDane
AS
SELECT
	ID_trasy = Trasy.ID,
	[Nawierzchnia] = 
		CASE 
            		WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN 'utwardzona'
            		WHEN ABS(CHECKSUM(NEWID())) % 3 = 1 THEN 'nieutwardzona'
            		ELSE 'mieszana'
        	END
FROM AKCJE_STRAZY_POZARNEJ.dbo.Trasy;
GO

MERGE INTO Trasa as TT
	USING vETLDimTrasyDane as ST
		ON TT.ID_trasy = ST.ID_trasy
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.Nawierzchnia
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View vETLDimTrasyDane;