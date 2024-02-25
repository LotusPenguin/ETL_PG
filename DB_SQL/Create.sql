USE SoftwareDB;

DROP TABLE IF EXISTS Dystrybucja;
DROP TABLE IF EXISTS Faktury;
DROP TABLE IF EXISTS Umowy_licencyjne;
DROP TABLE IF EXISTS Umowy_dystrybucyjne;
DROP TABLE IF EXISTS Programy;
DROP TABLE IF EXISTS Zlecenia;
DROP TABLE IF EXISTS Klienci;
DROP TABLE IF EXISTS Sprzedawcy;
DROP TABLE IF EXISTS Producenci_oprogramowania;
DROP TABLE IF EXISTS Lokalizacje;

CREATE TABLE Lokalizacje (
	ID int NOT NULL PRIMARY KEY IDENTITY (1,1),
	Kraj nvarchar(200) NOT NULL
)


CREATE TABLE Producenci_oprogramowania (
	ID int NOT NULL PRIMARY KEY IDENTITY (1,1),
	Nazwa_handlowa nvarchar(200) NOT NULL,
	Lokalizacja int NOT NULL REFERENCES Lokalizacje(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	Sektor_działalności varchar(200),
	Czy_aktywny char(3) CHECK (Czy_aktywny='TAK' OR Czy_aktywny='NIE') NOT NULL
)

CREATE TABLE Sprzedawcy (
	ID int NOT NULL PRIMARY KEY IDENTITY (1,1),
	Nazwa nvarchar(200) NOT NULL,
	Lokalizacja int NOT NULL REFERENCES Lokalizacje(ID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE Klienci (
	ID int NOT NULL PRIMARY KEY IDENTITY (1,1),
	os_fiz_or_firma varchar(20) CHECK (os_fiz_or_firma='Osoba_fizyczna' OR os_fiz_or_firma='Firma') NOT NULL,
	Suma_należności money CHECK (Suma_należności >= 0.00 AND Suma_należności <= 1000000000.00) NOT NULL,
	Nazwa nvarchar(200) NOT NULL,
	Lokalizacja int NOT NULL REFERENCES Lokalizacje(ID) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE Zlecenia (
	Numer_umowy varchar(100) NOT NULL PRIMARY KEY,
	Data_złożenia date NOT NULL,
	Termin_realizacji date,
	Wytyczne_funkcjonalności ntext,
	Rodzaj_licencji varchar(50) NOT NULL,
	Kwota_należności money CHECK (Kwota_należności >= 0.00 AND Kwota_należności <= 1000000.00),
	Czy_zrealizowane char(3) CHECK (Czy_zrealizowane='TAK' OR Czy_zrealizowane='NIE') NOT NULL,
	ID_Producenta int NOT NULL REFERENCES Producenci_oprogramowania(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	ID_Klienta int NOT NULL REFERENCES Klienci(ID)
)

CREATE TABLE Programy (
	Nazwa_handlowa nvarchar(200) NOT NULL PRIMARY KEY,
	Aktualna_wersja varchar(50) NOT NULL,
	Platforma nvarchar(1000) NOT NULL,
	Rodzaj varchar(100),
	Opis ntext,
	Czy_wspierany char(3) CHECK (Czy_wspieranY='TAK' OR Czy_wspieranY='NIE') NOT NULL,
	Numer_zlecenia varchar(100) REFERENCES Zlecenia(Numer_umowy) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Data_wydania date,
	Data_zakończenia_wsparcia date,
	ID_Producenta int NOT NULL REFERENCES Producenci_oprogramowania(ID) ON UPDATE CASCADE ON DELETE CASCADE,
)


CREATE TABLE Umowy_dystrybucyjne (
	Nr_umowy varchar(100) NOT NULL PRIMARY KEY,
	ID_Sprzedawcy int NOT NULL REFERENCES Sprzedawcy(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	Data_zawarcia date CHECK (Data_zawarcia > '2022-12-14') NOT NULL,
	Data_wygaśnięcia date CHECK (Data_wygaśnięcia > '2022-12-14') NOT NULL
)

CREATE TABLE Umowy_licencyjne (
	Numer_umowy varchar(100) NOT NULL PRIMARY KEY,
	Data_zawarcia date NOT NULL,
	Data_wygaśnięcia date NOT NULL,
	Rodzaj_licencji varchar(50) NOT NULL,
	ID_Sprzedawcy int NOT NULL REFERENCES Sprzedawcy(ID) ON UPDATE CASCADE ON DELETE CASCADE,
	ID_Klienta int NOT NULL REFERENCES Klienci(ID),
	Kwota_płatności_okresowych money CHECK (Kwota_płatności_okresowych >= 0.00 AND Kwota_płatności_okresowych <= 1000000.00) NOT NULL,
	Plan_płatności varchar(50) NOT NULL,
	Nazwa_programu nvarchar(200) NOT NULL REFERENCES Programy(Nazwa_handlowa)
)

CREATE TABLE Faktury (
	Numer_faktury varchar(100) NOT NULL PRIMARY KEY,
	Data_wystawienia date NOT NULL,
	Termin_płatności date NOT NULL,
	Status_opłacenia char(3) CHECK (Status_opłacenia='TAK' OR Status_opłacenia='NIE') NOT NULL,
	Kwota_należności money CHECK (Kwota_należności >= 0.00 AND Kwota_należności <= 1000000.00) NOT NULL,
	Numer_umowy varchar(100) NOT NULL REFERENCES Umowy_licencyjne(Numer_umowy) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE Dystrybucja (
	Nr_umowy varchar(100) NOT NULL REFERENCES Umowy_dystrybucyjne(Nr_umowy) ON UPDATE CASCADE ON DELETE CASCADE,
	Nazwa_handlowa nvarchar(200) NOT NULL REFERENCES Programy(Nazwa_handlowa),
	PRIMARY KEY(Nr_umowy, Nazwa_handlowa)
)