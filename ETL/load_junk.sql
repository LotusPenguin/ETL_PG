USE HDsoftware
GO

If (object_id('vETLDimJunk') is not null) Drop View vETLDimJunk;
GO
CREATE VIEW vETLDimJunk
AS
SELECT DISTINCT
	[Plan_płatności] = [Plan_płatności]
FROM SoftwareDB.dbo.Umowy_licencyjne;
GO

MERGE INTO Junk AS TT
USING vETLDimJunk AS ST
ON TT.Plan_platnosci = ST.Plan_płatności
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Plan_platnosci)
    VALUES (ST.Plan_płatności)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

Drop View vETLDimJunk;