USE HDsoftware
GO

IF (object_id('vETLDimJunk') is not null) DROP VIEW vETLDimJunk;

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
    VALUES (ST.Plan_płatności);

DROP VIEW vETLDimJunk;