create database BillMaster
go

use BillMaster
go

create table Ksiazka(
	Isbn varchar(20) primary key,
	Tytul varchar(50) not null,
	Gatunek varchar(20) not null
)
go

create table Autor(
	IdAutora integer primary key,
	Imie1 varchar(20) not null,
	Imie2 varchar(20),
	Nazwisko varchar(30) not null
)
go

create table Autorstwo(
	FK_Ksiazka varchar(20) foreign key references Ksiazka,
	FK_Autor integer foreign key references Autor,
	primary key ("FK_Ksiazka", "FK_Autor")
)
go

create table Ksiegarnia(
	NumerIdentyfikacyjny integer primary key,
	Nazwa varchar(50) not null
)
go

create table Sprzedawca(
	Pesel varchar(11) primary key,
	Imie varchar(15) not null,
	Nazwisko varchar(30) not null
)
go

create table Rachunek(
	NrRachunku varchar(15) primary key,
	DataWystawienia datetime not null,
	DataOplacenia datetime not null,
	Stanowisko varchar(50) not null,
	Platnosc varchar(15) not null,
	FK_Sprzedawca varchar(11) foreign key references Sprzedawca not null,
	FK_Ksiegarnia integer foreign key references Ksiegarnia not null
)
go

create table SprzedazKsiazki(
	FK_Ksiazka varchar(20) foreign key references Ksiazka,
	FK_Rachunek varchar(15) foreign key references Rachunek,
	Cena decimal(6, 2) not null,
	LiczbaEgzemplarzy integer not null,
	primary key ("FK_Ksiazka", "FK_Rachunek")
)
go

