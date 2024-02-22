CREATE DATABASE bookstoreDW collate Latin1_General_CI_AS;
GO

USE bookstoreDW
GO

/*CREATE TABLE Prasa
(
	ID_Prasa INTEGER IDENTITY(1,1) PRIMARY KEY,
	Tytu³ varchar(100) UNIQUE NOT NULL,
	CzêstotliwoœæWydawania nvarchar(128),
	Numer nvarchar(20),
	PrzedzialCenowy nvarchar(20),
)
GO

CREATE TABLE Sprzedaz_prasy
(
    Ilosc INTEGER NOT NULL,
    Cena_kupna DECIMAL(10,4),
    Zysk DECIMAL(10,4),
    ID_Prasy INTEGER FOREIGN KEY REFERENCES Prasa,
    ID_Data_Sprzedazy INTEGER FOREIGN KEY REFERENCES Data,
	ID_Data_Oplacenia INTEGER FOREIGN KEY REFERENCES Data,
	ID_Sprzedawcy INTEGER FOREIGN KEY REFERENCES Sprzedawca,
	ID_Smieci INTEGER FOREIGN KEY REFERENCES Smieci,
	ID_Czasu INTEGER FOREIGN KEY REFERENCES Czas,
	NumerTransakcji varchar(15),
)
GO*/



CREATE TABLE [Time](
	ID_Time INTEGER IDENTITY(1,1) PRIMARY KEY,
	[Hour] INTEGER UNIQUE NOT NULL,
	TimeOfDay varchar(20) NOT NULL,
	CONSTRAINT chk_TimeOfDay CHECK (TimeOfDay IN ('between 0 and 8', 'between 9 and 12', 'between 13 and 15', 'between 16 and 20', 'between 21 and 23'))
)
GO

CREATE TABLE Bookstore(
	ID_Bookstore INTEGER IDENTITY(1,1) PRIMARY KEY,
	BookstoreName varchar(20),
	Province varchar(20),
	City varchar(20),
	SizeCategory varchar(20),
	CONSTRAINT chk_SizeCategory CHECK (SizeCategory IN ('small', 'average', 'big'))
)
GO

CREATE TABLE Seller(
	ID_Seller INTEGER IDENTITY(1,1) PRIMARY KEY,
	PID varchar(11),
	NameAndSurname varchar(50),	--was 128
	AgeCategory varchar(20),
	Education varchar(20),
	IsCurrent BIT,
	EmploymentPosition varchar(15),	--was 20
	WorkExperience varchar(30),		--was 20
	Boss INTEGER FOREIGN KEY REFERENCES Seller,
	ID_Bookstore INTEGER FOREIGN KEY REFERENCES Bookstore,
	CONSTRAINT chk_AgeCategory CHECK (AgeCategory IN ('between 15 and 17', 'between 18 and 21', 'between 22 and 29', 'between 30 and 49', 
								'between 50 and 64','more than 64')),
	CONSTRAINT chk_Education CHECK (Education IN ('vocational', 'incomplete secondary', 'secondary', 'incomplete higher', 'higher', 'doctorate')),
	CONSTRAINT chk_EmploymentPosition CHECK (EmploymentPosition IN ('seller', 'director')),
	CONSTRAINT chk_WorkExperience CHECK (WorkExperience IN ('up to one year', 'between one and five years', 'more than five years'))
)
GO

CREATE TABLE Book
(
	ID_Book INTEGER IDENTITY(1,1) PRIMARY KEY,
	ISBN varchar(17) NOT NULL,	--was 20
	Genre varchar(15),			--was nvarchar
	Title varchar(30),			--was nvarchar
	PriceCategory varchar(15),	--was nvarchar
	CONSTRAINT chk_Genre CHECK (Genre IN ('encyclopedia', 'album', 'fantasy', 'other', 'informatics', 'magazine',
												'history', 'language', 'cooking', 'drama', 'poetry', 'thriller')),
	CONSTRAINT chk_PriceCategory CHECK (PriceCategory IN ('occasion', 'cheap', 'typical', 'expensive', 'absurd'))
)
GO

CREATE TABLE [Date]
(
    ID_Date INTEGER IDENTITY(1,1) PRIMARY KEY,
    [Date] date unique,
	[Year] varchar(4),
	[Month] varchar(10),			--was 15
	MonthNo	tinyint,
	[DayOfWeek] varchar(10),		--was 15
	DayOfWeekNo tinyint,
	WorkingDay varchar(15),			--was 128
	Vacation varchar(20),			--was 128
	Holiday varchar(50),			--was 128
	BeforeHolidayDay varchar(62),	--was 128
	CONSTRAINT chk_Month CHECK ([Month] IN ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')),
	CONSTRAINT chk_DayOfWeek CHECK ([DayOfWeek] IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
	CONSTRAINT chk_WorkingDay CHECK (WorkingDay IN ('day off', 'working day')),
	CONSTRAINT chk_Vacation CHECK (Vacation IN ('non-holiday', 'winter holiday', 'summer holiday'))
)
GO

CREATE TABLE Junk
(
	ID_Junk INTEGER IDENTITY(1,1) PRIMARY KEY,
	Position varchar(20),
	TypeOfPayment varchar(10),		--was 15
	CONSTRAINT chk_Position CHECK (Position IN ('information', 'main door', 'side door')),
	CONSTRAINT chk_TypeOfPayment CHECK (TypeOfPayment IN ('check', 'card', 'cash'))
)
GO

CREATE TABLE Book_sale
(
    Amount INTEGER NOT NULL,
    PurchasePrice MONEY,	--was DECIMAL(10,4)
    Profit AS PurchasePrice * 0.07,			--was DECIMAL(10,4)
    ID_Book INTEGER FOREIGN KEY REFERENCES Book,
    ID_SaleDate INTEGER FOREIGN KEY REFERENCES [Date],
	ID_PaymentDate INTEGER FOREIGN KEY REFERENCES [Date],
	ID_Seller INTEGER FOREIGN KEY REFERENCES Seller,
	ID_Junk INTEGER FOREIGN KEY REFERENCES Junk,
	ID_Time INTEGER FOREIGN KEY REFERENCES [Time],
	TransactionNo varchar(15),		--not 10
)
GO

CREATE TABLE Author
(
	ID_Author INTEGER IDENTITY(1,1) PRIMARY KEY,
	NameAndSurname varchar(75),	--was 128
)
GO

CREATE TABLE Authorship
(
	ID_Author INTEGER FOREIGN KEY REFERENCES Author,
	ID_Book INTEGER FOREIGN KEY REFERENCES Book,
)
GO

