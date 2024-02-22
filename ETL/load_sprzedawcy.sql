USE HDsoftware
GO

IF (object_id('vETLDimSprzedawcy') is not null) DROP VIEW vETLDimSprzedawcy;

GO
CREATE VIEW vETLDimSprzedawcy
AS
SELECT DISTINCT
	[Nazwa] = [Nazwa]
FROM SoftwareDB.dbo.Sprzedawcy;
GO

MERGE INTO Sprzedawcy AS TT
USING vETLDimSprzedawcy AS ST
ON TT.Nazwa = ST.Nazwa
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Nazwa)
    VALUES (ST.Nazwa)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

DROP VIEW vETLDimSprzedawcy;