USE DW_bookstore_test
GO

If (object_id('vETLDimBooksData') is not null) Drop View vETLDimBooksData;
go
CREATE VIEW vETLDimBooksData
AS
SELECT DISTINCT
	[isbn],
	[gatunek] as [genre],
	[tytul] as [title],
	CASE
		WHEN [Cena] < 20 THEN 'tania'
		WHEN [Cena] BETWEEN 21 AND 100 THEN 'umiarkowana'
		ELSE 'droga'
	END AS [PriceRange]
FROM [BillMaster].dbo.[Ksiazka]
JOIN [BillMaster].dbo.[SprzedazKsiazki] on [BillMaster].dbo.[SprzedazKsiazki].[FK_Ksiazka] = [BillMaster].dbo.[Ksiazka].[Isbn];
;
go

MERGE INTO DimBook as TT
	USING vETLDimBooksData as ST
		ON TT.isbn = ST.isbn
		AND TT.genre = ST.genre
		AND TT.title = ST.title
		AND TT.pricerange = ST.pricerange
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.isbn,
					ST.genre,
					ST.title,
					ST.PriceRange
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View vETLDimBooksData;