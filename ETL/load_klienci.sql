USE HDsoftware
GO

If (object_id('vETLDimKlienci') is not null) Drop View vETLDimKlienci;
GO
CREATE VIEW vETLDimKlienci
AS
SELECT DISTINCT
	[Nazwa] = [Nazwa],
    [os_fiz_or_firma] = CASE WHEN [os_fiz_or_firma] = 'Firma' THEN 0 ELSE 1 END
FROM SoftwareDB.dbo.Klienci;
GO

MERGE INTO Klienci AS TT
USING vETLDimKlienci AS ST
ON TT.Nazwa = ST.Nazwa
AND TT.os_fiz_or_firma = ST.os_fiz_or_firma
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Nazwa,os_fiz_or_firma)
    VALUES (ST.Nazwa,ST.os_fiz_or_firma)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

Drop View vETLDimKlienci;