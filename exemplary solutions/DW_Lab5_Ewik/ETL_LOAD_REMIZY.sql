USE AKCJE_DW
GO

If (object_id('vETLDimRemizyDane') is not null) Drop View vETLDimRemizyDane;
GO
CREATE VIEW vETLDimRemizyDane
AS
SELECT DISTINCT
	[Miejscowosc] = [Miejscowosc],
	[Numer] = [Numer]
FROM AKCJE_STRAZY_POZARNEJ.dbo.Remizy;
GO

MERGE INTO Remiza AS TT
USING vETLDimRemizyDane AS ST
ON TT.Miejscowosc = ST.Miejscowosc
AND TT.Numer = ST.Numer
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Miejscowosc, Numer)
    VALUES (ST.Miejscowosc, ST.Numer)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

Drop View vETLDimRemizyDane;