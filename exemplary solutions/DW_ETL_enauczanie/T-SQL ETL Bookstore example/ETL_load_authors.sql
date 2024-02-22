USE DW_bookstore_test
GO

If (object_id('vETLDimAuthorsData') is not null) Drop View vETLDimAuthorsData;
go
CREATE VIEW vETLDimAuthorsData
AS
SELECT DISTINCT
	[IdAutora] as [AuthorID],
	[NameAndSurname] = Cast([Imie1] + ' ' + IsNull([Imie2] + ' ', '') + [Nazwisko] as nvarchar(128))
FROM BillMaster.dbo.Autor;
go

MERGE INTO DimAuthor as TT
	USING vETLDimAuthorsData as ST
		ON TT.NameAndSurname = ST.NameAndSurname
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.NameAndSurname
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View vETLDimAuthorsData;