SET IDENTITY_INSERT dbo.DimSeller ON;  
GO 
INSERT INTO dbo.DimSeller(
	  SellerKey
	, PID
	, NameAndSurname
	, AgeRange
	, Education
	, EntryDate
	, ExpiryDate
	, IsCurrent
	, Position
	, WorkExperience
	, BossKey
	, BookstoreKey
	, isBoss) 
Values(-1, 'UNKNOWN', 'UNKNOWN', '', '', '1980-01-01', NULL, 1, '', '', NULL, NULL, 0);
go