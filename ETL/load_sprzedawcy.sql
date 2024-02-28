USE HDsoftware
GO

IF (object_id('vETLDimSprzedawcy') is not null) DROP VIEW vETLDimSprzedawcy;

GO
CREATE VIEW vETLDimSprzedawcy
AS
SELECT
	[Nazwa] = [Nazwa]
FROM SoftwareDB.dbo.Sprzedawcy;
GO

MERGE INTO Sprzedawcy AS TT
USING vETLDimSprzedawcy AS ST
ON TT.Nazwa = ST.Nazwa
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Nazwa)
    VALUES (ST.Nazwa);

DROP VIEW vETLDimSprzedawcy;