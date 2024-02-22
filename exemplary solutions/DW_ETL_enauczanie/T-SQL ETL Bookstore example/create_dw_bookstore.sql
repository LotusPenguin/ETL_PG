use [DW_bookstore_test]
GO


CREATE TABLE DimTime(
	TimeKey INTEGER IDENTITY(1,1) PRIMARY KEY,
	Hour INTEGER UNIQUE NOT NULL,
	TimeOfDay varchar(20) NOT NULL,
)
GO

CREATE TABLE DimBookstore(
	BookstoreKey INTEGER IDENTITY(1,1) PRIMARY KEY,
	BookstoreID INTEGER,
	BookstoreName varchar(20),
	voivodeship varchar(20),
	city varchar(20),
	size varchar(20),
)
GO

CREATE TABLE DimSeller(
	SellerKey INTEGER IDENTITY(1,1) PRIMARY KEY,
	PID varchar(11),
	NameAndSurname varchar(128),
	AgeRange varchar(20),
	Education varchar(20),
	EntryDate datetime not null,
	ExpiryDate datetime,
	IsCurrent BIT,
	Position varchar(20),
	WorkExperience varchar(20),
	BossKey INTEGER FOREIGN KEY REFERENCES DimSeller,
	BookstoreKey INTEGER FOREIGN KEY REFERENCES DimBookstore,
	isBoss BIT
)
GO

CREATE TABLE DimBook
(
	BookKey INTEGER IDENTITY(1,1) PRIMARY KEY,
	ISBN varchar(20) NOT NULL,
	Genre nvarchar(128),
	Title nvarchar(128),
	PriceRange nvarchar(20),
)
GO

CREATE TABLE DimDate
(
    DateKey INTEGER IDENTITY(1,1) PRIMARY KEY,
    Date datetime unique,
	Year varchar(4),
	Month varchar(10),
	MonthNo int,
	DayOfWeek varchar(15),
	DayOfWeekNo int,
	WorkingDay varchar(128),
	Vacation varchar(128),
	Holiday varchar(128),
	BeforeHolidayDay varchar(128),
)
GO

CREATE TABLE DimJunk
(
	JunkKey INTEGER IDENTITY(1,1) PRIMARY KEY,
	Position varchar(20),
	TypeOfPayment varchar(15),
	CONSTRAINT UC_pos_type UNIQUE (Position,TypeOfPayment)
)
GO

CREATE TABLE FBookSales
(
    Amount INTEGER NOT NULL,
    PurchasePrice DECIMAL(10,4),
    Profit DECIMAL(10,4),
    BookKey INTEGER FOREIGN KEY REFERENCES DimBook,
    SellDateKey INTEGER FOREIGN KEY REFERENCES DimDate,
	PayDateKey INTEGER FOREIGN KEY REFERENCES DimDate,
	SellerKey INTEGER FOREIGN KEY REFERENCES DimSeller,
	JunkKey INTEGER FOREIGN KEY REFERENCES DimJunk,
	TimeKey INTEGER FOREIGN KEY REFERENCES DimTime,
	TransactionNo varchar(15),

	CONSTRAINT composite_pk PRIMARY KEY (
		BookKey,
		SellDateKey, 
		PayDateKey, 
		SellerKey, 
		JunkKey, 
		TimeKey, 
		TransactionNo
		)
)
GO

CREATE TABLE DimAuthor
(
	AuthorKey INTEGER IDENTITY(1,1) PRIMARY KEY,
	NameAndSurname varchar(128),
)
GO

CREATE TABLE FAuthorship
(
	AuthorKey INTEGER FOREIGN KEY REFERENCES DimAuthor,
	BookKey INTEGER FOREIGN KEY REFERENCES DimBook,
	CONSTRAINT authorship_pk PRIMARY KEY (AuthorKey, BookKey)
)
GO
