USE AKCJE_DW

If (object_id('vETLDimDrogiDane') is not null) Drop View vETLDimDrogiDane;
GO

CREATE VIEW vETLDimDrogiDane
AS
SELECT DISTINCT
    [Nazwa] = [Nazwa],
    [Miejscowosc] = [Miejscowosc] 
FROM AKCJE_STRAZY_POZARNEJ.dbo.Drogi;

GO
MERGE INTO Droga as TT
    USING vETLDimDrogiDane as ST
        ON TT.Nazwa = ST.Nazwa
        AND TT.Miejscowosc = ST.Miejscowosc
            WHEN Not Matched
                THEN
                    INSERT
                    Values (
                    ST.Nazwa,
                    ST.Miejscowosc
                    )
            WHEN Not Matched By Source
                Then
                    DELETE
            ;

Drop View vETLDimDrogiDane;